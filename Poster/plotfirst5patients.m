function plotfirst5patients(patient)    
origsecsbefore = 5;%how many seconds worth of data saved in patient structure prior to image onset
secstouse = .5;%how many seconds of each trial to use

%regions: 1 = "best" hippocampus; 3 = Perirhinal; 4 = BLA
rg1touse = 5;
rg2touse = 4;
rg3touse = 7;


params.fpass=[1 100]; % band of frequencies to be kept
%params.tapers=[5 9]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
%get output for each trial and average AFTER
params.trialave=0;

ttcolor={'Red', 'Blue', 'Green'};
regioncolor={ 'Magenta','Orange', 'Cyan'};
testname{1} = 'Immediate Test';
testname{2} = 'One-Day Test';
trialType = ["Stim","NoStim","New"];
%%
PatientNames = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
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
% writetable(T,"ChannelList.csv")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GO THROUGH IMMEDIATE AND ONE-DAY TESTS TO GET DATA FOR EACH PATIENT  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-> 6 trials of rememebered & Stimulated

for ph=3%phase 2 and 3 = immediate and one-day tests, respectively
  
  
  pctr = 0;%counter for patients with useable data for this analysis
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %      GO THROUGH EACH PATIENT          %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for p = 1:length(patient)
    fprintf('\tWorking on %s . . .\n', patient(p).name)
    params.Fs=patient(p).samprate;
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
    % if(length(patient(p).phase(ph).trial_start_times)==length(patient(p).phase(ph).trial) && ~isempty(patient(p).ipsi_region(rg1touse).lfpnum))
      
      %WE WILL USE ONLY THOSE FIVE PATIENTS WHO HAVE USEABLE DATA FROM ALL THREE REGIONS
      if( strcmp(patient(p).name, 'amyg003') || ...
          strcmp(patient(p).name, 'amyg008') || ...
          strcmp(patient(p).name, 'amyg010') || ...
          strcmp(patient(p).name, 'amyg013') || ...
          strcmp(patient(p).name, 'amyg017') ...
          )
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
            temphiplfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind,1);
            temphipprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind,1);
            
            %BLA
            rg = rg2touse;
            tempblalfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind,1);
            tempblaprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind,1);
            
            %PERIRHINAL
            rg = rg3touse;
            if(strcmp(patient(p).name,'amyg010'))
                rg = 3;
            end
            tempperilfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind,1);
            tempperiprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind,1);
            joePRIdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(:,1);
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
      end%if one of five with all regions
  end%end of patient loop
end%phase loop

a=0;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     PLOT MEAN POWER AND COHERENCE ACROSS PARTICIPANTS   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure('name', 'MAIN SFN 2016 FIG #1', 'Color', [1 1 1]);
% set(gcf,'DefaultLineLineWidth',1)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %    TOP ROW  = POWER      %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %let's plot absolute mean (across participants) power for each region averaged across trial types
% for testnum=1:2
%   subplot(3,4,testnum), hold on
% 
%   %HIPPOCAMPUS POWER
%   %recogtest(testnum).all_H_P(pctr,ftouse,tt)
%   tmpmean = mean(recogtest(testnum).all_H_P, 3);%mean across trial types
%   tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
%   tmpmean = mean(tmpmean);%mean across patients
%   error_fill_plot(recogtest(testnum).f, tmpmean, tmpsem, regioncolor{1});
% 
%   %PERIRHINAL POWER
%   %recogtest(testnum).all_PERI_P(pctr,ftouse,tt)
%   tmpmean = mean(recogtest(testnum).all_PERI_P, 3);%mean across trial types
%   tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
%   tmpmean = mean(tmpmean);%mean across patients
%   error_fill_plot(recogtest(testnum).f, tmpmean, tmpsem, regioncolor{2});
% 
%   %BLA POWER
%   %recogtest(testnum).all_PERI_P(pctr,ftouse,tt)
%   tmpmean = mean(recogtest(testnum).all_BLA_P, 3);%mean across trial types
%   tmpsem = std(tmpmean)/sqrt(length(tmpmean(:,1)));%sem across patients
%   tmpmean = mean(tmpmean);%mean across patients
%   error_fill_plot(recogtest(testnum).f, tmpmean, tmpsem, regioncolor{3});
% 
% 
%   xlim([0 100])
%   ylim([-20 40])
%   set(gca,'XTick',0:20:100)
%   ylabel('Power (dB)'); xlabel('Frequency (Hz)');
%   %title({'First line';'Second line'})
%   title({testname{testnum}; ' Power'})
%   set(gca, 'FontName', 'Arial', 'FontSize', 20)
%   set(gca, 'FontWeight', 'bold')
%   set(gca, 'LineWidth', 1)
% end%testnum
% 
% %legend
% subplot(3,4,3), hold on
% ylim([0 100])
% xlim([0 100])
% plot([5 15], [90 90], 'Color', rgb(regioncolor{1}), 'LineWidth', 4)
% plot([5 15], [70 70], 'Color', rgb(regioncolor{2}), 'LineWidth', 4)
% plot([5 15], [50 50], 'Color', rgb(regioncolor{3}), 'LineWidth', 4)
% text(20,90, 'Hippocampus', 'Color', rgb(regioncolor{1}), 'FontName', 'Arial', 'FontSize', 20)
% text(20,70, 'Perirhinal', 'Color', rgb(regioncolor{2}), 'FontName', 'Arial', 'FontSize', 20)
% text(20,50, 'BLA', 'Color', rgb(regioncolor{3}), 'FontName', 'Arial', 'FontSize', 20)
% set(gca, 'FontWeight', 'bold')
% set(gca,'YTick',[])
% set(gca,'XTick',[])
% axis off

%%
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_PERI_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_PERI_P(:,:,noStimIdx);
bothDataP = cat(3,stimDataP,noStimDataP);
bothDataP = mean(bothDataP,3);
NP = 5;

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
title("Stim")
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
title("Stim")
legend("PRI","HPC","BLA")
title("noStim")

subplot 133
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
title("Stim")
legend("PRI","HPC","BLA")
title("Both Stim No Stim")
%% Baseline Adjusted for PRI
dayIdx = 2; %Day 3
stimIdx = 1; %With Stim
noStimIdx = 2; %Without Stim
stimDataP = recogtest(dayIdx).all_PERI_diff_P(:,:,stimIdx);
noStimDataP = recogtest(dayIdx).all_PERI_diff_P(:,:,noStimIdx);
freqs  = recogtest(dayIdx).f;

figure
gDat = stimDataP;
plot(freqs,gDat)
title("Stim")
legend(vertcat(patient([3,6,8,10,14]).name))

figure
gDat = noStimDataP;
plot(freqs,gDat)
title("noStim")
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
title("Stim")
legend("Stim","NoStim")
end