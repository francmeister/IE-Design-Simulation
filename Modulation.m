txSig = modulation('QAM', 16)
[f1 f2 f3 f4 f5] = feature_extraction(txSig)

%% Collect features to be extracted into matrices
gamma_max = [];
delta_aa = [];
kurtosis = [];
C_20 = [];
C_40 = [];
mod_type = [];

function txSig = modulation(modType, modOrder)
    %% Modulation order
    M = modOrder;
    %% Modulation type
    modType = 'QAM';
    %% Bits per symbol
    bps = log2(M);
    %% Number of frames per modulation type
    numFrames = 10000;
    %% Number of bits per frame
    bitsPerFrame = 1024;
    %% Symbols per frame
    symPerFrame = bitsPerFrame/bps;

    %% Generate random bits
    txSig = randi([0 M-1],bitsPerFrame,1);
    x = txSig;
    
    %% Modulate Signal
    if modType == 'QAM'
         txSig = qammod(txSig,M);
         cpts = qammod(0:M-1,M);
    else
         txSig = pskmod(txSig,M);
         cpts = pskmod(0:M-1,M);
    end
    
    %% Setting Constellation Diagram object
    constDiag = comm.ConstellationDiagram('ReferenceConstellation',cpts, ...
        'XLimits',[-4 4],'YLimits',[-4 4]);
    %constDiag(txSig)

    %% Pulse Shaping Tx Filter
    % Tx and Rx raised cosine filter
    span = 10; % Filter span in symbols
    rolloff = 0.25; % Rolloff factor

    txFilter = comm.RaisedCosineTransmitFilter(...
        'RolloffFactor',rolloff, ...
        'FilterSpanInSymbols',span,...
        'OutputSamplesPerSymbol',bps);

    % Plotting the impulse response of the htxFilter
    %fvtool(txFilter,'impulse');

    % Calculate the delay through the matched filters. The group delay is half of the filter span through 
    % one filter and is, therefore, equal to the filter span for both filters. Multiply by the number of bits 
    % per symbol to get the delay in bits.
    filtDelay = bps*span;
    errorRate = comm.ErrorRate('ReceiveDelay',filtDelay);

    % Demodulate the filtered signal and calculate the error statistics. The delay through the filters is accounted 
    % for by the ReceiveDelay property in errorRate.
    % rxsig = qamdemod(rxSig,M,'OutputType','bit');
    %errStat = errorRate(txSig,rxSig);
    %fprintf('\nBER = %5.2e\nBit Errors = %d\nBits Transmitted = %d\n',...
    %    errStat)

    % Pass the signal through the txFilter
    txSig = txFilter(txSig);

    %% Define Channel Impairments
    % Rayleigh Fading Channel
    rayChan = comm.RayleighChannel(...
        'SampleRate',100000, ...
        'PathDelays',[0 1.5e-5 3.2e-5],...
        'AveragePathGains',[0, -3, -3]);

    % Pass the signal through the fading channel
    txSig = rayChan(txSig); 

    % Additive White Gaussian Noise
    SNR = 10; % Will be varied
    txSig = awgn(txSig, SNR);

    %% Pulse Shaping Rx Filter
    rxFilter = comm.RaisedCosineReceiveFilter(...
        'RolloffFactor',rolloff, ...
        'FilterSpanInSymbols',span,...
        'InputSamplesPerSymbol',bps, ...
        'DecimationFactor',bps);

    % Pass signal into rxFilter
    txSig = rxFilter(txSig);
    constDiag(txSig)
    %% Equalization
    %lineq = comm.LinearEqualizer('Algorithm','CMA', ...
    %    'NumTaps',5,'ReferenceTap',3, ...
    %    'StepSize',0.03,'AdaptWeightsSource','Input port')

    %[y,err,wts] = lineq(txSig,adaptWeights)
end
%% Feature Extraction
[a b c d e] = feature_extraction(txSig)
%% Training Classifier

%% Testing Classifier

%% Demodulation

z = qamdemod(txSig,M);
txSig;
[num,rt] = symerr(x,z)

% Constellation Diagram
%constDiag(z)

function [f1 f2 f3 f4 f5] = feature_extraction(rxSig) 
    %% maximum value of the spectral power density of the normalised-centred instantaneous amplitude 
    N = length(rxSig);
    m_a = sum(rxSig)/N;
    a_n = rxSig/m_a;
    a_cn = a_n - 1;
    gamma_max = max(abs((fft(a_cn))).^2)/N;
    f1 = gamma_max;
    
    %% standard deviation of the absolute value of the normalised-centred instantaneous amplitude
    A = sum(a_cn.^2)/N;
    B = m_a^2;
    delta_aa = std(A-B);
    f2 = delta_aa;
    
    %% kurtosis of the normalized and centred instantaneous amplitude
    k = kurtosis(a_cn);
    f3 = k;
    
    %% High order cumulant features
    C_20 = sum(rxSig.^2)/N;
    C_40 = sum(rxSig.^4)/N - C_20;
    f4 = C_20;
    f5 = C_40;
end

function groupTrainData(f1,f2,f3,f4,f5,modType)
    gamma_max = [gamma_max f1];
    delta_aa = [delta_aa f2];
    kurtosis = [kurtosis f3];
    C_20 = [C_20 f4];
    C_40 = [C_40 f5];
    mod_type = [mod_type modType];
end

function saveToFile()
    sampleData = table(gamma_max,delta_aa,kurtosis,C_20,C_40,mod_type);
    save 'sampleData.mat' sampleData, '-append';
end

function populateTrainData(num_of_frames)
    for loop = 1:num_of_frames
        % 4-QAM
        modType = '4-QAM'; 
        txSig = modulation('QAM', 4);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = groupTrainData(f1,f2,f3,f4,f5,modType);
        
        % 8-QAM
        modType = '8-QAM'; 
        txSig = modulation('QAM', 8);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = groupTrainData(f1,f2,f3,f4,f5,modType);
        
        % 16-QAM
        modType = '16-QAM'; 
        txSig = modulation('QAM', 16);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = groupTrainData(f1,f2,f3,f4,f5,modType);
        
        % 4-PSK
        modType = '4-PSK'; 
        txSig = modulation('PSK', 4);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = groupTrainData(f1,f2,f3,f4,f5,modType);
        
        modType = '8-PSK'; 
        txSig = modulation('PSK', 8);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = groupTrainData(f1,f2,f3,f4,f5,modType);
        
        modType = '16-PSK'; 
        txSig = modulation('PSK', 16);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = groupTrainData(f1,f2,f3,f4,f5,modType);
    end
    saveToFile();
end
