% LoadandprocessLogFilesTimingGroup
%% Timing Load
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%From these to the end should be different - distinct loops - anywhere there is a phase specification  for each of the experiments

fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for p = 1:length(patient)
    if (~strcmp(patient(p).exp,"Timing"))
        continue
    end
  fprintf('\tWorking on %s . . .', patient(p).name)
  cd(patient(p).name)%go into patient's directory
  % load(patient(p).syncfn)%load the lfp for the sync channel
  % %get the sync pulse times for the STUDY SESSION
  % fxn = sprintf('find_%s_study_trial_times(lfp)', patient(p).name); %reading in file names with '%s' as substitutable with a string variable
  % try
  %   %if it works, just do it
  %   patient(p).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
  % catch
  %   %if it doesn't work, keep moving, but alert us
  %   fprintf('Could not find study session start times in %s...', fxn)
  %   patient(p).phase(1).trial_start_times = [];%nada
  % end
  % 

  %load the appropriate lfp for the ONE-DAY TEST (day #2) test sync file
  load(patient(p).phase(2).syncfn)%load the lfp for the sync channel

  %get the sync pulse times for the ONE-DAY TEST session
  fxn = sprintf('find_%s_day2_trial_times(lfp)', patient(p).name);
  try
    %if it works, just do it
    patient(p).phase(2).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
  catch
    %if it doesn't work, keep moving, but alert us
    fprintf(' Could not find one-day test session start times in %s...', fxn)
    patient(p).phase(2).trial_start_times = [];%nada
  end
  clear lfp


  %AMME TIMING AND DURATION: THE LOG FILE NAME AND THE PATIENT NAME HAS TO
  %MATCH TO THE find_amyg000_phase_trials_times.m FILES

% 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about STUDY SESSION from log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if strcmp(patient(p).name, 'amyg045') == 1 || strcmp(patient(p).name, 'amyg072') == 1
      logfn = sprintf('%s_Lamyg.log', patient(p).name);
      fprintf('Log file name is %s\n',logfn)
  elseif strcmp(patient(p).name, 'amyg057') ==1
      logfn = sprintf('%s_bipolar.log', patient(p).name);
      fprintf('Log file name is %s\n',logfn)
  else
      logfn = sprintf('%s.log', patient(p).name);
      fprintf('Log file name is %s\n',logfn)
  end
mydir = dir(logfn);

if isempty(mydir)
    fprintf('Log file name for day1 is not found for %s!!!\n')
end

  fileID = fopen(logfn);
  C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3); % reads in 3 header lines 
  %means skip to the next line(row) --> %*[^\n]
  fclose(fileID);

  %FYI for C = textscan above
  %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers %d is for double as whole number
  %C{2}(1:5) should be RTs for first 5 trials %f is float w a decimal
  %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
  %C{4}(1:5) should be 0, 1, 2, 3 (no stim, before, during, after)
  %C{5}{1} should be name of image file for first trial
  %C{6}{1} - amplitude of stimulation in microamps
  %C{7}{1} - sync from starting time in seconds
  %C{8}{1} - GetSecs computer clock 

  if(length(C{1})~=200)
    fprintf('Error: there should be 200 trials in study session.  Check %s.\n', logfn); %fprintf displays in command window
  end
  for t = 1:length(C{1}) %trial = t
    patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 200
    patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
    patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
    patient(p).phase(1).trial(t).stimulation = C{4}(t);%0 = nostim, 1=before, 2%= during,3= after
    patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
    patient(p).phase(1).trial(t).amp = C{6}{t};%amplitude in microamps
    patient(p).phase(1).trial(t).sycnfromstart = C{7}{t}; %sync from starting time in seconds - cumulative
    patient(p).phase(1).trial(t).getsecs = C{8}{t}; %computer's inner clock

    if(length(patient(p).phase(1).trial_start_times)>=t)
      patient(p).phase(1).trial(t).start_time = patient(p).phase(1).trial_start_times(t);%time of sync pulse ping for this trial = image onset
    else
      patient(p).phase(1).trial(t).start_time = [];
    end
  end%trial


%amyg069 and added variables based on the day2 log files
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about ONE DAY TEST  from 2nd log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if strcmp(patient(p).name, 'amyg045') == 1 || strcmp(patient(p).name, 'amyg072') == 1
      logfn = sprintf('%s_Lamyg_day2.log', patient(p).name);
      fprintf('Log file name is %s\n',logfn)
  elseif strcmp(patient(p).name, 'amyg057') ==1
      logfn = sprintf('%s_bipolar_day2.log', patient(p).name);
      fprintf('Log file name is %s\n',logfn)
  else
      logfn = sprintf('%s_day2.log', patient(p).name);
      fprintf('Log file name is %s\n',logfn)
  end
mydir = dir(logfn);

if isempty(mydir)
    fprintf('Log file name for day2 is not found for %s!!!\n')
