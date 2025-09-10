function [coherVal,powerVal1,powerVal2,freqs] = ComputeSegmentedCoherency(eeg1, eeg2, multitaperPar)
    params.Fs = multitaperPar.Fs;
    params.fpass = multitaperPar.Fpass; 
    params.pad = multitaperPar.pad;
    params.err = multitaperPar.err;
    params.trialave = multitaperPar.trialave;
    powerVal1 = [];
    powerVal2 = [];
    coherVal = [];
    freqs = [];
    for itt = 1:size(multitaperPar.tapers,1)
        params.tapers = multitaperPar.tapers(itt,:);
        params.fpass = multitaperPar.Fpass(itt,:);
        [C,~,~,S1,S2,f] = coherencyc(eeg1,eeg2,params);
        coherVal = cat(1,coherVal,C);
        powerVal1 = cat(1,powerVal1,S1);
        powerVal2 = cat(1,powerVal2,S2);
        freqs = cat(1,freqs,f');
    end
end