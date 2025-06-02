%% Initialize
clear;
clc
load("PatientStructwithEEG.mat")

%% Relabel Trials to Stim and no Stim

phaseIdx = 3; % Process data for only phase 3 (day 2)
for pIdx = 1:length(patient)
    disp("---------------Processing Patient: "+string(patient(pIdx).name))
    % Get trial types
    A = convertCharsToStrings({patient(pIdx).phase(phaseIdx).trial.trial_type})';
    disp("Trial types before change:")
    disp(unique(A))
    for tIdx = 1:length(patient(pIdx).phase(phaseIdx).trial)
        if(contains(patient(pIdx).phase(phaseIdx).trial(tIdx).trial_type,'stim')) %find trials that have 'stim' in their type
            if(~contains(patient(pIdx).phase(phaseIdx).trial(tIdx).trial_type,'nostim')) % make sure they are not nostim;
                patient(pIdx).phase(phaseIdx).trial(tIdx).trial_type = 'stim';
            end
        end
    end
    A = convertCharsToStrings({patient(pIdx).phase(phaseIdx).trial.trial_type})';
    disp("Trial types after change:")
    disp(unique(A))
end
    

%% Compute Power and Coherency
origsecsbefore = 5;%how many seconds worth of data saved in patient structure prior to image onset
secstouse = .5;%how many seconds of each trial to use

%regions: 1 = "best" hippocampus; 3 = Perirhinal; 4 = BLA
rg1touse = 1;
rg2touse = 4;
rg3touse = 3;


params.fpass=[1 100]; % band of frequencies to be kept
%params.tapers=[5 9]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
%get output for each trial and average AFTER
params.trialave=0;

ttcolor={'Red', 'Blue', 'Green'};
regioncolor={ 'Magenta','Orange', 'Cyan'};
regioncolor_C={ 'Orange', 'Cyan','Magenta'};
testname{1} = 'Immediate Test';
testname{2} = 'One-Day Test';
trialType = ["Stim","NoStim","New"];

