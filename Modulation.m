%% Collect features to be extracted into matrices
global gamma_max delta_aa kurtosis C_20 C_40 mod_type symPerFrame delta_a delta_ap delta_dp
gamma_max = [];
delta_aa = [];
delta_a = [];
delta_ap = [];
delta_dp = [];
kurtosis = [];
C_20 = [];
C_40 = [];
mod_type = {};

%% Define number of symbols per frame  
%symPerFrame = 1024;
%populatesampleData(200)
showStatistics()

% M = 16;
% cpts = qammod(0:M-1,M);
% constDiag = comm.ConstellationDiagram(...
%         'ReferenceConstellation',cpts, ...
%         'XLimits',[-4 4], ...
%         'YLimits',[-4 4]);
% 
% txSig = generateSignal(M, symPerFrame);  
% trainingSymbols_4qam =  qammod(randi([0 M-1],symPerFrame,1),M);
% txSig = modulation('QAM', M, txSig, trainingSymbols_4qam);
% constDiag(txSig);

function txSig = generateSignal(modOrder, symPerFrame)
    M = modOrder;
    txSig = randi([0 M-1],symPerFrame,1);
end

function txSig = modulation(modType, modOrder, txSig, trainingSymbols)
    global symPerFrame
    %% Modulation order
    M = modOrder;
    %% Bits per symbol
    bps = log2(M);
    
    %% Number of bits per frame
    bitsPerFrame = symPerFrame*bps;
    x = txSig;
    %% Modulate Signal
    if modType == 'QAM'
         txSig = qammod(txSig,M);
         cpts = qammod(0:M-1,M);
    else
         txSig = pskmod(txSig,M);
         cpts = pskmod(0:M-1,M);
    end
    tx = txSig;
    %% Setting Constellation Diagram object
    constDiag = comm.ConstellationDiagram(...
        'ReferenceConstellation',cpts, ...
        'XLimits',[-4 4], ...
        'YLimits',[-4 4]);

    %% Pulse Shaping Tx Filter
    span = 10; % Filter span in symbols
    rolloff = 0.25; % Rolloff factor

    txFilter = comm.RaisedCosineTransmitFilter(...
        'RolloffFactor',rolloff, ...
        'FilterSpanInSymbols',span,...
        'OutputSamplesPerSymbol',bps);

    % Plotting the impulse response of the htxFilter
    %fvtool(txFilter,'impulse');

    % Pass the signal through the txFilter
    %txSig = txFilter(txSig);
    %trainingSymbols = txFilter(trainingSymbols);
    
    %% Define Channel Impairments
    % Rayleigh Fading Channel
    rayChan = comm.RayleighChannel(...
        'SampleRate',2000, ...
        'PathDelays',[0 1.5e-5 3.2e-5],...
        'AveragePathGains',[0, -3, -3]);

    %Pass the signal through the fading channel
    %txSig = rayChan(txSig);
    %trainingSymbols = rayChan(trainingSymbols);

    % Additive White Gaussian Noise
    SNR = 15; % Will be varied
    txSig = awgn(txSig, SNR, 'measured');
    %trainingSymbols = awgn(trainingSymbols,SNR);

    %% Pulse Shaping Rx Filter
    rxFilter = comm.RaisedCosineReceiveFilter(...
        'RolloffFactor',rolloff, ...
        'FilterSpanInSymbols',span,...
        'InputSamplesPerSymbol',bps, ...
        'DecimationFactor',bps);

    % Pass signal into rxFilter
    %txSig = rxFilter(txSig);
    %trainingSymbols = rxFilter(trainingSymbols);
    
    %% Equalization
    % DFE Equalizer
    eqdfe = comm.DecisionFeedbackEqualizer(... 
        'Algorithm','LMS',...
        'NumForwardTaps',5, ...
        'NumFeedbackTaps',4,...
        'ForgettingFactor',0.3);
    
    % Linear Equalizer
    eq = comm.LinearEqualizer;
    eq.ReferenceTap = 1;
    mxStep = maxstep(eq,txSig);
    %[txSig,err,weights] = eq(txSig,tx);
    
    %[txSig,err,weights] = eqdfe(txSig,tx);
    %z = qamdemod(txSig,M)
    %[num,rt] = symerr(x,z)
end