end

  fileID = fopen(logfn);
  C = textscan(fileID,'%d %f %s %s %s %s %s %s %s %s %s %*[^\n]', 'HeaderLines',3,'Delimiter','\t');%skip 3 header rows
  %go to a new line --> %*[^\n] has to be at the end of the textscan format
  fclose(fileID);
  if(length(C{1})~=300)
    fprintf('Error: there should be 300 trials in one-day test session.  Check %s.\n', logfn);
  end
  %FYI
  %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
  %C{2}(1:5) should be RTs for first 5 trials
  %C{3}{1} should be confirmed RT 
  %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
  %C{5}{1} should be 'sure' or 'notsure'
  %C{6}{1} should be 'Before', 'During', 'After', 'new'
  %C{7}{1} should be name of image file for first trial
  %C{8}{1} sync from start cumulative timing in seconds of sync pulses
  %C{9}{1} getsecs - computer's inner clock
  %C{10}{1} Yes/No trial cumulative timing in seconds from the start
  %C{11}{1} sure/notsure tria cumulative timing in seconds from the start


  for t = 1:length(C{1})
    patient(p).phase(2).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
    patient(p).phase(2).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
    patient(p).phase(2).trial(t).confRT = C{3}{t}; %confirmed RT (0 = something wrong)
    patient(p).phase(2).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
    patient(p).phase(2).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
    patient(p).phase(2).trial(t).trial_type = regexprep(C{6}{t},' ','_'); %should be 'Before', 'During', 'After', 'new'
    patient(p).phase(2).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
    patient(p).phase(2).trial(t).syncfromstart = C{8}{t}; %sync from start cumulative timing in seconds of sync pulses
    patient(p).phase(2).trial(t).getsecs = C{9}{t};%getsecs - computer's inner clock
    patient(p).phase(2).trial(t).yesno_time = C{10}{t}; %Yes/No trial cumulative timing in seconds from the start
    patient(p).phase(2).trial(t).sure_notsure_time = C{11}{t}; %sure/notsure tria cumulative timing in seconds from the start


    if(length(patient(p).phase(2).trial_start_times)>=t)
      patient(p).phase(2).trial(t).start_time = patient(p).phase(2).trial_start_times(t);%time of sync pulse ping for this trial = image onset
    else
      patient(p).phase(2).trial(t).start_time = [];
    end

  end%trial

  fprintf('done.\n')
  cd ..
end%patients 

%% Log file for Timing Group

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                         PROCESS LOG FILES                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf('Processing data in log files...\n')
% for p = 1:length(patient)
%     if (~strcmp(patient(p).exp,"Timing"))
%         continue
%     end
%   for t = 1:length(patient(p).phase(1).trial)
%     %find where the image from this study trial was tested
%     tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
%     testmatch=zeros(300,2);%Number of trials by two tests - Martina chaged 120 --> 200
% 
%     for ph = 2% one-day test
%       for t2 = 1:300
%         testmatch(t2, ph) = strcmp(tmpstudyname, patient(p).phase(ph).trial(t2).full_im_name);
%       end%t2
%    end% phases
% 
% 
%     %make sure we find one and only one match - trying to make sure we had
%     %no repeated images between study and test
%     if(sum(sum(testmatch))~=1)
%       fprintf('Error: image not found for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     patient(p).phase(1).trial(t).whichtest = find(sum(testmatch));
%     if(isempty(patient(p).phase(1).trial(t).whichtest))
%       fprintf('Error: no test match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     patient(p).phase(1).trial(t).whichtesttrial = find(testmatch(:,patient(p).phase(1).trial(t).whichtest));%trial number
%     if(isempty(patient(p).phase(1).trial(t).whichtesttrial))
%       fprintf('Error: no trial match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     %sanity check
%     tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
%     %tmpmatchname = patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).full_im_name;
%     if(~strcmp(tmpstudyname, tmpmatchname))
%       fprintf('Error: wrong image match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     %get test info to match to study image 
%     patient(p).phase(1).trial(t).test_rt = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).rt;
% 
%     patient(p).phase(1).trial(t).test_yes_no = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).yes_or_no;
% 
%     patient(p).phase(1).trial(t).test_sure_notsure = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).sure_notsure;
% 
%     patient(p).phase(1).trial(t).test_trial_type = ... %sanity check
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest).trial(patient(p).phase(1).trial(t).whichtesttrial).trial_type;
% 
%     %if this doesn't match, we gotta problem
%     if(patient(p).phase(1).trial(t).stimulation==1) % this might need to be updated to the types log file col F needs to be in here in an if statement
%       temptype = 'Beforestim'; %study log file matching stim condition to test log file  cond
%     elseif (patient(p).phase(1).trial(t).stimulation==2)
%       temptype = 'Duringstim'; 
%     elseif (patient(p).phase(1).trial(t).stimulation==3)
%       temptype = 'Afterstim';
%     elseif (patient(p).phase(1).trial(t).stimulation==0)
%       temptype = 'nostim';
%     else 
%         temptype = 'new';    %make sure the new trials are not considered nostim trial - is this ok?
%     end
% 
%     if(~strcmp(temptype, patient(p).phase(1).trial(t).test_trial_type)) %strcmp = string comparison
%       fprintf('Error: wrong trial type for patient %s, test %d trial %d.\n', patient(p).name, ...
%         patient(p).phase(1).trial(t).whichtest,...
%         patient(p).phase(1).trial(t).whichtesttrial);
%     end
% 
%  end%end of study trials
% end %patient