removenoe = [2,3,5,7,9,10,12,13,14,16,17,19,23];
pNameList = [];
for ph=3%phase 2 and 3 = immediate and one-day tests, respectively
  
  
  pctr = 0;%counter for patients with useable data for this analysis
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %      GO THROUGH EACH PATIENT          %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for p = 1:length(patient)
    if(sum(ismember(string(removenoe),string(p)))==0)  
    fprintf('\tWorking on %s . . .\n', patient(p).name)
    pNameList = cat(1,pNameList,string(patient(p).name));
    params.Fs=patient(p).samprate;
    disp(patient(p).samprate)
    origsampsbefore = round(patient(p).samprate * origsecsbefore);
    
    startind = origsampsbefore+round(patient(p).samprate/10);%1/10th sec after image onset
    stopind =  origsampsbefore+round(patient(p).samprate/10) +round(patient(p).samprate * secstouse);%after image onset, total = secstouse secs plus 100 ms
    prestartind = origsampsbefore-round(patient(p).samprate/10)-round(patient(p).samprate * secstouse);%secstouse plus 100 ms before image onset
    prestopind =  origsampsbefore-round(patient(p).samprate/10);%1/10th sec before image onset
    
    
    %counter of number of trials in each of three conditions for this patient
    stim_nostim_new_ctr = [0 0 0];
    
    %set up data structs for the three regions, inlcuding for the pre-trial baseline
    temphiplfpdata = struct('lfp',[]);
    temphipprelfpdata = struct('lfp',[]);
    
    tempblalfpdata = struct('lfp',[]);
    tempblaprelfpdata = struct('lfp',[]);
    
    tempperilfpdata = struct('lfp',[]);
    tempperiprelfpdata = struct('lfp',[]);
    joePRIdata = struct('lfp',[]);
    
    %FYI: this if now is a bit redundant with the if 3,8,19,13,17 statement below, but we will leave it in nonetheless
    if(length(patient(p).phase(ph).trial_start_times)==length(patient(p).phase(ph).trial) && ~isempty(patient(p).ipsi_region(rg1touse).lfpnum))
      
      %WE WILL USE ONLY THOSE FIVE PATIENTS WHO HAVE USEABLE DATA FROM ALL THREE REGIONS
      % if( strcmp(patient(p).name, 'amyg003') || ...
      %     strcmp(patient(p).name, 'amyg008') || ...
      %     strcmp(patient(p).name, 'amyg010') || ...
      %     strcmp(patient(p).name, 'amyg013') || ...
      %     strcmp(patient(p).name, 'amyg017') ...
      %     )
        pctr = pctr + 1;%add one to patient-with-data counter
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   GO THROUGH EACH TRIAL OF THIS TEST  %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for t = 1:length(patient(p).phase(ph).trial)%each trial
          
          
          %figure out the trial type
          if(strcmp(patient(p).phase(ph).trial(t).trial_type, 'stim'))
            ttype = 1;
          elseif(strcmp(patient(p).phase(ph).trial(t).trial_type, 'nostim'))
            ttype = 2;
          elseif(strcmp(patient(p).phase(ph).trial(t).trial_type, 'new'))
            ttype = 3;
          else%shouldn't happen
            fprintf('Error: unknown trial type on trial %t for patient %d, phase %d.\n',t,p,ph)
          end
          
          %assume the trial was incorrect ...
          tcorrect = 0;
          % ... but then see if it was in fact correct:
          %was the image judged to be old/new correctly?
          if(strcmp(patient(p).phase(ph).trial(t).yes_or_no, 'yes') && ttype < 3)
            tcorrect = 1;
          end
          if(strcmp(patient(p).phase(ph).trial(t).yes_or_no, 'no') && ttype == 3)
            tcorrect = 1;
          end
          
          patient(p).phase(ph).trial(t).type = "";
          %ONLY USE CORRECTLY-ANSWERED TRIALS
          if(tcorrect)%if it was correct, let's include that trial's data
            
            patient(p).phase(ph).trial(t).type = trialType(ttype);

            %what type of trial is this? 1, 2, 3 = stim, no stim, new, respectively
            stim_nostim_new_ctr(ttype) = stim_nostim_new_ctr(ttype) + 1;%add one to the counter
            
            %SPLIT THE LFP DATA FOR THIS PATIENT FOR THIS TEST INTO STIM, NO STIM, and NEW CONDITIONS
            
            %HIPPOCAMPUS
            rg = rg1touse;
            if(~isempty(patient(p).phase(ph).trial(t).region(rg).lfp))
                temphiplfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind);
                temphipprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind);
            end
            %BLA
            rg = rg2touse;
            if(~isempty(patient(p).phase(ph).trial(t).region(rg).lfp))
                tempblalfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind);
                tempblaprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind);
            end
            
            %PERIRHINAL
            rg = rg3touse;
            if(~isempty(patient(p).phase(ph).trial(t).region(rg).lfp))
                tempperilfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind);
                tempperiprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind);
                joePRIdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                  patient(p).phase(ph).trial(t).region(rg).lfp;
            end
          end%end if correct
        end%end of trial loop
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     NOW THAT WE HAVE THE LFP DATA FOR THE THREE REGIONS FOR THIS PATIENT FOR THIS TEST,    %
        %                  LETS CALCULATE SPECTRAL MEASURES (POWER AND COHERENCE)                    %
        %                      SEPARATELY FOR STIM, NO STIM, AND NEW CONDITIONS                      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        %GO THROUGH STIM (1), NO STIM (2), and NEW (3) CONDITIONS
        for tt = 1:3%three trial types: stim, no stim, and new
          
          %we will use different taper pareameters for the thesta range vs gamma range
          for frng = 1:2
            if(frng == 1)%theta
              params.tapers = [3 5];
            else %> theta
              params.tapers = [5 9];
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  HIPPOCAMPUS-BLA POWER AND COHERENCE  %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [C,~,~,S1,S2,f]=coherencyc(temphiplfpdata(tt).lfp',tempblalfpdata(tt).lfp',params);
            [preC,~,~,preS1,preS2]=coherencyc(temphipprelfpdata(tt).lfp',tempblaprelfpdata(tt).lfp',params);
            df = 2*(length(temphiplfpdata(tt).lfp(:,1)))*params.tapers(2);%degrees of freedom = 2 * #trials * #tapers
            C = atanh(C)-(1/(df-2));%Fisher-transformed and bias corrected
            %first LFP spectra/power (Hippocampus)
            S1 = 10*(log10(S1)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            %second LFP spectra/power (BLA)
            S2 = 10*(log10(S2)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            %pre-trial basline
            preC = atanh(preC)-(1/(df-2));%Fisher-transformed and bias corrected
            preS1 = 10*(log10(preS1)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            preS2 = 10*(log10(preS2)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            tempmeanC = mean(C,2);
            diffC = C - preC;
            tempmeandiffC = mean(diffC,2);
            tempmeanS1 = mean(S1,2);
            tempmeanS2 = mean(S2,2);
            diffS1 = S1 - preS1;
            diffS2 = S2 - preS2;
            tempmeandiffS1 = mean(diffS1,2);
            tempmeandiffS2 = mean(diffS2,2);
            allf = f;
            if(frng == 1)%theta
              ftouse = f<=15;
            else %> theta
              ftouse = f>15;
            end
            %SAVE THE DATA FOR THIS PATIENT/TEST/CONDITION/TAPER RANGE
            recogtest(ph-1).all_H_BLA_C(pctr,ftouse,tt) =  tempmeanC(ftouse);  %#ok<AGROW>
            recogtest(ph-1).all_H_P(pctr,ftouse,tt) =  tempmeanS1(ftouse);  %#ok<AGROW>
            recogtest(ph-1).all_BLA_P(pctr,ftouse,tt) =  tempmeanS2(ftouse);  %#ok<AGROW>
            recogtest(ph-1).all_H_BLA_diff_C(pctr,ftouse,tt) =  tempmeandiffC(ftouse); %#ok<AGROW>
            recogtest(ph-1).all_H_diff_P(pctr,ftouse,tt) =  tempmeandiffS1(ftouse); %#ok<AGROW>
            recogtest(ph-1).all_BLA_diff_P(pctr,ftouse,tt) =  tempmeandiffS2(ftouse); %#ok<AGROW>
            
            %just get f once
            recogtest(ph-1).f = allf; %#ok<AGROW> %okay to assume frequencies the same across metrics
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  HIPPOCAMPUS-PERI POWER AND COHERENCE %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %no need to get hippocampus power again
            [C,~,~,~,S2,f]=coherencyc(temphiplfpdata(tt).lfp',tempperilfpdata(tt).lfp',params);
            [preC,~,~,~,preS2]=coherencyc(temphipprelfpdata(tt).lfp',tempperiprelfpdata(tt).lfp',params);
            df = 2*(length(temphiplfpdata(tt).lfp(:,1)))*params.tapers(2);%degrees of freedom = 2 * #trials * #tapers
            C = atanh(C)-(1/(df-2));%Fisher-transformed and bias corrected
            %first LFP spectra/power (Hippocampus)
            %S1 = 10*(log10(S1)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            %second LFP spectra/power (PERI)
            S2 = 10*(log10(S2)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            %pre-trial basline
            preC = atanh(preC)-(1/(df-2));%Fisher-transformed and bias corrected
            %preS1 = 10*(log10(preS1)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            preS2 = 10*(log10(preS2)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
            tempmeanC = mean(C,2);
            diffC = C - preC;
            tempmeandiffC = mean(diffC,2);
            %tempmeanS1 = mean(S1,2);
            tempmeanS2 = mean(S2,2);
            %diffS1 = S1 - preS1;
            diffS2 = S2 - preS2;
            %tempmeandiffS1 = mean(diffS1,2);
            tempmeandiffS2 = mean(diffS2,2);
            
            if(frng == 1)%theta
              ftouse = f<=15;
            else %> theta
              ftouse = f>15;
            end
            %SAVE THE DATA FOR THIS PATIENT/TEST/CONDITION/TAPER RANGE--NO NEED TO SAVE HIP POWER AGAIN
            recogtest(ph-1).all_H_PERI_C(pctr,ftouse,tt) =  tempmeanC(ftouse);  %#ok<AGROW>
            %recogtest(ph-1).all_H_P(pctr,ftouse,tt) =  tempmeanS1(ftouse);  %#ok<AGROW>
            recogtest(ph-1).all_PERI_P(pctr,ftouse,tt) =  tempmeanS2(ftouse);  %#ok<AGROW>
            recogtest(ph-1).all_H_PERI_diff_C(pctr,ftouse,tt) =  tempmeandiffC(ftouse); %#ok<AGROW>
            %recogtest(ph-1).all_H_diff_P(pctr,ftouse,tt) =  tempmeandiffS1(ftouse); %#ok<AGROW>
            recogtest(ph-1).all_PERI_diff_P(pctr,ftouse,tt) =  tempmeandiffS2(ftouse); %#ok<AGROW>
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %          BLA-PERI  COHERENCE          %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %no need to get power again
            [C,~,~,~,~,f]=coherencyc(tempblalfpdata(tt).lfp',tempperilfpdata(tt).lfp',params);
            [preC,~,~,~,~]=coherencyc(tempblaprelfpdata(tt).lfp',tempperiprelfpdata(tt).lfp',params);
            df = 2*(length(tempblalfpdata(tt).lfp(:,1)))*params.tapers(2);%degrees of freedom = 2 * #trials * #tapers
            C = atanh(C)-(1/(df-2));%Fisher-transformed and bias corrected
            preC = atanh(preC)-(1/(df-2));%Fisher-transformed and bias corrected
            tempmeanC = mean(C,2);
            diffC = C - preC;
            tempmeandiffC = mean(diffC,2);
            
            if(frng == 1)%theta
              ftouse = f<=15;
            else %> theta
              ftouse = f>15;
            end
            %SAVE THE DATA FOR THIS PATIENT/TEST/CONDITION/TAPER RANGE--NO NEED TO SAVE POWER AGAIN
            recogtest(ph-1).all_BLA_PERI_C(pctr,ftouse,tt) =  tempmeanC(ftouse);  %#ok<AGROW>
            recogtest(ph-1).all_BLA_PERI_diff_C(pctr,ftouse,tt) =  tempmeandiffC(ftouse); %#ok<AGROW>
            
            
            
          end%frng
        end%tt
      % end%if one of five with all regions
    end%~isempty start times
  end%end of patient loop
  end
end%phase loop
%%
NP = 10;
%% Power Data Individual Participants
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_PERI_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_PERI_P(:,:,noStimIdx);
bothDataP = cat(3,stimDataP,noStimDataP);
bothDataP = mean(bothDataP,3);


stimDataHPC = recogtest(dayIdx).all_H_P(:,:,stimIdx);
noStimDataHPC = recogtest(dayIdx).all_H_P(:,:,noStimIdx);
bothDataHPC = cat(3,stimDataHPC,noStimDataHPC);
bothDataHPC = mean(bothDataHPC,3);

stimDataBLA = recogtest(dayIdx).all_BLA_P(:,:,stimIdx);
noStimDataBLA = recogtest(dayIdx).all_BLA_P(:,:,noStimIdx);
bothDataBLA = cat(3,stimDataBLA,noStimDataBLA);
bothDataBLA = mean(bothDataBLA,3);

freqs  = recogtest(dayIdx).f;

figure
subplot 311
gDat = stimDataP;
plot(freqs,gDat,'LineWidth',2)
legend(pNameList)
title("PERI")

subplot 312
gDat = stimDataHPC;
plot(freqs,gDat,'LineWidth',2)
legend(pNameList)
title("HPC")

subplot 313
gDat = stimDataBLA;
plot(freqs,gDat,'LineWidth',2)
legend(pNameList)
title("BLA")


%% Power Data
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_PERI_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_PERI_P(:,:,noStimIdx);
bothDataP = cat(3,stimDataP,noStimDataP);
bothDataP = mean(bothDataP,3);


stimDataHPC = recogtest(dayIdx).all_H_P(:,:,stimIdx);
noStimDataHPC = recogtest(dayIdx).all_H_P(:,:,noStimIdx);
bothDataHPC = cat(3,stimDataHPC,noStimDataHPC);
bothDataHPC = mean(bothDataHPC,3);

stimDataBLA = recogtest(dayIdx).all_BLA_P(:,:,stimIdx);
noStimDataBLA = recogtest(dayIdx).all_BLA_P(:,:,noStimIdx);
bothDataBLA = cat(3,stimDataBLA,noStimDataBLA);
bothDataBLA = mean(bothDataBLA,3);

freqs  = recogtest(dayIdx).f;

figure
subplot 131
gDat = stimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{1}))
hold on
gDat = stimDataHPC;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{2}))
gDat = stimDataBLA;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{3}))

gDat = stimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = stimDataHPC;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = stimDataBLA;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{3}), 'FaceAlpha',0.25,'EdgeColor','none')
title("Stimulation")
legend("PRI","HPC","BLA")

