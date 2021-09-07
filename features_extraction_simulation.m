global gamma_max delta_aa kurtosis C_20 C_40 C_21 C_41 C_42 mod_type symPerFrame

C_20 = [];
C_21 = [];
C_40 = [];
C_41 = [];
C_42 = [];
mod_type = {};
symPerFrame = 1024;

populatesampleData(10)

%4-QAM
QAM4C_20 = (C_20(1)+ C_20(7)+ C_20(13)+ C_20(19)+ C_20(25)+ C_20(31)+ C_20(37)+ C_20(43)+ C_20(49)+ C_20(55))/10
QAM4C_21 = (C_21(1)+ C_21(7)+ C_21(13)+ C_21(19)+ C_21(25)+ C_21(31)+ C_21(37)+ C_21(43)+ C_21(49)+ C_21(55))/10
QAM4C_40 = (C_40(1)+ C_40(7)+ C_40(13)+ C_40(19)+ C_40(25)+ C_40(31)+ C_40(37)+ C_40(43)+ C_40(49)+ C_40(55))/10
QAM4C_41 = (C_41(1)+ C_41(7)+ C_41(13)+ C_41(19)+ C_41(25)+ C_41(31)+ C_41(37)+ C_41(43)+ C_41(49)+ C_41(55))/10
QAM4C_42 = (C_42(1)+ C_42(7)+ C_42(13)+ C_42(19)+ C_42(25)+ C_42(31)+ C_42(37)+ C_42(43)+ C_42(49)+ C_42(55))/10

%4-PSK
PSK4C_20 = (C_20(2)+ C_20(8)+ C_20(14)+ C_20(20)+ C_20(26)+ C_20(32)+ C_20(38)+ C_20(44)+ C_20(50)+ C_20(56))/10
PSK4C_21 = (C_21(2)+ C_21(8)+ C_21(14)+ C_21(20)+ C_21(26)+ C_21(32)+ C_21(38)+ C_21(44)+ C_21(50)+ C_21(56))/10
PSK4C_40 = (C_40(2)+ C_40(8)+ C_40(14)+ C_40(20)+ C_40(26)+ C_40(32)+ C_40(38)+ C_40(44)+ C_40(50)+ C_40(56))/10
PSK4C_41 = (C_41(2)+ C_41(8)+ C_41(14)+ C_41(20)+ C_41(26)+ C_41(32)+ C_42(38)+ C_41(44)+ C_41(50)+ C_41(56))/10
PSK4C_42 = (C_42(2)+ C_42(8)+ C_42(14)+ C_42(20)+ C_42(26)+ C_42(32)+ C_42(38)+ C_42(44)+ C_42(50)+ C_42(56))/10

%8-QAM
QAM8C_20 = (C_20(3)+ C_20(9)+ C_20(15)+ C_20(21)+ C_20(27)+ C_20(33)+ C_20(39)+ C_20(45)+ C_20(51)+ C_20(57))/10
QAM8C_21 = (C_21(3)+ C_21(9)+ C_21(15)+ C_21(21)+ C_21(27)+ C_21(33)+ C_21(39)+ C_21(45)+ C_21(51)+ C_21(57))/10
QAM8C_40 = (C_40(3)+ C_40(9)+ C_40(15)+ C_40(21)+ C_40(27)+ C_40(33)+ C_40(39)+ C_40(45)+ C_40(51)+ C_40(57))/10
QAM8C_41 = (C_41(3)+ C_41(9)+ C_41(15)+ C_41(21)+ C_41(27)+ C_41(33)+ C_41(39)+ C_41(45)+ C_41(51)+ C_41(57))/10
QAM8C_42 = (C_42(3)+ C_42(9)+ C_42(15)+ C_42(21)+ C_42(27)+ C_42(33)+ C_42(39)+ C_42(45)+ C_42(51)+ C_42(57))/10

%8-PSK
PSK8C_20 = (C_20(4)+ C_20(10)+ C_20(16)+ C_20(22)+ C_20(28)+ C_20(34)+ C_20(40)+ C_20(46)+ C_20(52)+ C_20(58))/10
PSK8C_21 = (C_21(4)+ C_21(10)+ C_21(16)+ C_21(22)+ C_21(28)+ C_21(34)+ C_21(40)+ C_21(46)+ C_21(52)+ C_21(58))/10
PSK8C_40 = (C_40(4)+ C_40(10)+ C_40(16)+ C_40(22)+ C_40(28)+ C_40(34)+ C_40(40)+ C_40(46)+ C_40(52)+ C_40(58))/10
PSK8C_41 = (C_41(4)+ C_41(10)+ C_41(16)+ C_41(22)+ C_41(28)+ C_41(34)+ C_41(40)+ C_41(46)+ C_41(52)+ C_41(58))/10
PSK8C_42 = (C_42(4)+ C_42(10)+ C_42(16)+ C_42(22)+ C_42(28)+ C_42(34)+ C_42(40)+ C_42(46)+ C_42(52)+ C_42(58))/10

