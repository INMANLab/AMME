function dat = ReturnEEGArray(trialDat, rgIdx)
% This function reads EEG data from the patient structure and convert it to
% an array eegDat is structured: samples x trials x channels

try
    emptyTrials = cellfun(@isnan,{trialDat.start_time}); %Find and remove empty trials
catch
    emptyTrials = cellfun(@isempty,{trialDat.start_time});
end
dat = struct2table(trialDat(~emptyTrials));

trialCount = size(dat,1);
dat = horzcat(dat.region(:,rgIdx).lfp); %Create a 2d matrix of the eeg data: sample x (channels x trials)
sampleSize = size(dat,1);
dat = reshape(dat,sampleSize,[],trialCount); %Convert from 2d Matrix(sample x (channels x trials)) to 3d Matrix(sample x channels x trials)
dat = permute(dat,[1,3,2]); %Re-arrange the 3d Matrix(sample x channels x trials) to (sample x trials x channels)

end