subplot 132
gDat = noStimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{1}))
hold on
gDat = noStimDataHPC;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{2}))
gDat = noStimDataBLA;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{3}))

gDat = noStimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataHPC;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataBLA;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{3}), 'FaceAlpha',0.25,'EdgeColor','none')
legend("PRI","HPC","BLA")
title("No Stimulation")

subplot 133
figure
gDat = bothDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{1}))
hold on
gDat = bothDataHPC;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{2}))
gDat = bothDataBLA;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor{3}))

gDat = bothDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = bothDataHPC;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = bothDataBLA;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor{3}), 'FaceAlpha',0.25,'EdgeColor','none')
xlabel("Frequency (Hz)")
ylabel("Power (dB)")
legend("PERI","HPC","BLA")
title("Power")
xlim([0,50])

%% Baseline Adjusted for PERI
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_PERI_diff_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_PERI_diff_P(:,:,noStimIdx);
freqs  = recogtest(dayIdx).f;

figure
gDat = stimDataP;
plot(freqs,gDat)
title("Stimulation")
legend(vertcat(patient([3,6,8,10,14]).name))

figure
gDat = noStimDataP;
plot(freqs,gDat)
title("No Stimulation")
legend(vertcat(patient([3,6,8,10,14]).name))


figure
gDat = stimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{1}))
hold on
gDat = noStimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{2}))

