function results = ComputePowerandCoherencyMultiTaper(eegDat, regionNames,regionInfo, parTime, multitaperPar)
% This function uses chronux multitaper method to compute power for all
% regions and coherency among all of them
% eegDat is a list of 3d EEG matrix(samples x trials x channels) for
% different regions


results = table;
for rg1 = 1:(length(eegDat)-1)
    eegDatPost1 = eegDat{rg1}(parTime.startIdxPost:parTime.endIdxPost,:,:);
    eegDatPre1 = eegDat{rg1}(parTime.startIdxPre:parTime.endIdxPre,:,:);
    for  chIdx1 = 1:size(eegDatPost1,3)
        for rg2 = (rg1+1):length(eegDat)
            eegDatPost2 = eegDat{rg2}(parTime.startIdxPost:parTime.endIdxPost,:,:);
            eegDatPre2 = eegDat{rg2}(parTime.startIdxPre:parTime.endIdxPre,:,:);
            for  chIdx2 = 1:size(eegDatPost2,3)
                [cValPre,pVal1Pre,pVal2Pre,freqsPre] = ComputeSegmentedCoherency(eegDatPost1(:,:,chIdx1), eegDatPost2(:,:,chIdx2), multitaperPar);
                % plot(freqsPre,pVal1Pre(:,1));
                [cValPost,pVal1Post,pVal2Post,freqsPost] = ComputeSegmentedCoherency(eegDatPre1(:,:,chIdx1), eegDatPre2(:,:,chIdx2), multitaperPar);
                % plot(freqsPre,pVal1Post(:,1));
                temptab = table;
                temptab.Time = "Pre";
                temptab.Measure = "Coherency";
                temptab.Region = regionNames(rg1)+"_"+regionNames(rg2);
                temptab.Channel = regionInfo(rg1).lfpName(chIdx1)+"_"+regionInfo(rg2).lfpName(chIdx2);
                temptab.Freqs = {freqsPre};
                temptab.Value = {cValPre};
                results = vertcat(results,temptab);

                temptab = table;
                temptab.Time = "Post";
                temptab.Measure = "Coherency";
                temptab.Region = regionNames(rg1)+"_"+regionNames(rg2);
                temptab.Channel = regionInfo(rg1).lfpName(chIdx1)+"_"+regionInfo(rg2).lfpName(chIdx2);
                temptab.Freqs = {freqsPost};
                temptab.Value = {cValPost};
                results = vertcat(results,temptab);
            end
        end
    end
end


for rg1 = 1:(length(eegDat)-1)
    eegDatPost1 = eegDat{rg1}(parTime.startIdxPost:parTime.endIdxPost,:,:);
    eegDatPre1 = eegDat{rg1}(parTime.startIdxPre:parTime.endIdxPre,:,:);
    for  chIdx1 = 1:size(eegDatPost1,3)
        [~,pVal1Pre,~,freqsPre] = ComputeSegmentedCoherency(eegDatPost1(:,:,chIdx1), eegDatPost1(:,:,chIdx1), multitaperPar);

        [~,pVal1Post,~,freqsPost] = ComputeSegmentedCoherency(eegDatPre1(:,:,chIdx1), eegDatPre1(:,:,chIdx1), multitaperPar);

        temptab = table;
        temptab.Time = "Pre";
        temptab.Measure = "Power";
        temptab.Region = regionNames(rg1);
        temptab.Channel = regionInfo(rg1).lfpName(chIdx1);
        temptab.Freqs = {freqsPre};
        temptab.Value = {pVal1Pre};
        results = vertcat(results,temptab);

        temptab = table;
        temptab.Time = "Post";
        temptab.Measure = "Power";
        temptab.Region = regionNames(rg1);
        temptab.Channel = regionInfo(rg1).lfpName(chIdx1);
        temptab.Freqs = {freqsPost};
        temptab.Value = {pVal1Post};
        results = vertcat(results,temptab);
    end
end

end

