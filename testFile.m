M = 16; % Alphabet size, 16-QAM
x = randi([0 M-1],5000,1);

cpts = qammod(0:M-1,M);
constDiag = comm.ConstellationDiagram('ReferenceConstellation',cpts, ...
    'XLimits',[-4 4],'YLimits',[-4 4]);

y = qammod(x,M);
ynoisy = awgn(y,15,'measured');

z = qamdemod(ynoisy,M);
[num,rt] = symerr(x,z)

constDiag(y)