gDat = stimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
legend("Stimulation","No Stimumlation")
xlim([0,50])
title("PERI Power")
xlabel("Frequency (Hz)")
ylabel("Adjusted Power (dB)")

%% Baseline Adjusted for PERI
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_H_diff_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_H_diff_P(:,:,noStimIdx);
freqs  = recogtest(dayIdx).f;



figure
gDat = stimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{1}))
hold on
gDat = noStimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{2}))

gDat = stimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
legend("Stimulation","No Stimumlation")
xlim([0,50])
title("HIPP Power")
xlabel("Frequency (Hz)")
ylabel("Adjusted Power (dB)")

%% Baseline Adjusted for PERI
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_BLA_diff_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_BLA_diff_P(:,:,noStimIdx);
freqs  = recogtest(dayIdx).f;



figure
gDat = stimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{1}))
hold on
gDat = noStimDataP;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{2}))

gDat = stimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataP;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
legend("Stimulation","No Stimumlation")
xlim([0,50])
title("BLA Power")
xlabel("Frequency (Hz)")
ylabel("Adjusted Power (dB)")

%% Coherency Plots
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataH_BLA = recogtest(dayIdx).all_H_BLA_C(:,:,stimIdx);
noStimDataH_BLA = recogtest(dayIdx).all_H_BLA_C(:,:,noStimIdx);
bothDataH_BLA = cat(3,stimDataH_BLA,noStimDataH_BLA);
bothDataH_BLA = mean(bothDataH_BLA,3);

