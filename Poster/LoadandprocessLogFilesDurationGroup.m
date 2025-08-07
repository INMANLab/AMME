%% Duration Group
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for p = 1:length(patient)
    if (~strcmp(patient(p).exp,"Duration"))
        continue
    end
  fprintf('\tWorking on %s . . .', patient(p).name)
  cd(patient(p).name)%go into patient's directory
  % load(patient(p).syncfn)%load the lfp for the sync channel
  %get the sync pulse times for the STUDY SESSION
  % fxn = sprintf('find_%s_study_trial_times(lfp)', patient(p).name);
  % try
  %   %if it works, just do it
  %   patient(p).phase(1).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
  % catch
  %   %if it doesn't work, keep moving, but alert us
  %   fprintf(' Could not find study session start times in %s...', fxn)
  %   patient(p).phase(1).trial_start_times = [];%nada
  % end
  % 
  % %since we're using same LFP, let's get the sync pulse times for the IMMEDIATE TEST session
  % fxn = sprintf('find_%s_imm_trial_times(lfp)', patient(p).name);
  % try
  %   %if it works, just do it
  %   patient(p).phase(2).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
  % catch
  %   %if it doesn't work, keep moving, but alert us
  %   fprintf(' Could not find immediate test session start times in %s...', fxn)
  %   patient(p).phase(2).trial_start_times = [];%nada
  % end
  % clear lfp

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

  % logfn = sprintf('%s.log', patient(p).name);
  % fileID = fopen(logfn);
  % C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3);
  % fclose(fileID);
  % %FYI
  % %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
  % %C{2}(1:5) should be RTs
  % %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
  % %C{4}(1:5) should be 1 (1 sec stim), 3 (3 sec stim), or 0 (no stim)
  % %C{5}{1} should be name of image file
  % %C{6}{1} - amplitude of stimulation in microamps
  % %C{7}{1} - sync from starting time in seconds
  % %C{8}{1} - GetSecs computer clock 
  % 
  % if(length(C{1})~=240)
  %   fprintf('Error: there should be 240 trials in study session.  Check %s.\n', logfn);
  % end
  % for t = 1:length(C{1})
  %   patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 240
  %   patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
  %   patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
  %   patient(p).phase(1).trial(t).stimulation = C{4}(t);%stimulation = 1; no stimulation = 0
  %   patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
  %   patient(p).phase(1).trial(t).amp = C{6}{t};%amplitude in microamps
  %   patient(p).phase(1).trial(t).sycnfromstart = C{7}{t}; %sync from starting time in seconds - cumulative
  %   patient(p).phase(1).trial(t).getsecs = C{8}{t}; % GetSecs computer's inner clock
  % 
  %   if(length(patient(p).phase(1).trial_start_times)>=t)
  %     patient(p).phase(1).trial(t).start_time = patient(p).phase(1).trial_start_times(t);%time of sync pulse ping for this trial = image onset
  %   else
  %     patient(p).phase(1).trial(t).start_time = [];
  %   end
  % end%trial


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about IMMEDIATE TEST from same log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % fileID = fopen(logfn);
  % %TRIAL	RT	YES/NO	SURE/NOT	CONDITION(stim/nostim/new) IMAGENAME
  % C = textscan(fileID,'%d %f %f %s %s %s %s %s %s %s %s %*[^\n]','HeaderLines',246);%we'll skip the whole study session, treating it as "header lines" %MKH is 246 the accurate number of headers to skip here?????
  % fclose(fileID);
  % if(length(C{1})~=200)
  %   fprintf('Error: there should be 200 trials in immediate test session.  Check %s.\n', logfn);
  % end
  % 
  % %FYI
  % %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
  % %C{2}(1:5) should be RTs 
  % %C{3}{1} should be confidence RTs
  % %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
  % %C{5}{1} should be 'sure' or 'notsure'
  % %C{6}{1} should be condition of '1s stim', '3s stim', 'nostim', or 'new'
  % %C{7}{1} should be name of image file for first trial
  % %C{8}{1} -sync from starting time in seconds
  % %C{9}{1} - GetSecs computer clock
  % %C{10}{1} - YesNo Time on computer clock
  % %C{11}{1} - Sure NotSure Time on computer clock
  % 
  % for t = 1:length(C{1})
  %   patient(p).phase(2).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 200
  %   patient(p).phase(2).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
  %   patient(p).phase(2).trial(t).confrt = C{3}(t); %sure/not sure decision rt (0 = something wrong)
  %   patient(p).phase(2).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
  %   patient(p).phase(2).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
  %   patient(p).phase(2).trial(t).trial_type = C{6}{t}; %'1s stim', '3s stim', 'nostim', or 'new'
  %   patient(p).phase(2).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
  %   patient(p).phase(2).trial(t).syncfromstart = C{8}{t}; %sync from starting time in seconds
  %   patient(p).phase(2).trial(t).getsecs = C{9}{t}; %GetSecs computer clock
  %   patient(p).phase(2).trial(t).yesno_clock = C{10}{t}; %YesNo Time on computer clock
  %   patient(p).phase(2).trial(t).surenotsure_clock = C{11}{t}; %Sure NotSure Time on computer clock
  % 
  %   if(length(patient(p).phase(2).trial_start_times)>=t)
  %     patient(p).phase(2).trial(t).start_time = patient(p).phase(2).trial_start_times(t);%time of sync pulse ping for this trial = image onset
  %   else
  %     patient(p).phase(2).trial(t).start_time = [];
  %   end
  % 
  % end%trial

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about ONE DAY TEST  from 2nd log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  logfn = sprintf('%s_day2.log', patient(p).name);
  fileID = fopen(logfn);
   C = textscan(fileID,'%d %f %f %s %s %s %s %s %s %s %s %*[^\n]', 'HeaderLines',3,'Delimiter','\t');%skip 3 header rows
  fclose(fileID);
  if(length(C{1})~=200)
    fprintf('Error: there should be 200 trials in one-day test session.  Check %s.\n', logfn);
  end

  %FYI
  %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
  %C{2}(1:5) should be RTs 
  %C{3}{1} should be confidence RTs
  %C{4}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
  %C{5}{1} should be 'sure' or 'notsure'
  %C{6}{1} should be condition of '1s stim', '3s stim', 'nostim', or 'new'
  %C{7}{1} should be name of image file for first trial
  %C{8}{1} -sync from starting time in seconds
  %C{9}{1} - GetSecs computer clock
  %C{10}{1} - YesNo Time on computer clock
  %C{11}{1} - Sure NotSure Time on computer clock

  for t = 1:length(C{1})
    patient(p).phase(3).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 200
    patient(p).phase(3).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
    patient(p).phase(3).trial(t).confrt = C{3}(t); %sure/not sure decision rt (0 = something wrong)
    patient(p).phase(3).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
    patient(p).phase(3).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
    patient(p).phase(3).trial(t).trial_type = regexprep(C{6}{t},' ','_'); %'1s stim', '3s stim', 'nostim', or 'new'
    patient(p).phase(3).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
    patient(p).phase(3).trial(t).syncfromstart = C{8}{t}; %sync from starting time in seconds
    patient(p).phase(3).trial(t).getsecs = C{9}{t}; %GetSecs computer clock
    patient(p).phase(3).trial(t).yesno_clock = C{10}{t}; %YesNo Time on computer clock
    patient(p).phase(3).trial(t).surenotsure_clock = C{11}{t}; %Sure NotSure Time on computer clock

    if(length(patient(p).phase(3).trial_start_times)>=t)
      patient(p).phase(3).trial(t).start_time = patient(p).phase(3).trial_start_times(t);%time of sync pulse ping for this trial = image onset
    else
      patient(p).phase(3).trial(t).start_time = [];
    end

  end%trial

  fprintf('done.\n')
  cd ..
