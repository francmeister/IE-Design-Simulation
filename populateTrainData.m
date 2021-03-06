 gamma_max = [];
 delta_aa = [];
 kurtosis = [];
 C_20 = [];
 C_40 = [];
 mod_type = [];
function [gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type] = populate_train_data(f1,f2,f3,f4,f5,modType)
    gamma_max = [gamma_max f1];
    delta_aa = [delta_aa f2];
    kurtosis = [kurtosis f3];
    C_20 = [C_20 f4];
    C_40 = [C_40 f5];
    mod_type = [mod_type modType];
end

function sampleData = saveToFile(gamma_max, delta_aa, kurtosis, C_20, C_40, mod_type)
    sampleData = table(gamma_max,delta_aa,kurtosis,C_20,C_40,mod_type);
    save 'sampleData.mat' sampleData;
end