stimDataBLA_PERI = recogtest(dayIdx).all_BLA_PERI_C(:,:,stimIdx);
noStimDataBLA_PERI = recogtest(dayIdx).all_BLA_PERI_C(:,:,noStimIdx);
bothDataBLA_PERI = cat(3,stimDataBLA_PERI,noStimDataBLA_PERI);
bothDataBLA_PERI = mean(bothDataBLA_PERI,3);

stimDataH_PERI = recogtest(dayIdx).all_H_PERI_C(:,:,stimIdx);
noStimDataH_PERI = recogtest(dayIdx).all_H_PERI_C(:,:,noStimIdx);
bothDataH_PERI = cat(3,stimDataH_PERI,noStimDataH_PERI);
bothDataH_PERI = mean(bothDataH_PERI,3);

freqs  = recogtest(dayIdx).f;


figure
gDat = bothDataH_BLA;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor_C{1}))
hold on
gDat = bothDataBLA_PERI;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor_C{2}))
gDat = bothDataH_PERI;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(regioncolor_C{3}))

gDat = bothDataH_BLA;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor_C{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = bothDataBLA_PERI;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor_C{2}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = bothDataH_PERI;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(regioncolor_C{3}), 'FaceAlpha',0.25,'EdgeColor','none')
legend("HIPP-BLA","BLA-PERI","PERI-HIPP")
title("Coherency")
xlabel("Frequency (Hz)")
ylabel("Coherence")
xlim([0,20])

