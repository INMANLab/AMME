%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

cPath = pwd;
%% Parameters
%-------- load file names information
fileInfo = readtable(RD+"FileInfoList.csv");
%-------- load patient Structure
load(RD+"PatientStructL1");

eventChName = "Event";
%% Add file Info to the patient Structure -> Only Study and Day2 are being used
for pIdx = 1:length(fileInfo.Patient)
    matchedPIdx = find(strcmp(fileInfo.Patient{pIdx},{patient.name}));
    if(isempty(matchedPIdx))
        error("Patient Not Found: "+fileInfo.Patient(pIdx));
    end
    patient(matchedPIdx).phase(fileInfo.Phase(pIdx)).logFile = string(fileInfo.Log{pIdx});
    patient(matchedPIdx).phase(fileInfo.Phase(pIdx)).edfFile = string(fileInfo.EDF{pIdx});
    patient(matchedPIdx).phase(fileInfo.Phase(pIdx)).trialTimeFile = string(fileInfo.TrialTime{pIdx});
end
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(RDD) %go to Raw Data directory
fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for pIdx = 1:length(patient)
    fprintf('\tWorking on %s . . .', patient(pIdx).name)
    cd(patient(pIdx).name)
    load(patient(pIdx).phase(1).syncfn)%load the lfp for the sync channel
    %get the sync pulse times for the STUDY SESSION
    fxn = sprintf('find_%s_study_trial_times(lfp)', patient(pIdx).name);
    try
        %if it works, just do it
        patient(pIdx).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
    catch
        %if it doesn't work, keep moving, but alert us
        fprintf(' Could not find study session start times in %s...', fxn)
        patient(pIdx).phase(1).trial_start_times = [];%nada
    end
    if(~isempty(find(isnan(patient(pIdx).phase(1).trial_start_times))))
        disp("Missing trials in study replaced with NaN")
    end
    %load the appropriate lfp for the one-day (day #2) test sync file
    load(patient(pIdx).phase(3).syncfn)%load the lfp for the sync channel
    %get the sync pulse times for the ONE-DAY TEST session
    fxn = sprintf('find_%s_day2_trial_times(lfp)', patient(pIdx).name);
    try
        %if it works, just do it
        patient(pIdx).phase(3).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
    catch
        %if it doesn't work, keep moving, but alert us
        fprintf(' Could not find one-day test session start times in %s...', fxn)
        patient(pIdx).phase(3).trial_start_times = [];%nada
    end
    clear lfp

    if(~isempty(find(isnan(patient(pIdx).phase(3).trial_start_times))))
        disp("Missing trials in day2 replaced with NaN")
    end

    cd(cPath)
    % read Log Files
    patient = ReadLogFiles(patient,pIdx,RDD);

    fprintf('done.\n')
    cd ..
end%patients
cd(cPath) %Return to the Current Path
%% get Channel Name and Index
pList = string(vertcat(patient.name));

for pIdx = 1:length(pList)
    if(strcmp(patient(pIdx).exp,'Original'))
        indexOffset = 1;
    else
        indexOffset = 0;
    end

    patient(pIdx).sync_chnum = indexOffset+patient(pIdx).sync_chnum;
    for stChIdx = 1:4
        patient(pIdx).stimchan(stChIdx).num = patient(pIdx).stimchan(stChIdx).num+indexOffset;
    end
    % phaseIdx = 1; % Because the names are the same across both days
    for phaseIdx = [1,3]
        disp("Loading channels name and info for Patient: "+patient(pIdx).name+", Phase: "+phaseIdx)
        patientPath = RDD+patient(pIdx).name+string(filesep);
        hdr = edfinfo(patientPath+patient(pIdx).phase(phaseIdx).edfFile);
        chNamesAll = hdr.SignalLabels;
        chNamesAll = replace(chNamesAll," ","");
        patient(pIdx).phase(phaseIdx).chNamesAll = chNamesAll;
        patient(pIdx).phase(phaseIdx).syncChIdx = patient(pIdx).sync_chnum;
        patient(pIdx).phase(phaseIdx).syncChName = chNamesAll(patient(pIdx).sync_chnum);
        %-------------- find LPF channel names
        for regionIdx = 1:length(patient(pIdx).ipsi_region)
            if(~isempty(patient(pIdx).ipsi_region(regionIdx).lfpnum))
                patient(pIdx).phase(phaseIdx).ipsi_region(regionIdx).name = patient(pIdx).ipsi_region(regionIdx).name;
                patient(pIdx).phase(phaseIdx).ipsi_region(regionIdx).lfpIdx = indexOffset+patient(pIdx).ipsi_region(regionIdx).lfpnum;
                patient(pIdx).phase(phaseIdx).ipsi_region(regionIdx).lfpName = chNamesAll(patient(pIdx).phase(phaseIdx).ipsi_region(regionIdx).lfpIdx);
            end
        end

        %-------------- find the index of the removing channels 
        chNames = convertCharsToStrings(patient(pIdx).phase(phaseIdx).removeChannels.names);
        [~,chIdx] = ismember(chNames,chNamesAll);
        [~,eventChIdx] = ismember(lower(eventChName),lower(chNamesAll));

        % chNames = convertCharsToStrings(patient(pIdx).phase(phaseIdx).emptyChannelNames.names);
        emChNames = string(patient(pIdx).phase(phaseIdx).emptyChannelNames);
        [~,emptyChIdx] = ismember(lower(emChNames),lower(chNamesAll));
        
        
        if(eventChIdx ~= 0)
            disp("-------Event Channel Found")
            chIdx = [eventChIdx,chIdx];
            chNames = [chNamesAll(eventChIdx),chNames];
        else
            eventChIdx = [];
        end

        if(~isempty(chIdx(chIdx == 0)))
            warning("for patient: "+patient(pIdx).name+", phase: "+...
                    phaseIdx+", there are missing channel names: "+join(chNames(chIdx==0)))
        end
        
        patient(pIdx).phase(phaseIdx).removeChannels.names = chNames;
        patient(pIdx).phase(phaseIdx).removeChannels.chIdx = chIdx;

        if(phaseIdx <3) %Stim channels were used
            tempIdx = horzcat(eventChIdx, patient(pIdx).phase(phaseIdx).syncChIdx, horzcat(patient(pIdx).stimchan.num), emptyChIdx);
            tempIdx = unique(tempIdx);
            patient(pIdx).phase(phaseIdx).extraChannels.chIdx = tempIdx;
            patient(pIdx).phase(phaseIdx).extraChannels.names = chNamesAll(tempIdx)';
        else %Stim channels not used
            tempIdx = horzcat(eventChIdx, patient(pIdx).phase(phaseIdx).syncChIdx, emptyChIdx);
            tempIdx = unique(tempIdx);
            patient(pIdx).phase(phaseIdx).extraChannels.chIdx = tempIdx;
            patient(pIdx).phase(phaseIdx).extraChannels.names = chNamesAll(tempIdx)';
        end
    end
end


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
