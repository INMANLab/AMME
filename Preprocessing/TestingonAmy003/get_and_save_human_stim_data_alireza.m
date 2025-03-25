%% Initialize
if(~exist("rdDir","var"))
    Initialize;
end
clearvars -except wrDir rdDir
clc

%%
%script to do analyses/plotting of human amygdala stim data
%previously called do_human_stim_analyses
%changed by JRM 6/11/16 to better reflect scope of this script
%all lfp channel numbers refer to the nth lfp, excluding the initial event channel
%thus, be careful to subtract one from each EDF file channel number to get the correct nth lfp number
%updated CSI 5/9/16
%updated JRM & CSI 6/1/16 to read in sync pulse times for test sessions
%updated JRM & CSI 6/1/16 to have current best guesses about lfp locations/numbers
%updated 7/15/2016 to calculate median lfp for each session and to use that to re-reference all lfps JRM
%updated 8/4/16 to use electrodes picked by Kelly to be "most BLA"  JRM
%updated 8/30/16 with new anatomy info for 001, 009, 010, 014, 017 JRM
%updated 9/13/16 to include region(5), which will be all available hippocampus(CA1/2/3, DG, Subiculum) electrodes
%updated 9/14/16 to remove electrodes that had large 60 cycle even after trying to remove it
%updated 10/10/16 to remove previously mislabeled electrodes for amyg002
%updated 10/10/16 to reflect Joe's inspection of ROSA screen shots
%   ... I selected most anterior hippocampus BODY (not uncus/head) electrode in CA1/2/3 or Subiculum (or DG if no other option)
%   ... goal was to prioritize positions in hippoocampus most connected to amygdala
%   ... I avoided uncus/head because in rats, BLA actually doesn't project strongly to temporal pole of hip
%   ... also, the convoluted arrangement of hippocampal layers in head might yield odd LFPs, I guessed
%updated 10/26/16: JRM looked at ROSA screen shots of 003,008,010, 013, and 017 for PHG electrodes.  Only ones who had alternates were 008 and 013.
%   ...008: 52 (original) was most similar to other patients' perirhinal contacts.  Thus, I did not change. FYI LFPs 55, 56, and 57 are closer to temporalpolar peri
%   ...013: 34 seemed to be a viable alternative.  I re-ran major analyese with 34--> everything looked the same.  I kept #35 (original) since there was no difference.

%Per Cory: 
%amyg001: could not get sync pulse times for immediate test (but yes for study and one-day)
%amyg002: no sync pulses for one-day test
%amyg005: good sync pulses for study and one-day, but sync pulses for immediate are unclear
%amyg015: no neural data recorded for one-day test (immediate is okay-ish for first 60 trials, then seizure)


%Per Kelly RE stimulated BLA electrodes to use as of 8/4/16
%updated 8/5/16 to correct amy013
%updated 9/14/16 to try to avoid noisy BLA electrodes
% Final list:
% Amyg001: LFP #128
% Amyg002: LFP #127
% Amyg008: LFP #53--per Kelly: Bestest BLAist (though not stimulated) = 52
% Amyg010: LFP #23
% Amyg014: LFP #2
% Amyg003: LFP #21
% Amyg009: LFP #12
% Amyg013: LFP #2
% Amyg015: LFP #2--per Kelly: Bestest BLAist (though not stimulated) = 3
% Amyg017: LFP #3--per Kelly: Bestest BLAist (though not stimulated) = 
% Amyg011: LFP #29
% Amyg016: LFP #66
% Amyg007: LFP #19
% Amyg005: LFP #103



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Manually assign names,                       %
%          sync pulse channel numbers, and sampling rates          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