function [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(rxSig) 
    %% maximum value of the spectral power density of the normalised-centred instantaneous amplitude 
    N = length(rxSig);
    m_a = sum(rxSig)/N;
    a_n = rxSig/m_a;
    a_cn = a_n - 1;
    gamma_max = max(abs((fft(a_cn))).^2)/N;
    f1 = gamma_max;
    
    %% standard deviation of the absolute value of the normalised-centred instantaneous amplitude
    A = sum(a_cn.^2)/N;
    B = (sum(abs(a_cn))/N).^2;
    delta_aa = sqrt(A-B);
    f2 = abs(delta_aa);
    
    %% standard deviation of the normalized and centred instantaneous amplitude
    A = sum(a_cn.^2)/N;
    B = (sum(a_cn)/N).^2;
    delta_a = sqrt(A-B);
    f3 = abs(delta_a);
    
    %% standard deviation of the absolute value of the non-linear component of the instantaneous phase
    A = sum((angle(rxSig)).^2)/N;
    B = (sum(abs(angle(rxSig)))/N).^2;
    delta_ap = sqrt(A-B);
    f4 = delta_ap;
    
    %% standard deviation of the non-linear component of the direct instantaneous phase
    A = sum((angle(rxSig)).^2)/N;
    B = (sum(angle(rxSig))/N).^2;
    delta_dp = sqrt(A-B);
    f5 = delta_dp;
    
    %% kurtosis of the normalized and centred instantaneous amplitude
    k = kurtosis(a_cn);
    f6 = abs(k);
    
    %% High order cumulant features
    C_20 = sum(rxSig.^2)/N;
    C_40 = sum(rxSig.^4)/N - C_20;
    f7 = abs(C_20);
    f8 = abs(C_40);
end

function groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType)
    global gamma_max delta_aa delta_a delta_ap delta_dp kurtosis C_20 C_40 mod_type
    gamma_max = [gamma_max;f1];
    delta_aa = [delta_aa;f2];
    delta_a = [delta_a;f3];
    delta_ap = [delta_ap;f4];
    delta_dp = [delta_dp;f5];
    kurtosis = [kurtosis;f6];
    C_20 = [C_20;f7];
    C_40 = [C_40;f8];
    mod_type = [mod_type;modType];
end

function saveToFile()
    global gamma_max delta_aa delta_a delta_ap delta_dp kurtosis C_20 C_40 mod_type
    sampleData = table(gamma_max,delta_aa,delta_a,delta_ap,delta_dp,kurtosis,C_20,C_40,mod_type);
    save 'sampleData.mat' sampleData, '-append';
end

function populatesampleData(num_of_frames)
    global symPerFrame
    
    %trainingSymbols 
    trainingSymbols_4qam =  qammod(randi([0 3],symPerFrame,1),4);
    trainingSymbols_8qam = qammod(randi([0 7],symPerFrame,1),8);
    trainingSymbols_16qam = qammod(randi([0 15],symPerFrame,1),16);
    trainingSymbols_4psk = qammod(randi([0 3],symPerFrame,1),4);
    trainingSymbols_8psk = qammod(randi([0 7],symPerFrame,1),8);
    trainingSymbols_16psk = qammod(randi([0 15],symPerFrame,1),16);
    
    for loop = 1:num_of_frames
        % 4-QAM
        modType = '4-QAM'; 
        M = 4;
        signal = generateSignal(M, symPerFrame);
        txSig = modulation('QAM', M, signal, trainingSymbols_4qam);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType);
        
        % 4-PSK
        modType = '4-PSK'; 
        txSig = modulation('PSK', 4, signal, trainingSymbols_4psk);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType);
        
        % 8-QAM
        modType = '8-QAM'; 
        M = 8;
        signal = generateSignal(M, symPerFrame);
        txSig = modulation('QAM', 8, signal, trainingSymbols_8qam);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType);
        
        % 8-PSK
        modType = '8-PSK'; 
        txSig = modulation('PSK', 8, signal, trainingSymbols_8psk);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType);
        
        % 16-QAM
        modType = '16-QAM'; 
        M = 16;
        signal = generateSignal(M, symPerFrame);
        txSig = modulation('QAM', 16, signal, trainingSymbols_16qam);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType);
                        
        % 16-PSK
        modType = '16-PSK'; 
        txSig = modulation('PSK', 16, signal, trainingSymbols_16psk);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,f6,f7,f8,modType);
        
        % 64-PSK
        modType = '64-PSK'; 
        txSig = modulation('PSK', 64, signal, trainingSymbols_16psk);
        [f1 f2 f3 f4 f5 f6 f7 f8] = feature_extraction(txSig);
        %groupsampleData(f1,f2,f3,f4,f5,modType);
        
       
    end
    saveToFile();
end

function showStatistics()
    load('sampleData.mat')
    

    % Make a histogram of known modulation types
    %histogram(sampleData.mod_type)

    % boxplot -  a simple way to visualize multiple distributions. This creates a plot where the boxes represent 
    % the distribution of the values of x for each of the classes in c. If the values of x are typically significantly 
    % different for one class than another, then x is a feature that can distinguish between those classes. The more 
    % features you have that can distinguish different classes, the more likely you are to be able to build an accurate 
    % classification model from the full data set.
    %boxplot(sampleData.gamma_max,sampleData.mod_type)
    %boxplot(sampleData.delta_aa,sampleData.mod_type)
    %boxplot(sampleData.delta_a,sampleData.mod_type)
    %boxplot(sampleData.delta_ap,sampleData.mod_type)
    %boxplot(sampleData.delta_dp,sampleData.mod_type)
    %boxplot(sampleData.kurtosis,sampleData.mod_type)
    %boxplot(sampleData.C_20,sampleData.mod_type)
    %boxplot(sampleData.C_40,sampleData.mod_type)
    
end