end%patients



% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                         PROCESS LOG FILES                        %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('Processing data in log files...\n')
% for p = 1:length(patient)
%     if (~strcmp(patient(p).exp,"Duration"))
%         continue
%     end
%   for t = 1:length(patient(p).phase(1).trial)
%     %find where the image from this study trial was tested
%     tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
%     testmatch=zeros(240,2);%Number of trials by two tests
% 
%     A = patient(p).phase(2).trial;A = convertCharsToStrings({A.full_im_name})';
%     B = patient(p).phase(3).trial;B = convertCharsToStrings({B.full_im_name})';
%     find(contains(A,tmpstudyname))
%     find(contains(B,tmpstudyname))
%     for ph = 2:3%immediate test, then one-day test
%       for t2 = 1:200
%         testmatch(t2,ph-1) = strcmp(tmpstudyname, patient(p).phase(ph).trial(t2).full_im_name);
%       end%t2
%     end%test phases
% 
%     %make sure we find one and only one match
%     if(sum(sum(testmatch))~=1)
%       fprintf('Error: image not found for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
%     patient(p).phase(1).trial(t).whichtest = find(sum(testmatch));%1 = immediate, 2 = one-day
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
%     if(~strcmp(tmpstudyname, tmpmatchname))
%       fprintf('Error: wrong image match for patient %s, study trial %d.\n', patient(p).name, t);
%     end
% 
% 
%     %get test info to match to study image
%     patient(p).phase(1).trial(t).test_rt = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).rt;
% 
%     patient(p).phase(1).trial(t).test_yes_no = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).yes_or_no;
% 
%     patient(p).phase(1).trial(t).test_sure_notsure = ...
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).sure_notsure;
% 
%     patient(p).phase(1).trial(t).test_trial_type = ... %sanity check
%       patient(p).phase(patient(p).phase(1).trial(t).whichtest+1).trial(patient(p).phase(1).trial(t).whichtesttrial).trial_type;
%     %if this doesn't match, we gotta problem
%     if(patient(p).phase(1).trial(t).stimulation==1)
%       temptype = '1s stim';
%     elseif (patient(p).phase(1).trial(t).stimulation==3)
%       temptype = '3s stim';
%     elseif (patient(p).phase(1).trial(t).stimulation==0)
%       temptype = 'nostim';
%     else
%       temptype = 'new';
%     end
% 
%     if(~strcmp(temptype, patient(p).phase(1).trial(t).test_trial_type))
%       fprintf('Error: wrong trial type for patient %s, test %d trial %d.\n', patient(p).name, ...
%         patient(p).phase(1).trial(t).whichtest,...
%         patient(p).phase(1).trial(t).whichtesttrial);
%     end
% 
%   end%end of study trials
% end%patient