patient(1).name  = 'amyg003';
patient(1).syncfn  = 'day1_lfp_128.mat';
patient(1).samprate = 999.41211;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 1000
patient(1).region(1).lfpnum = 32;%32=CA2/DG per Jon; 31=CA3/DG per Jon (noisy); 30=SUB per Jon (though it is noisy)
patient(1).region(2).lfpnum = [];
patient(1).region(3).lfpnum = 33;%33 = parahippocampal (peri/para border) white matter near collateral eminence per Jon; 34 = PH cortex white matter near collateral sulcus per Jon
patient(1).region(4).lfpnum = 21;%stimulated channels = 20 & 21
patient(1).region(5).lfpnum = 32;%region 5 = all possible hippocampus electrodes; see above for notes
patient(1).stimchan(1).num = 20;
patient(1).stimchan(2).num = 21;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              How many actual channels of data?                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
patient(1).maxchan = 128;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Set up the basic format of the                   %
%                       "patient" structure                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for p = 1:length(patient)
  patient(p).region(1).name = 'ipsi CA fields';
  patient(p).region(2).name = 'ipsi DG';
  patient(p).region(3).name = 'ipsi PHG';
  patient(p).region(4).name = 'ipsi BLA';
  patient(p).region(5).name = 'all ipsi hippocampus';
  %patient(p).region(1).tmpstudylfp = [];
  %patient(p).region(2).tmpstudylfp = [];
  %patient(p).region(3).tmpstudylfp = [];
  
  patient(p).phase(1).name = 'study';
  patient(p).phase(2).name = 'immediate test';
  patient(p).phase(3).name = 'one-day test';
  for ph = 1:3
    patient(p).phase(ph).samprate = patient(p).samprate;
    patient(p).phase(ph).syncfn = patient(p).syncfn;
  end
  patient(p).phase(3).syncfn(4) = '2';%change the sync filename for one-day test to reflect day2 rather than day1
  
  patient(p).sync_chnum=str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 READ IN LFPS FROM EDF FILES                      %
%   NOTE: one could alter this to avoid filtering ALL the lfps     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comment this out after running once for each patient
%FYI: this is the script in which we subtract 1 from the edf channel number (because edf channel 1 = event)
%No 60 cycle removal was done in this script.

% filter_and_save_lfps%this will take a LONG time




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE START TIMES OF EACH TRIAL                   %
% as of 6/1/16, includes study, immediate test, and one-day test   %
%   NOTE: each one of these functions was tailored to the sync     %
%                  channel for each patient                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Reading log files and getting start times for study AND both test session trials...\n')
for p = 1:length(patient)
  fprintf('\tWorking on %s . . .', patient(p).name)
  % cd(patient(p).name)%go into patient's directory
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
  
  %since we're using same LFP, let's get the sync pulse times for the IMMEDIATE TEST session
  fxn = sprintf('find_%s_imm_trial_times(lfp)', patient(p).name);
  try
    %if it works, just do it
    patient(p).phase(2).trial_start_times = eval(fxn);%calls the patient-specific function to get sync times
  catch
    %if it doesn't work, keep moving, but alert us
    fprintf(' Could not find immediate test session start times in %s...', fxn)
    patient(p).phase(2).trial_start_times = [];%nada
  end
  clear lfp
  
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
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % read in information about IMMEDIATE TEST from same log file %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fileID = fopen(logfn);
  %TRIAL	RT	YES/NO	SURE/NOT	CONDITION(stim/nostim/new) IMAGENAME
  C = textscan(fileID,'%d %f %s %s %s %s %*[^\n]', 'HeaderLines',166);%we'll skip the whole study session, treating it as "header lines"
  fclose(fileID);
  if(length(C{1})~=120)
    fprintf('Error: there should be 120 trials in immediate test session.  Check %s.\n', logfn);
  end
  %FYI
  %C{1}(1:5) should be 1, 2, 3, 4, 5, i.e., trial numbers
  %C{2}(1:5) should be RTs for first 5 trials
  %C{3}{1} should be 'yes', 'no', or 'n/a' , i.e., trial type
  %C{4}{1} should be 'sure' or 'notsure'
  %C{5}{1} should be 'stim', 'nostim', or 'new'
  %C{6}{1} should be name of image file for first trial
  for t = 1:length(C{1})
    patient(p).phase(2).trial(t).number = C{1}(t);%just to make sure we're lined up, should be 1 - 120
    patient(p).phase(2).trial(t).rt = C{2}(t); %yes/no decision rt (0 = something wrong)
    patient(p).phase(2).trial(t).yes_or_no = C{3}{t};%yes or no (or NA if no button press), as judged by participant
    patient(p).phase(2).trial(t).sure_notsure = C{4}{t};%sure or not sure, as judged by participant
    patient(p).phase(2).trial(t).trial_type = C{5}{t}; %'stim', 'nostim', or 'new'
    patient(p).phase(2).trial(t).full_im_name = C{6}{t}; %name of image, including path on testing computer
    if(length(patient(p).phase(2).trial_start_times)>=t)
      patient(p).phase(2).trial(t).start_time = patient(p).phase(2).trial_start_times(t);%time of sync pulse ping for this trial = image onset
    else
      patient(p).phase(2).trial(t).start_time = [];
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
  % cd ..
