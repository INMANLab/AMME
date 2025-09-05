%% Original Group

RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";

cPath = pwd;
cd(RDD) %go to Raw Data directory
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 Find the median lfp of all lfps                  %
% %                 global median can be used later                  %
% %                 to re-reference all the channels                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fprintf('Calculating median LFP ...\n')

for p = 1:length(patient)
    if (~strcmp(patient(p).exp,"Original"))
        continue
    end
  disp("Working on patient "+ string(patient(p).name))
  cd(patient(p).name)%go into patient's directory
  for d=2
    fprintf('\t\tDay %d...\n',d)
    tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,1);%load first lfp just to find out how long it is
    load(tmplfpfn)%load the lfp from the .mat file;
    lfplen = length(lfp);
    clear lfp
    tempalllfps = zeros(patient(p).maxchan,lfplen);
    fprintf('\t\t...')
    for ch = 1:patient(p).maxchan
      fprintf(' %d ',ch)
      tmplfpfn = sprintf('day%d_lfp_%03d.mat',d,ch);
      load(tmplfpfn)%load the lfp from the .mat file; 
      if(length(lfp)~=lfplen)
        fprintf('\n...error: lfp %d not same length as first lfp...\n',ch)
      end
      tempalllfps(ch,:) = lfp;
      clear lfp
    end%channel
    fprintf('\n')

    %let's take out the sync channel and, on day 1, the stim channels
    tempdelch = str2num(patient(p).syncfn(end-6:end-4)); %#ok<ST2NM>
    if(d==1)
      for sc = 1:length(patient(p).stimchan)%take out ipsi stim channels on day 1
        tempdelch = [tempdelch patient(p).stimchan(sc).num]; %#ok<AGROW>
      end
    end
    tempalllfps(tempdelch, :) = [];%delete the unwanted channels
    medlfp = median(tempalllfps);
    clear tempalllfps
    tmpmedlfpfn = sprintf('day%d_median_lfp.mat',d);%file name
    save(tmpmedlfpfn,'medlfp');
    clear medlfp

  end%day
  cd ..
end%patient


fprintf('\tDone; median LFPs saved as .mat files ...\n')

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   GET THE LFPS FOR IPSILATERAL                   %
%                 CA FIELDS, DG, AND PHG, EC, PRC                  %
%                from the study phase, if available                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Getting LFP data for ispilateral select regions...\n')

params.fpass=[1 120]; % band of frequencies to be kept
params.tapers=[1 1]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave=1;
movingwin = [.5 .05];

for p = 1:length(patient)
    if (~strcmp(patient(p).exp,"Original"))
        continue
    end
  disp("Working on patient "+ string(patient(p).name))
  cd(patient(p).name)%go into patient's directory
  params.Fs=patient(p).samprate;
  %hard-coded here to get 10 seconds (-5 to +5 around image onset)
  sampsbefore = round(patient(p).samprate * 5);
  sampsafter = round(patient(p).samprate * 5);
  for ph=3
    fprintf('\t\tPhase %d...\n',ph)
    if(ph<3)
      d=1;
    else
      d=2;
    end
    %load median lfp for re-referencing
    load(sprintf('day%d_median_lfp.mat',d));%variable called medlfp

    for rg = 1:length(patient(p).ipsi_region)
      if(isempty(patient(p).ipsi_region(rg).lfpnum))
          for t = 1:length(patient(p).phase(ph).trial)
            patient(p).phase(ph).trial(t).region(rg).lfp = [];
          end
      end
      for lnum = 1:length(patient(p).ipsi_region(rg).lfpnum)
        if(ph<3)
          tmplfpfn = sprintf('day1_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
        else
          tmplfpfn = sprintf('day2_lfp_%03d.mat',patient(p).ipsi_region(rg).lfpnum(lnum));
        end
        load(tmplfpfn)%load the lfp from the .mat file; not 100% efficient to load first day's lfp twice, but whatevs

        %subtract median lfp from this lfp--same as digitally re-referencing
        lfp = lfp-medlfp;
        lfp0 = lfp;
        lfp = rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
        lfp = rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad

%%
        % wo = 60/(params.Fs/2);  
        % bw = wo/35;
        % % [bN60,aN60] = iirnotch(wo,bw);
        % [bN60,aN60] = designNotchPeakIIR(Response="notch",FilterOrder=20,CenterFrequency=wo,Bandwidth=bw);
        % wo = 42/(params.Fs/2);  
        % bw = wo/35;
        % % [bN42,aN42] = iirnotch(wo,bw);
        % [bN42,aN42] = designNotchPeakIIR(Response="notch",FilterOrder=20,CenterFrequency=wo,Bandwidth=bw);
        % 
        % B = filtfilt(bN60,aN60, lfp0);
        % B = filtfilt(bN42,aN42, B);
        % 
        % % [S,f] = mtspectrumsegc(datReRef(:,channelPlot),movingwin(1),params);
        % [Sc1,fc1] = mtspectrumsegc(lfp0,movingwin(1),params);
        % [Sc2,fc2] = mtspectrumsegc(lfp,movingwin(1),params);
        % [Sc3,fc3] = mtspectrumsegc(B,movingwin(1),params);
        % figure
        % plot(fc1,10*log10(Sc1),fc2,10*log10(Sc2),fc3,10*log10(Sc3));
        % legend("Band-Passed","MT","Notch")
%%

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
          if(lnum==1)
              patient(p).phase(ph).trial(t).region(rg).lfp = zeros(length(tmplfp),length(patient(p).ipsi_region(rg).lfpnum));
          end
          % if(rg<7)
          patient(p).phase(ph).trial(t).region(rg).lfp(:,lnum) = tmplfp;
          % else
          %   patient(p).phase(ph).trial(t).region(rg).lfp(lnum).data = tmplfp;
          % end
        end%end of trials

        clear lfp


      end%lnum
      a=0;
    end%region
    a=0;
  end%phase
  a=0;
  cd ..
end%patient

fprintf('done with MTL subfield LFPs for Original subjects .\n')

% save('AMMEpatientstruct.mat','patient');
%save(name of output file, name of variable in workspace)