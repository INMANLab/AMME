function results = ComputePACs_Theta_Gamma(eegDat, regionNames,regionInfo, parTime, samprate)
% This function uses chronux multitaper method to compute power for all
% regions and coherency among all of them
% eegDat is a list of 3d EEG matrix(samples x trials x channels) for
% different regions
results = table;

thetalowcut = 4;
thetahighcut = 7;
AmpFreqVector = 20:5:90;
AmpFreq_BandWidth = 20;

for rg1 = 1:length(eegDat)
    if(isempty(eegDat{rg1}))
        continue;
    end
    eegDatPost1 = eegDat{rg1};
    eegDatPre1 = eegDat{rg1};
    %--------------> Filter the lower frequency Phase parts
    [n,fo,mo,w] = remezord([thetalowcut-1 thetalowcut thetahighcut thetahighcut+1], [0 1 0], [1 1 1]*0.01, samprate);
    b = remez(n,fo,mo,w);a=1;
    
    for chIdx1 = 1:1 %size(eegDatPost1,3)

        % sig = eegDatPost1(:,:,chIdx1);
        % [sigPadded,idx] = PaddwithReversed(sig,1);
        % sigPaddedF = filtfilt(b,a,sigPadded);
        % sigPaddedF = sigPaddedF(idx,:);
        % sigF = filtfilt(b,a,sig);

        % figure;
        % subplot 221
        % plot(sig(:,1))
        % hold on
        % plot(sigF(:,1))
        % subplot 222
        % pwelch(sig(:,1),[],[],1:.5:100,samprate);
        % hold on
        % pwelch(sigF(:,1),[],[],1:.5:100,samprate);
        % subplot 223
        % plot(sigPadded(idx,1))
        % hold on
        % plot(sigPaddedF(:,1))
        % subplot 224
        % pwelch(sigPadded(:,1),[],[],1:.5:100,samprate);
        % hold on
        % pwelch(sigPaddedF(:,1),[],[],1:.5:100,samprate);

        eegDatPost1(:,:,chIdx1) = filtfilt(b,a,eegDatPost1(:,:,chIdx1));
        eegDatPre1(:,:,chIdx1) = filtfilt(b,a,eegDatPre1(:,:,chIdx1));
    end
    eegDatPost1 = eegDatPost1(parTime.startIdxPost:parTime.endIdxPost,:,:);
    eegDatPre1 = eegDatPre1(parTime.startIdxPre:parTime.endIdxPre,:,:);

    for rg2 = 1:length(eegDat)
        if(isempty(eegDat{rg2}))
            continue;
        end
        eegDatPost2Orig = eegDat{rg2};
        eegDatPre2Orig = eegDat{rg2};
        eegDatPost2 = cell(length(AmpFreqVector),size(eegDatPost2Orig,3));
        eegDatPre2 = cell(length(AmpFreqVector),size(eegDatPost2Orig,3));
        %--------------> Filter the Higher frequency Amplitude parts
        for ampIdx=1:length(AmpFreqVector)
            Af1 = AmpFreqVector(ampIdx);
            Af2=Af1+AmpFreq_BandWidth;
            [n,fo,mo,w] = remezord([Af1-1 Af1 Af2 Af2+1], [0 1 0], [1 1 1]*0.01, samprate);
            b = remez(n,fo,mo,w);a=1;
            for chIdx2 = 1:1%size(eegDatPost2Orig,3) 
                postDat = filtfilt(b,a,eegDatPost2Orig(:,:,chIdx2));
                preDat = filtfilt(b,a,eegDatPre2Orig(:,:,chIdx2));
                eegDatPost2{ampIdx,chIdx2} = postDat(parTime.startIdxPost:parTime.endIdxPost,:);
                eegDatPre2{ampIdx,chIdx2} = preDat(parTime.startIdxPre:parTime.endIdxPre,:);
            end
        end
        

        for  chIdx1 = 1:1%size(eegDatPost1,3)
            for  chIdx2 = 1:1%size(eegDatPost2,3)
                pacValsPost = ComputeSegmentedPAC(eegDatPost1(:,:,chIdx1),...
                                                    eegDatPost2(:,chIdx2));
                pacValsPre = ComputeSegmentedPAC(eegDatPre1(:,:,chIdx1),...
                                                    eegDatPre2(:,chIdx2));

                xbins = AmpFreqVector+AmpFreq_BandWidth/2;


                temptab = table;
                temptab.EpochTime = "PreImage";
                temptab.Measure = "PAC_TG";
                temptab.Region = regionNames(rg1)+"_"+regionNames(rg2);
                temptab.ChName = regionInfo(rg1).lfpName(chIdx1)+"_"+regionInfo(rg2).lfpName(chIdx2);
                temptab.ChOrder = chIdx1+"_"+chIdx2;
                temptab.Freqs = {xbins};
                temptab.Value = {pacValsPre};
                results = vertcat(results,temptab);

                temptab = table;
                temptab.EpochTime = "PostImage";
                temptab.Measure = "PAC_TG";
                temptab.Region = regionNames(rg1)+"_"+regionNames(rg2);
                temptab.ChName = regionInfo(rg1).lfpName(chIdx1)+"_"+regionInfo(rg2).lfpName(chIdx2);
                temptab.ChOrder = chIdx1+"_"+chIdx2;
                temptab.Freqs = {xbins};
                temptab.Value = {pacValsPost};
                results = vertcat(results,temptab);
            end
        end
    end
end

end