end%patients




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         PROCESS LOG FILES                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Processing data in log files...\n')
for p = 1:length(patient)
  for t = 1:length(patient(p).phase(1).trial)
    %find where the image from this study trial was tested
    tmpstudyname = patient(p).phase(1).trial(t).full_im_name;
    testmatch=zeros(120,2);%Number of trials by two tests
    for ph = 2:3%immediate test, then one-day test
      for t2 = 1:120
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

 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Find the median lfp of all lfps                  %
% %                 global median can be used later                  %
% %                 to re-reference all the channels                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf('Calculating median LFP ...\n')
% 
% for p = 1:length(patient)
%   fprintf('\tWorking on patient %d...\n',p)
%   % cd(patient(p).name)%go into patient's directory
%   for d=1:2
%     fprintf('\t\tDay %d...\n',d)
%     tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,1);%load first lfp just to find out how long it is
%     load(tmplfpfn)%load the lfp from the .mat file;
%     lfplen = length(lfp);
%     clear lfp
%     tempalllfps = zeros(patient(p).maxchan,lfplen);
%     fprintf('\t\t...')
%     for ch = 1:patient(p).maxchan
%       fprintf(' %d ',ch)
%       tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,ch);
%       load(tmplfpfn)%load the lfp from the .mat file; 
%       if(length(lfp)~=lfplen)
%         fprintf('\n...error: lfp %d not same length as first lfp...\n',ch)
%       end
%       tempalllfps(ch,:) = lfp;
%       clear lfp
%     end%channel
%     fprintf('\n')
% 
%     %let's take out the sync channel and, on day 1, the stim channels
%     tempdelch = str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
%     if(d==1)
%       for sc = 1:length(patient(p).stimchan)%take out stim channels on day 1
%         tempdelch = [tempdelch patient(p).stimchan(sc).num]; %#ok<AGROW>
%       end
%     end
%     tempalllfps(tempdelch, :) = [];%delete the unwanted channels
%     medlfp = median(tempalllfps);
%     clear tempalllfps
%     tmpmedlfpfn = sprintf('day%d_median_lfp.mat',d);%file name
%     save(tmpmedlfpfn,'medlfp');
%     clear medlfp
% 
%   end%day
%   % cd ..
% end%patient
% fprintf('\tDone; median LFPs saved as .mat files ...\n')


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   GET THE LFPS FOR IPSILATERAL                   %
%                      CA FIELDS, DG, AND PHG                      %
%                from the study phase, if available                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Geting LFP data for select regions...\n')

params.fpass=[1 120]; % band of frequencies to be kept
params.tapers=[3 5]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave=1;
movingwin = [.5 .05];