%% Coherency Plots Baseline Adjusted
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataH_BLA = recogtest(dayIdx).all_H_BLA_diff_C(:,:,stimIdx);
noStimDataH_BLA = recogtest(dayIdx).all_H_BLA_diff_C(:,:,noStimIdx);

stimDataBLA_PERI = recogtest(dayIdx).all_BLA_PERI_diff_C(:,:,stimIdx);
noStimDataBLA_PERI = recogtest(dayIdx).all_BLA_PERI_diff_C(:,:,noStimIdx);

stimDataH_PERI = recogtest(dayIdx).all_H_PERI_diff_C(:,:,stimIdx);
noStimDataH_PERI = recogtest(dayIdx).all_H_PERI_diff_C(:,:,noStimIdx);

freqs  = recogtest(dayIdx).f;

figure
gDat = stimDataH_BLA;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{1}))
hold on
gDat = noStimDataH_BLA;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{2}))

gDat = stimDataH_BLA;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataH_BLA;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
title("Stim")
% ylim([-.25,.25])
legend("Stimulation","No Stimulation")
title("HIPP-BLA")
axis tight
xlim([0,20])

figure
gDat = stimDataBLA_PERI;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{1}))
hold on
gDat = noStimDataBLA_PERI;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{2}))

gDat = stimDataBLA_PERI;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataBLA_PERI;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
title("Stim")
axis tight
xlim([0,20])
% ylim([-.25,.25])
legend("Stimulation","No Stimulation")
title("BLA-PERI")


figure
gDat = stimDataH_PERI;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{1}))
hold on
gDat = noStimDataH_PERI;
plot(freqs,mean(gDat),'LineWidth',2,Color=rgb(ttcolor{2}))

