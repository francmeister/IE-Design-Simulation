M = 16; % Modulation order
k = log2(M); % Bits/symbol
n = 20000; % Transmitted bits
txSig = randi([0 M-1],n,1);

txSig = qammod(txSig,M);
cpts = qammod(0:M-1,M);

constDiag = comm.ConstellationDiagram(...
        'ReferenceConstellation',cpts, ...
        'XLimits',[-4 4], ...
        'YLimits',[-4 4]);
constDiag(txSig);
rayChan = comm.RayleighChannel(...
        'SampleRate',2000, ...
        'PathDelays',[0 1.5e-5 3.2e-5],...
        'AveragePathGains',[0, -3, -3]);
    
txSig = rayChan(txSig);
%constDiag(txSig);