for p = 1:length(patient)
  fprintf('\tWorking on patient %d...\n',p)
  % cd(patient(p).name)%go into patient's directory
  params.Fs=patient(p).samprate;
  %hard-coded here to get 10 seconds (-5 to +5 around image onset)
  sampsbefore = round(patient(p).samprate * 5);
  sampsafter = round(patient(p).samprate * 5);
  for ph=3%1:3
    fprintf('\t\tPhase %d...\n',ph)
    if(ph<3)
      d=1;
    else
      d=2;
    end
    %load median lfp for re-referencing
    load(sprintf('day%d_median_lfp.mat',d));%variable called medlfp
    
    for rg = 1:5
      for lnum = 1:length(patient(p).region(rg).lfpnum)
        
        if(ph<3)
          tmplfpfn = sprintf('day1_lfp_%03d.mat',patient(p).region(rg).lfpnum(lnum));
        else
          tmplfpfn = sprintf('day2_lfp_%03d.mat',patient(p).region(rg).lfpnum(lnum));
        end
        
        load(tmplfpfn)%load the lfp from the .mat file; not 100% efficient to load first day's lfp twice, but whatevs
        
        %subtract median lfp from this lfp--same as digitally re-referencing
        % lfp = lfp-medlfp;

        % B = rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);
        % 
        % wo = 60/(params.Fs/2);  
        % bw = wo/35;
        % % [bN60,aN60] = iirnotch(wo,bw);
        % [B60,A60,sv] = designNotchPeakIIR(Response="notch",FilterOrder= 20,CenterFrequency=60/(params.Fs/2),Bandwidth=wo/100);
        % 
        % % notchFilter = dsp.SOSFilter(bN60,aN60);
        % % n2Filter = dsp.SOSFilter(B,A,ScaleValues=sv);
        % % dfv = dsp.DynamicFilterVisualizer(2048,params.Fs);
        % % dfv(notchFilter,n2Filter)
        % 
        % % C = filtfilt(bN60,aN60, lfp);
        % C = filtfilt(B60,A60, lfp);
        % 
        % [S,f]=mtspectrumsegc(lfp,1.5,params);
        % [Sb,fb]=mtspectrumsegc(B,1.5,params);
        % [Sc,fc]=mtspectrumsegc(C,1.5,params);
        % plot(f,10*log10(S),"LineWidth",2)
        % hold on
        % plot(fb,10*log10(Sb),fc,10*log10(Sc));
        % legend("No Filter","sineFit","iirNotch")
        % 
        % pwelch(lfp,[],[],[],params.Fs)
        % figure
        % pwelch(B,[],[],[],params.Fs)
        % figure
        % pwelch(C,[],[],[],params.Fs)
        % 
        % (data,movingwin,tau,params,p,plt,f0)
        lfp=rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
        lfp=rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad
        % 
        % 

        for t = 1:length(patient(p).phase(ph).trial)
          try
            tempindex = round(patient(p).phase(ph).trial(t).start_time*patient(p).samprate);
            tmplfp = lfp(tempindex-sampsbefore:tempindex+sampsafter-1);
          catch myerror
            fprintf('\t\tproblem on region %d, trial %d, lfpnum %d, filling in with NaNs...\n',rg, t, lnum)
            fprintf('\t\tError = %s.\n', myerror.message);
            tmplfp = zeros(sampsbefore+sampsafter,1) .* NaN;
            %patient #9, phase 2, all trials regions 1, 2, and 4 (not 3)--error matrix exceeds dimensions
            %patient #14, phase 1, trials 141-149, regions 1, 3, and 4 (not 2)--Nonfinite endpoints or increment for colon operator in index
          end
          if(rg<5)
            patient(p).phase(ph).trial(t).region(rg).lfp = tmplfp;
          else
            patient(p).phase(ph).trial(t).region(rg).lfp(lnum).data = tmplfp;
          end
        end%end of trials
        
        clear lfp
        
        
      end%lnum
    end%region
  end%phase
  % cd ..
end%patient

fprintf('done.\n')

%FYI% up to user to save patient struct to the hard drive



datMatlab = zscore(lfp);
datFilt = zscore(eeg_data(:,2));
figure
subplot 211
plot(datMatlab)
hold on
plot(datFilt)
legend("Mat","Python")
subplot 212
pwelch(datMatlab,[],[],[],999.41211)
hold on
pwelch(datFilt,[],[],[],999.41211)
legend("Mat","Python")

%% Compare this signal with Martina's preprocessing data
pythonDat = load("PythonPreprocess.mat");
pythonDat = pythonDat.eeg_data;
ch32Martina = pythonDat(33,:)*1e6;
ch32Martina = ch32Martina-mean(ch32Martina);
pwelch(ch32Martina,[],[],[],patient.samprate)

