M = 16; % Modulation order
k = log2(M); % Bits/symbol
n = 20000; % Transmitted bits
nSamp = 4; % Samples per symbol
EbNo = 10; % Eb/No (dB)

span = 10; % Filter span in symbols
rolloff1 = 0.25; % Rolloff factor
rolloff2 = 1

txfilter1 = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff1, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

txfilter2 = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff2, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

rxfilter1 = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff1, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);

%fvtool(txfilter1, 'impulse');
%fvtool(txfilter2, 'impulse');
fvtool(txfilter1);
fvtool(txfilter2);
%legend('roll-off factor = 0.25')

