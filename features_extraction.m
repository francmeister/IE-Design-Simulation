%rxSig = [3 3 3 3 4 6 7 7 7]
%[a b c d e] = extractFeatures(rxSig)
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
    C_40 = sum(rxSig.^4)/N - 3*C_20;
    f4 = C_20;
    f5 = C_40;
end

function table = tabulateFeatures(f1,f2,f3,f4,f5)
    features = table(f1,f2,f3,f4,f5,'VariableNames',['gamma_max','delta_aa','kurtosis','C_20','C_40'])
end
