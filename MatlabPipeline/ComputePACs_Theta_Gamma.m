function results = ComputePACs_Theta_Gamma(eegDat, regionNames, regionInfo, parTime, samprate)
% Efficient PAC computation:
% - Theta phase signal is filtered once per region
% - Gamma amplitude bands are filtered once per region and per band
% - Pre/Post windows are extracted once
% - Results table is built from preallocated cells instead of repeated vertcat

thetalowcut = 4;
thetahighcut = 7;
AmpFreqVector = 20:5:90;
AmpFreq_BandWidth = 20;

nRegions = length(eegDat);
nAmp = length(AmpFreqVector);

% Keep original behavior: only first channel is processed
useCh1 = 1;

% -------------------------------------------------------------------------
% Precompute theta filter
% -------------------------------------------------------------------------
[n, fo, mo, w] = remezord([thetalowcut-1 thetalowcut thetahighcut thetahighcut+1], ...
                          [0 1 0], [1 1 1]*0.01, samprate);
bTheta = remez(n, fo, mo, w);
aTheta = 1;

% -------------------------------------------------------------------------
% Precompute gamma filters
% -------------------------------------------------------------------------
bGamma = cell(nAmp,1);
aGamma = cell(nAmp,1);

for ampIdx = 1:nAmp
    Af1 = AmpFreqVector(ampIdx);
    Af2 = Af1 + AmpFreq_BandWidth;

    [n, fo, mo, w] = remezord([Af1-1 Af1 Af2 Af2+1], ...
                              [0 1 0], [1 1 1]*0.01, samprate);
    bGamma{ampIdx} = remez(n, fo, mo, w);
    aGamma{ampIdx} = 1;
end

% -------------------------------------------------------------------------
% Precompute filtered/cropped data for each region
% -------------------------------------------------------------------------
thetaPost = cell(nRegions,1);
thetaPre  = cell(nRegions,1);
gammaPost = cell(nRegions,1);   % each entry: nAmp x nCh cell
gammaPre  = cell(nRegions,1);

validRegion = false(nRegions,1);

for rg = 1:nRegions
    if isempty(eegDat{rg})
        continue;
    end

    dat = eegDat{rg};
    nCh = size(dat,3);

    validRegion(rg) = true;

    % ----- Theta filtering once per region
    thetaFilt = dat;
    for chIdx = useCh1 % preserve original behavior
        thetaFilt(:,:,chIdx) = filtfilt(bTheta, aTheta, dat(:,:,chIdx));
    end

    thetaPost{rg} = thetaFilt(parTime.startIdxPost:parTime.endIdxPost,:,:);
    thetaPre{rg}  = thetaFilt(parTime.startIdxPre:parTime.endIdxPre,:,:);

    % ----- Gamma filtering once per region for all amplitude bands
    gammaPost{rg} = cell(nAmp, nCh);
    gammaPre{rg}  = cell(nAmp, nCh);

    for ampIdx = 1:nAmp
        b = bGamma{ampIdx};
        a = aGamma{ampIdx};

        for chIdx = useCh1 % preserve original behavior
            filtDat = filtfilt(b, a, dat(:,:,chIdx));
            gammaPost{rg}{ampIdx, chIdx} = filtDat(parTime.startIdxPost:parTime.endIdxPost,:);
            gammaPre{rg}{ampIdx, chIdx}  = filtDat(parTime.startIdxPre:parTime.endIdxPre,:);
        end
    end
end

% -------------------------------------------------------------------------
% Preallocate output storage
% Two rows per region-pair/channel-pair: PreImage and PostImage
% Since original code only processes channel 1, count accordingly
% -------------------------------------------------------------------------
validIdx = find(validRegion);
nValid = numel(validIdx);

maxRows = 2 * nValid * nValid;  % 2 epochs, 1 ch pair only in current behavior
rowData = cell(maxRows, 7);
row = 0;

xbins = AmpFreqVector + AmpFreq_BandWidth/2;

% -------------------------------------------------------------------------
% PAC computation
% -------------------------------------------------------------------------
for i1 = 1:nValid
    rg1 = validIdx(i1);

    for i2 = 1:nValid
        rg2 = validIdx(i2);

        chIdx1 = 1; % preserve original behavior
        chIdx2 = 1; % preserve original behavior

        pacValsPost = ComputeSegmentedPAC(thetaPost{rg1}(:,:,chIdx1), ...
                                          gammaPost{rg2}(:,chIdx2));

        pacValsPre  = ComputeSegmentedPAC(thetaPre{rg1}(:,:,chIdx1), ...
                                          gammaPre{rg2}(:,chIdx2));

        regionLabel = regionNames(rg1) + "_" + regionNames(rg2);
        chNameLabel = regionInfo(rg1).lfpName(chIdx1) + "_" + regionInfo(rg2).lfpName(chIdx2);
        chOrderLabel = chIdx1 + "_" + chIdx2;

        row = row + 1;
        rowData(row,:) = {"PreImage", "PAC_TG", regionLabel, chNameLabel, chOrderLabel, {xbins}, {pacValsPre}};

        row = row + 1;
        rowData(row,:) = {"PostImage", "PAC_TG", regionLabel, chNameLabel, chOrderLabel, {xbins}, {pacValsPost}};
    end
end

rowData = rowData(1:row,:);

results = cell2table(rowData, 'VariableNames', ...
    {'EpochTime','Measure','Region','ChName','ChOrder','Freqs','Value'});

end