%16-QAM
QAM16C_20 = (C_20(5)+ C_20(11)+ C_20(17)+ C_20(23)+ C_20(29)+ C_20(35)+ C_20(41)+ C_20(47)+ C_20(53)+ C_20(59))/10
QAM16C_21 = (C_21(5)+ C_21(11)+ C_21(17)+ C_21(23)+ C_21(29)+ C_21(35)+ C_21(41)+ C_21(47)+ C_21(53)+ C_21(59))/10
QAM16C_40 = (C_40(5)+ C_40(11)+ C_40(17)+ C_40(23)+ C_40(29)+ C_40(35)+ C_40(41)+ C_40(47)+ C_40(53)+ C_40(59))/10
QAM16C_41 = (C_41(5)+ C_41(11)+ C_41(17)+ C_41(23)+ C_41(29)+ C_41(35)+ C_41(41)+ C_41(47)+ C_41(53)+ C_41(59))/10
QAM16C_42 = (C_42(5)+ C_42(11)+ C_42(17)+ C_42(23)+ C_42(29)+ C_42(35)+ C_42(41)+ C_42(47)+ C_42(53)+ C_42(59))/10

%16-PSK
PSK16C_20 = (C_20(6)+ C_20(12)+ C_20(18)+ C_20(24)+ C_20(30)+ C_20(36)+ C_20(42)+ C_20(48)+ C_20(54)+ C_20(60))/10
PSK16C_21 = (C_21(6)+ C_21(12)+ C_21(18)+ C_21(24)+ C_21(30)+ C_21(36)+ C_21(42)+ C_21(48)+ C_21(54)+ C_21(60))/10
PSK16C_40 = (C_40(6)+ C_40(12)+ C_40(18)+ C_40(24)+ C_40(30)+ C_40(36)+ C_40(42)+ C_40(48)+ C_40(54)+ C_40(60))/10
PSK16C_41 = (C_41(6)+ C_41(12)+ C_41(18)+ C_41(24)+ C_41(30)+ C_41(36)+ C_41(42)+ C_41(48)+ C_41(54)+ C_41(60))/10
PSK16C_42 = (C_42(6)+ C_42(12)+ C_42(18)+ C_42(24)+ C_42(30)+ C_42(36)+ C_42(42)+ C_42(48)+ C_42(54)+ C_42(60))/10

function txSig = generateSignal(modOrder, symPerFrame)
    M = modOrder;
    txSig = randi([0 M-1],symPerFrame,1);
end

function txSig = modulation(modType, modOrder, txSig)
    global symPerFrame
    %% Modulation order
    M = modOrder;
    %% Bits per symbol
    bps = log2(M);
    
    %% Number of bits per frame
    bitsPerFrame = symPerFrame*bps;
    %% Modulate Signal
    if modType == 'QAM'
         txSig = qammod(txSig,M);
    else
         txSig = pskmod(txSig,M);
    end
end

function [f1 f2 f3 f4 f5] = feature_extraction(rxSig) 

    N = length(rxSig);
    
    %% High order cumulant features
    C_21 = sum((abs(rxSig)).^2)/N;
    C_20 = sum(rxSig.^2)/N;
    C_40 = sum(rxSig.^4)/N - C_20;
    C_41 = sum((rxSig.^3).*conj(rxSig))/N - C_20.*C_21;
    C_42 = sum((abs(rxSig).^4))/N - (abs(C_20)).^2 - 2*C_21.^2;
    f1 = abs(C_20);
    f2 = abs(C_21);
    f3 = abs(C_40);
    f4 = abs(C_41);
    f5 = abs(C_42);
end

function groupsampleData(f1,f2,f3,f4,f5,modType)
    global C_21 C_41 C_42 C_20 C_40 mod_type
    C_20 = [C_20;f1];
    C_21 = [C_21;f2];
    C_40 = [C_40;f3];
    C_41 = [C_41;f3];
    C_42 = [C_42;f3];
    mod_type = [mod_type;modType];
end

function saveToFile()
    global symPerFrame C_21 C_41 C_42 C_20 C_40 mod_type
    sampleData = table(C_20,C_21,C_40,C_41,C_42,mod_type);
    save 'sampleData.mat' sampleData, '-append';
end

function populatesampleData(num_of_frames)
    global symPerFrame C_21 C_41 C_42 C_20 C_40 mod_type
        
    for loop = 1:num_of_frames
        % 4-QAM
        modType = '4-QAM'; 
        M = 4;
        signal = generateSignal(M, symPerFrame)
        txSig = modulation('QAM', M, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,modType);
        
        % 4-PSK
        modType = '4-PSK'; 
        txSig = modulation('PSK', 4, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,modType);
        
        % 8-QAM
        modType = '8-QAM'; 
        M = 8;
        signal = generateSignal(M, symPerFrame);
        txSig = modulation('QAM', 8, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,modType);
        
        % 8-PSK
        modType = '8-PSK'; 
        txSig = modulation('PSK', 8, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,modType);
        
        % 16-QAM
        modType = '16-QAM'; 
        M = 16;
        signal = generateSignal(M, symPerFrame);
        txSig = modulation('QAM', 16, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
       groupsampleData(f1,f2,f3,f4,f5,modType);
                        
        % 16-PSK
        modType = '16-PSK'; 
        txSig = modulation('PSK', 16, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        groupsampleData(f1,f2,f3,f4,f5,modType);
        
        % 64-PSK
        modType = '64-PSK'; 
        txSig = modulation('PSK', 64, signal);
        [f1 f2 f3 f4 f5] = feature_extraction(txSig);
        %groupsampleData(f1,f2,f3,f4,f5,modType);
        
    end
    saveToFile()
end
