%% Initialization
% ----> Run L1 first
cPath = pwd;
cd(WD) %change the working directory

% load file names information
fileInfo = readtable(RD+"FileInfoList.csv");

%% Parameters
eventChName = "Event";
%% Add file Info the the patient Structure -> Only Study and Day2 are being used
for p = 1:length(patient)
    pIdx = find(strcmp(patient(p).name,fileInfo.Patient));
    if(length(pIdx)<2)
        error("Patient Not Found: "+patient(p).name);
    end
    patient(p).phase(1).logFile = string(fileInfo.Log{pIdx(1)});
    patient(p).phase(1).edfFile = string(fileInfo.EDF{pIdx(1)});
    patient(p).phase(1).trialTimeFile = string(fileInfo.TrialTime{pIdx(1)});

    patient(p).phase(3).logFile = string(fileInfo.Log{pIdx(2)});
    patient(p).phase(3).edfFile = string(fileInfo.EDF{pIdx(2)});
    patient(p).phase(3).trialTimeFile = string(fileInfo.TrialTime{pIdx(2)});
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for p = 1:length(patient)
    fprintf('\tWorking on %s . . .', patient(p).name)
    cd(patient(p).name)%go into patient's directory
    load(patient(p).phase(1).syncfn)%load the lfp for the sync channel
    %get the sync pulse times for the STUDY SESSION
    fxn = sprintf('find_%s_study_trial_times(lfp)', patient(p).name);
    try
        %if it works, just do it
        patient(p).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
    catch
        %if it doesn't work, keep moving, but alert us
        fprintf(' Could not find study session start times in %s...', fxn)
        patient(p).phase(1).trial_start_times = [];%nada
    end
    
    %load the appropriate lfp for the one-day (day #2) test sync file
    load(patient(p).phase(3).syncfn)%load the lfp for the sync channel
    %get the sync pulse times for the ONE-DAY TEST session
    fxn = sprintf('find_%s_day2_trial_times(lfp)', patient(p).name);
    try
        %if it works, just do it
        patient(p).phase(3).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
    catch
        %if it doesn't work, keep moving, but alert us
        fprintf(' Could not find one-day test session start times in %s...', fxn)
        patient(p).phase(3).trial_start_times = [];%nada
    end
    clear lfp

    cd(cPath)
    % read Log Files
    patient = ReadLogFiles(patient,p,WD);

    fprintf('done.\n')
    cd ..
end%patients

%% get Channel Name and Index
pList = string(vertcat(patient.name));

for pIdx = 1:length(pList)

    if(strcmp(patient(pIdx).exp,'Original'))
        indexOffset = 1;
    else
        indexOffset = 0;
    end

    phaseIdx = 1; % Because the names are the same across both days
    % for phaseIdx = [1,3]
        hdr = edfinfo(WD+string(patient(pIdx).name)+string(filesep)+patient(pIdx).phase(phaseIdx).edfFile);
        chNamesAll = hdr.SignalLabels;
        for regionIdx = 1:length(patient(pIdx).ipsi_region)
            if(~isempty(patient(pIdx).ipsi_region(regionIdx).lfpnum))
                patient(pIdx).ipsi_region(regionIdx).lfpnum = indexOffset+patient(pIdx).ipsi_region(regionIdx).lfpnum;
                patient(pIdx).ipsi_region(regionIdx).lfpName = chNamesAll(patient(pIdx).ipsi_region(regionIdx).lfpnum);

            end
        end
    % end
    for phaseIdx = 1:length(patient(pIdx).removeChannels)
        chNames = convertCharsToStrings(patient(pIdx).removeChannels{phaseIdx});
        [~,chIdx]=ismember(chNames,chNamesAll);
        [~,eventChIdx]=ismember(lower(eventChName),lower(chNamesAll));
        if(eventChIdx ~=0)
            chIdx = [eventChIdx,chIdx];
        end
        if(~isempty(chIdx(chIdx==0)))
            warning("for patient: "+patient(pIdx).name+", phase: "+phaseIdx+", there are missing channel names")
        end
        patient(pIdx).removeChannelsIdx{phaseIdx} = chIdx;
    end
end


% To Dos
% Convert the EEG data timetable to array;
% double check the indeces of the Event channel in the EEG array;
% double check the indexings of the removing channels to be consistent with EEG array;
% Check for Zero indeces that are missing or changed between days;
% find the syncpulse channel name and index;
%% Save the data
cd(cPath) %Return to the Current Path
save(WR+"PatientStructL2","patient");

%% Export Patient Channel Info
% pList = string(vertcat(patient.name));
% T = table;
% for pIdx = 1:length(pList)
%     tempTab = struct2table(patient(pIdx).ipsi_region);
%     tempTab.pName = repmat(string(patient(pIdx).name),size(tempTab,1),1);
% 
%     d=2;
%     tempTab.phase = repmat("day"+string(d),size(tempTab,1),1);
%     tempTab.synchChNum = repmat(patient(pIdx).sync_chnum,size(tempTab,1),1);
%     tempTab.samplingRate = repmat(patient(pIdx).samprate,size(tempTab,1),1);
% 
%     if strcmp(patient(pIdx).name, 'amyg045') == 1 || strcmp(patient(pIdx).name, 'amyg048') == 1 || strcmp(patient(pIdx).name, 'amyg054') == 1 || strcmp(patient(pIdx).name, 'amyg060') == 1 || strcmp(patient(pIdx).name, 'amyg072') == 1
%         hdrName = sprintf('day%dLamyg_hdr.mat', d);
%     elseif strcmp(patient(pIdx).name, 'amyg057') ==1
%         hdrName = sprintf('day%dbipolar_hdr.mat',d);
%     elseif strcmp(patient(pIdx).name, "amyg030")
%         hdrName = sprintf('day%dbilateral_hdr.mat',d);
%     else
%         hdrName = "day2_hdr.mat";
%     end
% 
% 
%     if(strcmp(patient(pIdx).exp,'Original'))
%         indexOffset = 1;
%     else
%         indexOffset = 0;
%     end
%     hdr = load(WD+string(patient(pIdx).name)+string(filesep)+hdrName).hdr;
%     hdr = edfinfo(WD+string(patient(pIdx).name)+string(filesep)+patient(pIdx).phase(1).edfFile);
%     for regionIdx = 1:length(tempTab.lfpnum)
%         tempTab.chName(regionIdx) = {[convertCharsToStrings(hdr.label(tempTab.lfpnum{regionIdx}+indexOffset))]};
%         tempTab.synchChName(regionIdx) = {[convertCharsToStrings(hdr.label(tempTab.synchChNum(regionIdx)+indexOffset))]};
%     end
%     T = vertcat(T,tempTab);
% end
% 
% for rowIdx = 1:length(T.pName)
%     for lfpIdx = 1:length(T.lfpnum{rowIdx})
%         T.("chIdx"+string(lfpIdx)){rowIdx} = T.lfpnum{rowIdx}(lfpIdx);
%         T.("chName"+string(lfpIdx)){rowIdx} = T.chName{rowIdx}(lfpIdx);
%     end
% end
% T = removevars(T,{'lfpnum','chName'});
% writetable(T,"ChannelList.csv")
