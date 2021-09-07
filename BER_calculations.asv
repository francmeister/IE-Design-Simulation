global symPerFrame

M = 16;                 % Modulation order
k = log2(M);            % Bits per symbol
EbNoVec = (5:15)';      % Eb/No values (dB)
symPerFrame = 1024;   % Number of QAM symbols per frame
berEst = zeros(size(EbNoVec));


for n = 1:length(EbNoVec)
    % Convert Eb/No to SNR
    snrdB = EbNoVec(n) + 10*log10(k);
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
    
    while numErrs < 200 && numBits < 1e5
    %while numBits < 1024
        % Generate binary data and convert to symbols
        dataSym = generateSignal(16, symPerFrame);
        dataIn = de2bi(dataSym,k);
        
        % QAM modulate using 'Gray' symbol mapping
        %txSig = qammod(dataSym,M);
        
        % Pass through AWGN channel
        %rxSig = awgn(txSig,snrdB,'measured');
        
        txSig = modulation('QAM', 16, dataSym, snrdB)
        % Demodulate the noisy signal
        rxSym = qamdemod(txSig,16);
        % Convert received symbols to bits
        dataOut = de2bi(rxSym,k);
        
        % Calculate the number of bit errors
        nErrors = biterr(dataIn,dataOut);
        
        % Increment the error and bit counters
        numErrs = numErrs + nErrors;
        numBits = numBits + symPerFrame*k;
    end
    
    % Estimate the BER
    berEst(n) = numErrs/numBits;
end

semilogy(EbNoVec,berEst,'o--r')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')

function txSig = generateSignal(modOrder, symPerFrame)
    M = modOrder;
    txSig = randi([0 M-1],symPerFrame,1);
end

function txSig = modulation(modType, modOrder, txSig, SNR)
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
    %% Pulse Shaping Tx Filter
    span = 10; % Filter span in symbols
    rolloff = 0.25; % Rolloff factor

    txFilter = comm.RaisedCosineTransmitFilter(...
        'RolloffFactor',rolloff, ...
        'FilterSpanInSymbols',span,...
        'OutputSamplesPerSymbol',bps);

    txSig = txFilter(txSig);
    
    %% Define Channel Impairments
    % Rayleigh Fading Channel
    rayChan = comm.RayleighChannel(...
        'SampleRate',2000, ...
        'PathDelays',[0 1.5e-5 3.2e-5],...
        'AveragePathGains',[0, -3, -3]);

    %Pass the signal through the fading channel
    %txSig = rayChan(txSig);
    
    %Additive White Gaussian Noise
    txSig = awgn(txSig, SNR, 'measured');
    
    %% Pulse Shaping Rx Filter
    rxFilter = comm.RaisedCosineReceiveFilter(...
        'RolloffFactor',rolloff, ...
        'FilterSpanInSymbols',span,...
        'InputSamplesPerSymbol',bps, ...
        'DecimationFactor',bps);

    % Pass signal into rxFilter
    txSig = rxFilter(txSig);
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