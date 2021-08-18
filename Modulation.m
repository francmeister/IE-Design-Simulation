%% Modulation order
M = 16;
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
txSig = qammod(txSig,M);

%% Setting Constellation Diagram object
cpts = qammod(0:M-1,M);
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
%% Feature Extraction

%% Training Classifier

%% Testing Classifier

%% Demodulation
z = qamdemod(txSig,M);
[num,rt] = symerr(x,z)

% Constellation Diagram
%constDiag(z)

