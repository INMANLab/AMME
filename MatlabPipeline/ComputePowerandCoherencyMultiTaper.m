function results = ComputePowerandCoherencyMultiTaper(eegDat, regionNames,regionInfo, parTime, multitaperPar)
% This function uses chronux multitaper method to compute power for all
% regions and coherency among all of them
% eegDat is a list of 3d EEG matrix(samples x trials x channels) for
% different regions


results = table;
for rg1 = 1:(length(eegDat)-1)
    eegDatPost1 = eegDat{rg1}(parTime.startIdxPost:parTime.endIdxPost,:,:);
    eegDatPre1 = eegDat{rg1}(parTime.startIdxPre:parTime.endIdxPre,:,:);
    for rg2 = (rg1+1):length(eegDat)
        eegDatPost2 = eegDat{rg2}(parTime.startIdxPost:parTime.endIdxPost,:,:);
        eegDatPre2 = eegDat{rg2}(parTime.startIdxPre:parTime.endIdxPre,:,:);
        for  chIdx1 = 1:size(eegDatPost1,3)
            for  chIdx2 = 1:size(eegDatPost2,3)
                [cValPre,~,~,freqsPre] = ComputeSegmentedCoherency(eegDatPost1(:,:,chIdx1), eegDatPost2(:,:,chIdx2), multitaperPar);
                % plot(freqsPre,pVal1Pre(:,1));
                [cValPost,~,~,freqsPost] = ComputeSegmentedCoherency(eegDatPre1(:,:,chIdx1), eegDatPre2(:,:,chIdx2), multitaperPar);
                % plot(freqsPre,pVal1Post(:,1));
                cValPre = atanh(cValPre); %Fisher Z-transformed
                cValPost = atanh(cValPost); %Fisher Z-transformed


                temptab = table;
                temptab.EpochTime = "PreImage";
                temptab.Measure = "Coherency";
                temptab.Region = regionNames(rg1)+"_"+regionNames(rg2);
                temptab.ChName = regionInfo(rg1).lfpName(chIdx1)+"_"+regionInfo(rg2).lfpName(chIdx2);
                temptab.ChOrder = chIdx1+"_"+chIdx2;
                temptab.Freqs = {freqsPre};
                temptab.Value = {cValPre};
                results = vertcat(results,temptab);

                temptab = table;
                temptab.EpochTime = "PostImage";
                temptab.Measure = "Coherency";
                temptab.Region = regionNames(rg1)+"_"+regionNames(rg2);
                temptab.ChName = regionInfo(rg1).lfpName(chIdx1)+"_"+regionInfo(rg2).lfpName(chIdx2);
                temptab.ChOrder = chIdx1+"_"+chIdx2;
                temptab.Freqs = {freqsPost};
                temptab.Value = {cValPost};
                results = vertcat(results,temptab);
            end
        end
    end
end


for rg1 = 1:length(eegDat)
    eegDatPost1 = eegDat{rg1}(parTime.startIdxPost:parTime.endIdxPost,:,:);
    eegDatPre1 = eegDat{rg1}(parTime.startIdxPre:parTime.endIdxPre,:,:);
    for  chIdx1 = 1:size(eegDatPost1,3)
        [~,pVal1Pre,~,freqsPre] = ComputeSegmentedCoherency(eegDatPost1(:,:,chIdx1), eegDatPost1(:,:,chIdx1), multitaperPar);
        [~,pVal1Post,~,freqsPost] = ComputeSegmentedCoherency(eegDatPre1(:,:,chIdx1), eegDatPre1(:,:,chIdx1), multitaperPar);
        pVal1Pre = db(pVal1Pre,'power'); %Decibel
        pVal1Post = db(pVal1Post,'power'); %Decibel

        temptab = table;
        temptab.EpochTime = "PreImage";
        temptab.Measure = "Power";
        temptab.Region = regionNames(rg1);
        temptab.ChName = regionInfo(rg1).lfpName(chIdx1);
        temptab.ChOrder = chIdx1;
        temptab.Freqs = {freqsPre};
        temptab.Value = {pVal1Pre};
        results = vertcat(results,temptab);

        temptab = table;
        temptab.EpochTime = "PostImage";
        temptab.Measure = "Power";
        temptab.Region = regionNames(rg1);
        temptab.ChName = regionInfo(rg1).lfpName(chIdx1);
        temptab.ChOrder = chIdx1;
        temptab.Freqs = {freqsPost};
        temptab.Value = {pVal1Post};
        results = vertcat(results,temptab);
    end
end

end