gDat = stimDataH_PERI;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{1}), 'FaceAlpha',0.25,'EdgeColor','none')
gDat = noStimDataH_PERI;
patch([freqs, flip(freqs)], [mean(gDat)-std(gDat)/sqrt(NP), flip(mean(gDat)+std(gDat)/sqrt(NP))]', rgb(ttcolor{2}), 'FaceAlpha',0.25,'EdgeColor','none')
title("Stim")
axis tight
xlim([0,20])
% ylim([-.25,.25])
legend("Stimulation","No Stimulation")
title("PERI-HIPP")

%%
regioncolor={ 'Orange', 'Magenta','Cyan'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     PLOT MEAN POWER AND COHERENCE ACROSS PARTICIPANTS   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name', 'MAIN SFN 2016 FIG #3', 'Color', [1 1 1]);
set(gcf,'DefaultLineLineWidth',1)

alldata = zeros(10,9,3);%subjects by subplot by anatomy 
%let's plot absolute mean (across participants) coherece for each region pair averaged across trial types
for testnum=2
  
  %%%%%%%%%%%%%%%%%%%%
  %   THETA POWER    %
  %%%%%%%%%%%%%%%%%%%%
  subplot(2,9,(testnum-1)*4+1+9+testnum-1), hold on
  whichftouse = logical(recogtest(testnum).f>=5) & logical(recogtest(testnum).f<=7);
  tmpfreqmean = zeros(1,3);
  tmpfreqsem = zeros(1,3);
  
  %hippocampus theta power
  tmpmean = mean(recogtest(testnum).all_H_diff_P(:,whichftouse,1),2) - mean(recogtest(testnum).all_H_diff_P(:,whichftouse,2),2);%stim - no stim
  
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+1+testnum-1, 1) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(1) = tmpmean;
  tmpfreqsem(1) = tmpsem;
  
  %PERI theta power
  tmpmean = mean(recogtest(testnum).all_PERI_diff_P(:,whichftouse,1),2) - mean(recogtest(testnum).all_PERI_diff_P(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+1+testnum-1, 2) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(2) = tmpmean;
  tmpfreqsem(2) = tmpsem;
    
  %BLA theta power
  tmpmean = mean(recogtest(testnum).all_BLA_diff_P(:,whichftouse,1),2) - mean(recogtest(testnum).all_BLA_diff_P(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+1+testnum-1, 3) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(3) = tmpmean;
  tmpfreqsem(3) = tmpsem;
  
% figure
  for rg = 1:3
    bar(rg, tmpfreqmean(rg), 1, 'FaceColor', rgb(regioncolor{rg}))
  end
  errorbar(1:3, tmpfreqmean, tmpfreqsem, '.k')
  
  xlim([0.25 3.75])
  ylim([-1.5 1.5])
  set(gca,'XTick',[])
  ylabel('Power (dB)');
  xlabel('Frequency (Hz)');
  title('Theta')
  set(gca, 'FontName', 'Arial', 'FontSize', 15)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%
  %   GAMMA POWER    %
  %%%%%%%%%%%%%%%%%%%%
  subplot(2,9,(testnum-1)*4+2+9+testnum-1), hold on
  whichftouse = logical(recogtest(testnum).f>=30) & logical(recogtest(testnum).f<=49);
  tmpfreqmean = zeros(1,3);
  tmpfreqsem = zeros(1,3);
  
  %hippocampus gamma power
  tmpmean = mean(recogtest(testnum).all_H_diff_P(:,whichftouse,1),2) - mean(recogtest(testnum).all_H_diff_P(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+2+testnum-1, 1) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(1) = tmpmean;
  tmpfreqsem(1) = tmpsem;
  
  %PERI gamma power
  tmpmean = mean(recogtest(testnum).all_PERI_diff_P(:,whichftouse,1),2) - mean(recogtest(testnum).all_PERI_diff_P(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+2+testnum-1, 2) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(2) = tmpmean;
  tmpfreqsem(2) = tmpsem;
  
  %BLA gamma power
  tmpmean = mean(recogtest(testnum).all_BLA_diff_P(:,whichftouse,1),2) - mean(recogtest(testnum).all_BLA_diff_P(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+2+testnum-1, 3) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(3) = tmpmean;
  tmpfreqsem(3) = tmpsem;
  
  
  %indicate statistical significance 
  if(testnum==2)
    text(2,1.25,'*','FontName', 'Arial', 'FontSize', 48, 'HorizontalAlignment', 'center', 'Color', [1 0 0])
  end
  
  for rg = 1:3
    bar(rg, tmpfreqmean(rg), 1, 'FaceColor', rgb(regioncolor{rg}))
  end
  errorbar(1:3, tmpfreqmean, tmpfreqsem, '.k')
  
  xlim([0.25 3.75])
  ylim([-1.5 1.5])
  set(gca,'XTick',[])
  ylabel('Power (dB)');
  xlabel('Frequency (Hz)');
  title('Gamma')
  set(gca, 'FontName', 'Arial', 'FontSize', 15)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%
  %  THETA COHERENCE %
  %%%%%%%%%%%%%%%%%%%%
  subplot(2,9,(testnum-1)*4+3+9+testnum-1), hold on
  whichftouse = logical(recogtest(testnum).f>=5) & logical(recogtest(testnum).f<=7);
  tmpfreqmean = zeros(1,3);
  tmpfreqsem = zeros(1,3);
  
  %hippocampus-BLA coherence
  tmpmean = mean(recogtest(testnum).all_H_BLA_diff_C(:,whichftouse,1),2) - mean(recogtest(testnum).all_H_BLA_diff_C(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+3+testnum-1, 1) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(1) = tmpmean;
  tmpfreqsem(1) = tmpsem;
  
  %H-PERI coherence
  tmpmean = mean(recogtest(testnum).all_H_PERI_diff_C(:,whichftouse,1),2) - mean(recogtest(testnum).all_H_PERI_diff_C(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+3+testnum-1, 2) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(2) = tmpmean;
  tmpfreqsem(2) = tmpsem;
  
  %BLA-PERI COHERENCE
  tmpmean = mean(recogtest(testnum).all_BLA_PERI_diff_C(:,whichftouse,1),2) - mean(recogtest(testnum).all_BLA_PERI_diff_C(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+3+testnum-1, 3) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(3) = tmpmean;
  tmpfreqsem(3) = tmpsem;
  
  %indicate statistical significance
  if(testnum==2)
   text(2,.27,'*','FontName', 'Arial', 'FontSize', 48, 'HorizontalAlignment', 'center', 'Color', [1 0 0])
  end
  
  for rg = 1:3
    bar(rg, tmpfreqmean(rg), 1, 'FaceColor', rgb(regioncolor{rg}))
  end
  errorbar(1:3, tmpfreqmean, tmpfreqsem, '.k')
  
  xlim([0.25 3.75])
  ylim([-.3 .3])
  set(gca,'XTick',[])
  set(gca,'YTick',-.3:.1:.3)
  ylabel('Coherence');
  xlabel('Frequency (Hz)');
  title('Theta')
  set(gca, 'FontName', 'Arial', 'FontSize', 15)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%
  %  GAMMA COHERENCE %
  %%%%%%%%%%%%%%%%%%%%
  subplot(2,9,(testnum-1)*4+4+9+testnum-1), hold on
  whichftouse = logical(recogtest(testnum).f>=30) & logical(recogtest(testnum).f<=40);
  tmpfreqmean = zeros(1,3);
  tmpfreqsem = zeros(1,3);
  
  %hippocampus-BLA coherence
  tmpmean = mean(recogtest(testnum).all_H_BLA_diff_C(:,whichftouse,1),2) - mean(recogtest(testnum).all_H_BLA_diff_C(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+4+testnum-1, 1) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(1) = tmpmean;
  tmpfreqsem(1) = tmpsem;
  
  %H-PERI coherence
  tmpmean = mean(recogtest(testnum).all_H_PERI_diff_C(:,whichftouse,1),2) - mean(recogtest(testnum).all_H_PERI_diff_C(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+4+testnum-1, 2) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(2) = tmpmean;
  tmpfreqsem(2) = tmpsem;
  
  %BLA-PERI COHERENCE
  tmpmean = mean(recogtest(testnum).all_BLA_PERI_diff_C(:,whichftouse,1),2) - mean(recogtest(testnum).all_BLA_PERI_diff_C(:,whichftouse,2),2);%stim - no stim
  tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
  alldata(:,(testnum-1)*4+4+testnum-1, 3) = tmpmean;
  tmpmean = mean(tmpmean);%mean across patients
  tmpfreqmean(3) = tmpmean;
  tmpfreqsem(3) = tmpsem;
  
  for rg = 1:3
    bar(rg, tmpfreqmean(rg), 1, 'FaceColor', rgb(regioncolor{rg}))
  end
  errorbar(1:3, tmpfreqmean, tmpfreqsem, '.k')
  
  xlim([0.25 3.75])
  ylim([-.3 .3])
  set(gca,'YTick',-.3:.1:.3)
  set(gca,'XTick',[])
  ylabel('Coherence');
  xlabel('Frequency (Hz)');
  title('Gamma')
  set(gca, 'FontName', 'Arial', 'FontSize', 15)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  
  
  a=0;
  
end%testnum