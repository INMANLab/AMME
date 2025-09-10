%% Initialization
% ----> Run L1 first

% load file names information
fileInfo = readtable("FileInfoList.csv");
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
%% Original Group
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for p = 1:length(patient)
    pIdx = find(strcmp(patient(p).name,fileInfo.Patient));
    if(length(pIdx)<2)
        error("Patient Not Found: "+patient(p).name);
    end
    fprintf('\tWorking on %s . . .', patient(p).name)
    cd(patient(p).name)%go into patient's directory
    load(patient(p).syncfn)%load the lfp for the sync channel
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


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about STUDY SESSION from log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    logfn = patient(p).phase(1).logFile;
    fileID = fopen(logfn);
    C = textscan(fileID,'%d %f %s %d %s %*[^\n]', 'HeaderLines',3);
    fclose(fileID);
    %FYI
    %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
    %C{2}(1:5) should be RTs for first 5 trials
    %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
    %C{4}(1:5) should be 1 (stim) or 0 (no stim) for first five trials
    %C{5}{1} should be name of image file for first trial

  if(length(C{1})~=160)
    fprintf('Error: there should be 160 trials in study session.  Check %s.\n', logfn);
  end
  for t = 1:length(C{1})
    patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 160
    patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
    patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
    patient(p).phase(1).trial(t).stimulation = C{4}(t);%stimulation = 1; no stimulation = 0
    patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
    if(length(patient(p).phase(1).trial_start_times)>=t)
      patient(p).phase(1).trial(t).start_time = patient(p).phase(1).trial_start_times(t);%time of sync pulse ping for this trial = image onset
    else
      patient(p).phase(1).trial(t).start_time = [];
    end
  end%trial


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about ONE DAY TEST  from 2nd log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  logfn = patient(p).phase(3).logFile;
  fileID = fopen(logfn);
  C = textscan(fileID,'%d %f %s %s %s %s %*[^\n]', 'HeaderLines',3);%skip 3 header rows
  fclose(fileID);
  if(length(C{1})~=120)
    fprintf('Error: there should be 120 trials in one-day test session.  Check %s.\n', logfn);
  end

  %FYI
  %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
  %C{2}(1:5) should be RTs for first 5 trials
  %C{3}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
  %C{4}{1} should be 'sure' or 'notsure'
  %C{5}{1} should be 'stim', 'nostim', or 'new'
  %C{6}{1} should be name of image file for first trial

  for t = 1:length(C{1})
    patient(p).phase(3).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
    patient(p).phase(3).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
    patient(p).phase(3).trial(t).yes_or_no = C{3}{t};%yes or no (or NA if no button press), as judged by participant
    patient(p).phase(3).trial(t).sure_notsure = C{4}{t};%sure or not sure, as judged by participant
    patient(p).phase(3).trial(t).trial_type = C{5}{t}; %'stim', 'nostim', or 'new'
    patient(p).phase(3).trial(t).full_im_name = C{6}{t}; %name of image, including path on testing computer

    if(length(patient(p).phase(3).trial_start_times)>=t)
      patient(p).phase(3).trial(t).start_time = patient(p).phase(3).trial_start_times(t);%time of sync pulse ping for this trial = image onset
    else
      patient(p).phase(3).trial(t).start_time = [];
    end

  end%trial

  fprintf('done.\n')
  cd ..
end%patients














%%
%---------Original
LoadandprocessLogFilesOriginalGroup;
%---------Duration
LoadandprocessLogFilesDurationGroup;

%-------Timing
LoadandprocessLogFilesTimingGroup;

save("PatientStructNoEEG","patient");

%% Export Patient Channel Info
pList = string(vertcat(patient.name));
T = table;
for pIdx = 1:length(pList)
    tempTab = struct2table(patient(pIdx).ipsi_region);
    tempTab.pName = repmat(string(patient(pIdx).name),size(tempTab,1),1);

    d=2;
    tempTab.phase = repmat("day"+string(d),size(tempTab,1),1);
    tempTab.synchChNum = repmat(patient(pIdx).sync_chnum,size(tempTab,1),1);
    tempTab.samplingRate = repmat(patient(pIdx).samprate,size(tempTab,1),1);

    if strcmp(patient(pIdx).name, 'amyg045') == 1 || strcmp(patient(pIdx).name, 'amyg048') == 1 || strcmp(patient(pIdx).name, 'amyg054') == 1 || strcmp(patient(pIdx).name, 'amyg060') == 1 || strcmp(patient(pIdx).name, 'amyg072') == 1
        hdrName = sprintf('day%dLamyg_hdr.mat', d);
    elseif strcmp(patient(pIdx).name, 'amyg057') ==1
        hdrName = sprintf('day%dbipolar_hdr.mat',d);
    elseif strcmp(patient(pIdx).name, "amyg030")
        hdrName = sprintf('day%dbilateral_hdr.mat',d);
    else
        hdrName = "day2_hdr.mat";
    end


    if(strcmp(patient(pIdx).exp,'Original'))
        indexOffset = 1;
    else
        indexOffset = 0;
    end
    hdr = load(string(patient(pIdx).name)+string(filesep)+hdrName).hdr;
    for regionIdx = 1:length(tempTab.lfpnum)
        tempTab.chName(regionIdx) = {[convertCharsToStrings(hdr.label(tempTab.lfpnum{regionIdx}+indexOffset))]};
        tempTab.synchChName(regionIdx) = {[convertCharsToStrings(hdr.label(tempTab.synchChNum(regionIdx)+indexOffset))]};
    end
    T = vertcat(T,tempTab);
end

for rowIdx = 1:length(T.pName)
    for lfpIdx = 1:length(T.lfpnum{rowIdx})
        T.("chIdx"+string(lfpIdx)){rowIdx} = T.lfpnum{rowIdx}(lfpIdx);
        T.("chName"+string(lfpIdx)){rowIdx} = T.chName{rowIdx}(lfpIdx);
    end
end
T = removevars(T,{'lfpnum','chName'});
writetable(T,"ChannelList.csv")
%% Checking Channel List
% PatientNames = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
% pList = string(vertcat(patient.name));
% pIndex = find(ismember(pList,PatientNames));
% T = table;
% for pIdx = pIndex'
%     tempTab = struct2table(patient(pIdx).region);
%     tempTab = tempTab([1,3,4],:);
%     tempTab.pName = repmat(string(patient(pIdx).name),size(tempTab,1),1);
%     hdr = load(string(patient(pIdx).name)+string(filesep)+"day2_hdr.mat").hdr;
%     tempTab.chName = convertCharsToStrings(hdr.label(cell2mat(tempTab.lfpnum)+1))';
%     T = vertcat(T,tempTab);
% end