sampsbefore = round(patient.samprate * 5);
sampsafter = round(patient.samprate * 5);

trialIdx = 50;

ch32Joe = patient.phase(3).trial(trialIdx).region(1).lfp;
ch32Joe = ch32Joe - mean(ch32Joe);

trialTime = patient.phase(3).trial(trialIdx).start_time;
trialIndex = round(trialTime*patient.samprate);
ch32MartinaTrial = ch32Martina((trialIndex-sampsbefore):(sampsafter+trialIndex-1))';
% ch32MartinaTrial = ch32MartinaTrial-mean(ch32MartinaTrial);

figure
subplot 221
plot(ch32Joe)
subplot 222
pwelch(ch32Joe,[],[],[],patient.samprate)
subplot 223
plot(ch32MartinaTrial)
subplot 224
pwelch(ch32MartinaTrial,[],[],[],patient.samprate)
% legend("Joe","Martina")

figure
pwelch(ch32Joe,[],[],[],patient.samprate)
hold on
pwelch(ch32MartinaTrial,[],[],[],patient.samprate)
legend("Joe","Martina")

%% Compare this signal with Martina's preprocessing data
pythonDat = load("PythonPreprocessOrder35.mat");
pythonDat = pythonDat.eeg_data;
ch32Martina = pythonDat(33,:)*1e6;
ch32Martina = ch32Martina-mean(ch32Martina);
% pwelch(ch32Martina,[],[],[],patient.samprate)

sampsbefore = round(patient.samprate * 5);
sampsafter = round(patient.samprate * 5);

trialIdx = 50;

ch32Joe = patient.phase(3).trial(trialIdx).region(1).lfp;
ch32Joe = ch32Joe - mean(ch32Joe);

trialTime = patient.phase(3).trial(trialIdx).start_time;
trialIndex = round(trialTime*patient.samprate);
ch32MartinaTrial = ch32Martina((trialIndex-sampsbefore):(sampsafter+trialIndex-1))';
% ch32MartinaTrial = ch32MartinaTrial-mean(ch32MartinaTrial);

figure
subplot 221
plot(ch32Joe)
subplot 222
pwelch(ch32Joe,[],[],[],patient.samprate)
subplot 223
plot(ch32MartinaTrial)
subplot 224
pwelch(ch32MartinaTrial,[],[],[],patient.samprate)
% legend("Joe","Martina")

figure
pwelch(ch32Joe,[],[],[],patient.samprate)
hold on
pwelch(ch32MartinaTrial,[],[],[],patient.samprate)
legend("Joe","Martina")
title("Padded")

%% Compare this signal with Martina's preprocessing data
pythonDat = load("PythonPreprocessOrder35NoPad.mat");
pythonDat = pythonDat.eeg_data;
ch32Martina = pythonDat(33,:)*1e6;
ch32Martina = ch32Martina-mean(ch32Martina);
% pwelch(ch32Martina,[],[],[],patient.samprate)

sampsbefore = round(patient.samprate * 5);
sampsafter = round(patient.samprate * 5);

trialIdx = 4;

ch32Joe = patient.phase(3).trial(trialIdx).region(1).lfp;
ch32Joe = ch32Joe - mean(ch32Joe);

trialTime = patient.phase(3).trial(trialIdx).start_time;
trialIndex = round(trialTime*patient.samprate);
ch32MartinaTrial = ch32Martina((trialIndex-sampsbefore):(sampsafter+trialIndex-1))';
% ch32MartinaTrial = ch32MartinaTrial-mean(ch32MartinaTrial);

figure
subplot 221
plot(ch32Joe)
subplot 222
pwelch(ch32Joe,[],[],[],patient.samprate)
subplot 223
plot(ch32MartinaTrial)
subplot 224
pwelch(ch32MartinaTrial,[],[],[],patient.samprate)
% legend("Joe","Martina")

figure
pwelch(ch32Joe,[],[],[],patient.samprate)
hold on
pwelch(ch32MartinaTrial,[],[],[],patient.samprate)
legend("Joe","Martina")
title("No Padded")