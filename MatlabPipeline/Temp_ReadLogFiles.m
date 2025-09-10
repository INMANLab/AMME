%% Duration Group
function patient = ReadLogFiles(patient,p,WD)

cd(WD+string(patient(p).name))
switch patient(p).exp
    case 'Original'
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
    case 'Duration'
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          % read in information about STUDY SESSION from log file %
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
          logfn = patient(p).phase(1).logFile;
          fileID = fopen(logfn);
          C = textscan(fileID,'%d %f %s %d %s %s %s %s %*[^\n]', 'HeaderLines',3);
          fclose(fileID);
          %FYI
          %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
          %C{2}(1:5) should be RTs
          %C{3}{1} should be 'in', 'out', or 'n/a' , i.e., trial type
          %C{4}(1:5) should be 1 (1 sec stim), 3 (3 sec stim), or 0 (no stim)
          %C{5}{1} should be name of image file
          %C{6}{1} - amplitude of stimulation in microamps
          %C{7}{1} - sync from starting time in seconds
          %C{8}{1} - GetSecs computer clock 
        
          if(length(C{1})~=240)
            fprintf('Error: there should be 240 trials in study session.  Check %s.\n', logfn);
          end
          for t = 1:length(C{1})
            patient(p).phase(1).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 240
            patient(p).phase(1).trial(t).rt = C{2}(t); %in/out decision rt (-1 = no button press)
            patient(p).phase(1).trial(t).in_or_out = C{3}{t};%indoor or outdoor (or NA if no button press), as judged by participant
            patient(p).phase(1).trial(t).stimulation = C{4}(t);%stimulation = 1; no stimulation = 0
            patient(p).phase(1).trial(t).full_im_name = C{5}{t}; %name of image, including path on testing computer
            patient(p).phase(1).trial(t).amp = C{6}{t};%amplitude in microamps
            patient(p).phase(1).trial(t).sycnfromstart = C{7}{t}; %sync from starting time in seconds - cumulative
            patient(p).phase(1).trial(t).getsecs = C{8}{t}; % GetSecs computer's inner clock
        
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
    case 'Timing'
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          % read in information about STUDY SESSION from log file %
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        
          logfn = patient(p).phase(1).logFile;
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
        
       
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          % read in information about ONE DAY TEST  from 2nd log file %
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
                 
          logfn = patient(p).phase(3).logFile;
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
            patient(p).phase(3).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
            patient(p).phase(3).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
            patient(p).phase(3).trial(t).confRT = C{3}{t}; %confirmed RT (0 = something wrong)
            patient(p).phase(3).trial(t).yes_or_no = C{4}{t};%yes or no (or NA if no button press), as judged by participant
            patient(p).phase(3).trial(t).sure_notsure = C{5}{t};%sure or not sure, as judged by participant
            patient(p).phase(3).trial(t).trial_type = regexprep(C{6}{t},' ','_'); %should be 'Before', 'During', 'After', 'new'
            patient(p).phase(3).trial(t).full_im_name = C{7}{t}; %name of image, including path on testing computer
            patient(p).phase(3).trial(t).syncfromstart = C{8}{t}; %sync from start cumulative timing in seconds of sync pulses
            patient(p).phase(3).trial(t).getsecs = C{9}{t};%getsecs - computer's inner clock
            patient(p).phase(3).trial(t).yesno_time = C{10}{t}; %Yes/No trial cumulative timing in seconds from the start
            patient(p).phase(3).trial(t).sure_notsure_time = C{11}{t}; %sure/notsure tria cumulative timing in seconds from the start
        
        
            if(length(patient(p).phase(3).trial_start_times)>=t)
              patient(p).phase(3).trial(t).start_time = patient(p).phase(3).trial_start_times(t);%time of sync pulse ping for this trial = image onset
            else
              patient(p).phase(3).trial(t).start_time = [];
            end
        
          end%trial
end
end


  


