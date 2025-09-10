%% Original Group
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for p = 1:length(patient)
    if (~strcmp(patient(p).exp,"Original"))
        continue
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

  logfn = sprintf('%s.log', patient(p).name);
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
  logfn = sprintf('%s_day2.log', patient(p).name);
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



%% Original Patients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         PROCESS LOG FILES                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Processing data in log files...\n')
for p = 1:length(patient)
    if (~strcmp(patient(p).exp,"Original"))
        continue
    end
  for t = 1:length(patient(p).phase(1).trial)
    %find where the image from this study trial was tested
    tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
    testmatch=zeros(120,2);%Number of trials by two tests
    for ph = 2:3%immediate test, then one-day test
      for t2 = 1:length(patient(p).phase(ph).trial)
        testmatch(t2,ph-1) = strcmp(tmpstudyname, patient(p).phase(ph).trial(t2).full_im_name);
      end%t2
    end%test phases

    %make sure we find one and only one match
    if(sum(sum(testmatch))~=1)
      fprintf('Error: image not found for patient %s, study trial %d.\n', patient(p).name, t);
    end

    patient(p).phase(1).trial(t).whichtest = find(sum(testmatch));%1 = immediate, 2 = one-day
    if(isempty(patient(p).phase(1).trial(t).whichtest))
      fprintf('Error: no test match for patient %s, study trial %d.\n', patient(p).name, t);
    end

    patient(p).phase(1).trial(t).whichtesttrial = find(testmatch(:,patient(p).phase(1).trial(t).whichtest));%trial number
    if(isempty(patient(p).phase(1).trial(t).whichtesttrial))
      fprintf('Error: no trial match for patient %s, study trial %d.\n', patient(p).name, t);
    end

    %sanity check
    tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
    if(~strcmp(tmpstudyname, tmpmatchname))
      fprintf('Error: wrong image mtch for patient %s, study trial %d.\n', patient(p).name, t);
    end


    %get test info to match to study image
    patient(p).phase(1).trial(t).test_rt = ...
      patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).rt;

    patient(p).phase(1).trial(t).test_yes_no = ...
      patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).yes_or_no;

    patient(p).phase(1).trial(t).test_sure_notsure = ...
      patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).sure_notsure;

    patient(p).phase(1).trial(t).test_trial_type = ... %sanity check
      patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).trial_type;
    %if this doesn't match, we gotta problem
    if(patient(p).phase(1).trial(t).stimulation==1)
      temptype = 'stim';
    else
      temptype = 'nostim';
    end
    if(~strcmp(temptype, patient(p).phase(1).trial(t).test_trial_type))
      fprintf('Error: wrong trial type for patient %s, test %d trial %d.\n', patient(p).name, ...
        patient(p).phase(1).trial(t).whichtest,...
        patient(p).phase(1).trial(t).whichtesttrial);
    end

  end%end of study trials
end%patient
