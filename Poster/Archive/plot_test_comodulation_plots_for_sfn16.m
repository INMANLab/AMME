function recogtest = plot_test_comodulation_plots_for_sfn16(patient)
%function recogtest =  plot_test_hip_bla_phg_comodulation(patient)
% run get_and_save_human_stim_data.m to get patient data structure if it doesn't exist
%JRM 11/7/16

origsecsbefore = 5;%how many seconds worth of data saved in patient structure prior to image onset
secstouse = .5;%how many seconds of each trial to use

thetalowcut = 4;
thetahighcut = 7;

%1=hip, 3=peri;4=bla
rgtouse = 4;
rg2touse = 3;
params.fpass=[1 100]; % band of frequencies to be kept
%params.tapers=[5 9]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave=0;

%movingwin = [.5 .05];
ttcolor='rbgcmykkkkkkkkk';
testname{1} = 'Immediate Test';
testname{2} = 'One-Day Test';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  let's go through first to filter first lfp for theta    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Filtering for theta . . .')
rg = rgtouse;
for ph=2:3%phase 2 and 3 = immediate and one-day tests, respectively
  for p = 1:length(patient)
    
    
    
    if( strcmp(patient(p).name, 'amyg003') || ...
        strcmp(patient(p).name, 'amyg008') || ...
        strcmp(patient(p).name, 'amyg010') || ...
        strcmp(patient(p).name, 'amyg013') || ...
        strcmp(patient(p).name, 'amyg017') ...
        )
      
      fprintf(' %d ', p)
      if(length(patient(p).phase(ph).trial_start_times)==length(patient(p).phase(ph).trial) && ~isempty(patient(p).region(rg).lfpnum))
        samprate = patient(p).phase(ph).samprate;
        
        %get filter parameters
        [n,fo,mo,w] = remezord([thetalowcut-1 thetalowcut thetahighcut thetahighcut+1], [0 1 0], [1 1 1]*0.01, samprate);
        b = remez(n,fo,mo,w);a=1;
        
        for t = 1:length(patient(p).phase(ph).trial)%each trial
          %filter
          patient(p).phase(ph).trial(t).region(rg).lfp = filtfilt(b,a, patient(p).phase(ph).trial(t).region(rg).lfp);
        end%trial
      end%if data
    end
  end%p
end%ph

fprintf('\n')











for ph=2:3%phase 2 and 3 = immediate and one-day tests, respectively
  
 % figure
  pctr = 0;%counter for patients with useable data for this analysis
  for p = 1:length(patient)
    if( strcmp(patient(p).name, 'amyg003') || ...
        strcmp(patient(p).name, 'amyg008') || ...
        strcmp(patient(p).name, 'amyg010') || ...
        strcmp(patient(p).name, 'amyg013') || ...
        strcmp(patient(p).name, 'amyg017') ...
        )
      fprintf('\tWorking on %s . . .\n', patient(p).name)
      params.Fs=patient(p).samprate;
      samprate = patient(p).samprate;
      origsampsbefore = round(patient(p).samprate * origsecsbefore);
      
      startind = origsampsbefore+round(patient(p).samprate/10);%1/10th sec after image onset
      stopind =  origsampsbefore+round(patient(p).samprate/10) +round(patient(p).samprate * secstouse);%after image onset, total = secstouse secs plus 100 ms
      prestartind = origsampsbefore-round(patient(p).samprate/10)-round(patient(p).samprate * secstouse);%secstouse plus 100 ms before image onset
      prestopind =  origsampsbefore-round(patient(p).samprate/10);%1/10th sec before image onset
      
      
      
      stim_nostim_new_ctr = [0 0 0];
      temphiplfpdata = struct('lfp',[]);
      temphipprelfpdata = struct('lfp',[]);
      
      tempblalfpdata = struct('lfp',[]);
      tempblaprelfpdata = struct('lfp',[]);
      
      
      if(length(patient(p).phase(ph).trial_start_times)==length(patient(p).phase(ph).trial) && ~isempty(patient(p).region(rgtouse).lfpnum))
        pctr = pctr + 1;%add one to patient-with-data counter
        for t = 1:length(patient(p).phase(ph).trial)%each trial
          
          if(strcmp(patient(p).phase(ph).trial(t).trial_type, 'stim'))
            ttype = 1;
          elseif(strcmp(patient(p).phase(ph).trial(t).trial_type, 'nostim'))
            ttype = 2;
          elseif(strcmp(patient(p).phase(ph).trial(t).trial_type, 'new'))
            ttype = 3;
          else%shouldn't happen
            fprintf('Error: unknown trial type on trial %t for patient %d, phase %d.\n',t,p,ph)
          end
          tcorrect = 0;
          %was the image judged to be old/new correctly?
          if(strcmp(patient(p).phase(ph).trial(t).yes_or_no, 'yes') && ttype < 3)
            tcorrect = 1;
          end
          if(strcmp(patient(p).phase(ph).trial(t).yes_or_no, 'no') && ttype == 3)
            tcorrect = 1;
          end
          
          
          if(tcorrect)%if it was correct, let's include that trial's data
            
            
            
            %region 1 = ipsi CA1 fields; region 5 = all ipsi hippocampus
            rg = rgtouse;
            
            stim_nostim_new_ctr(ttype) = stim_nostim_new_ctr(ttype) + 1;%add one to the counter
            
            
            
            
            temphiplfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind);
            temphipprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
              patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind);
            
            
            
            
            
            %region 4 = ipsi BLA
            %region 3 = ipsi PHG
            rg = rg2touse;
            if(~isempty(patient(p).region(rg).lfpnum))
              tempblalfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                patient(p).phase(ph).trial(t).region(rg).lfp(startind:stopind);
              tempblaprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                patient(p).phase(ph).trial(t).region(rg).lfp(prestartind:prestopind);
            else
              tempblalfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                zeros(length(startind:stopind),1) .* NaN;
              tempblaprelfpdata(ttype).lfp(stim_nostim_new_ctr(ttype),:) = ...
                zeros(length(prestartind:prestopind),1) .* NaN;
              
            end
            
          end%end if correct
          
          
          
        end%end of trial loop
        
        
        
        
        %subplot(3,5,p), hold on
        
        
        for tt = 1:3%three trial types: stim, no stim, and new
          
          
          [xbins, Comodulogram] = plot_human_2lfp_theta_MI(temphiplfpdata(tt).lfp,tempblalfpdata(tt).lfp, samprate, ttcolor(tt), 0);
          
          
          if( strcmp(patient(p).name, 'amyg003') || ...
              strcmp(patient(p).name, 'amyg008') || ...
              strcmp(patient(p).name, 'amyg010') || ...
              strcmp(patient(p).name, 'amyg013') || ...
              strcmp(patient(p).name, 'amyg017') ...
              )
            
            
            recogtest(ph-1).ttype(tt).xbins(p, :) = xbins;
            recogtest(ph-1).ttype(tt).comod(p,:) = Comodulogram;
            
            
          else
            recogtest(ph-1).ttype(tt).xbins(p, :) = xbins .* 0;
            recogtest(ph-1).ttype(tt).comod(p,:) = Comodulogram .* NaN;
            
          end%if one of five who have all three electrode types
          
          
          
          
          
          
          
          
        end%tt
        %xlim([0 200])
        
        %title(patient(p).name)
      end%~isempty start times
    end
  end%end of patient loop

  
  
  
  
end%phase loop







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                PLOT MAIN FIGURE                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




plotcolors = {'Red', 'Blue', 'Green'};
figure('name', 'COMODULATION SFN 2016 FIG #1', 'Color', [1 1 1]);
set(gcf,'DefaultLineLineWidth',1)


%recogtest 1= immediate; 2 = one day
for rgt = 1:2
  
  
  for tt = 1:3
    tmpxbins = recogtest(rgt).ttype(tt).xbins(recogtest(rgt).ttype(tt).comod(:,1)>0, :);
    tmpxbins = tmpxbins(1,:);%same for all, just use first good patient's
    tmpcomod = recogtest(rgt).ttype(tt).comod(recogtest(rgt).ttype(tt).comod(:,1)>0, :);
    
    %line graph
    subplot(2,4,(rgt-1)*2+1), hold on
    error_fill_plot(tmpxbins, mean(tmpcomod), std(tmpcomod)/sqrt(length(tmpcomod(:,1))), plotcolors{tt});
    
     
    %bar graph
    subplot(2,4,(rgt-1)*2+2), hold on
    bar(tt,mean(mean(tmpcomod(:,tmpxbins>=30 & tmpxbins<=55),2)), 1, ttcolor(tt))
    errorbar(tt,mean(mean(tmpcomod(:,tmpxbins>=30 & tmpxbins<=55)),2), std(mean(tmpcomod(:,tmpxbins>=30 & tmpxbins<=55), 2),[],1)/sqrt(length(tmpcomod(:,1))), 'k')
    
   
  end%tt
  
  
  subplot(2,4,(rgt-1)*2+1), hold on
  ylim([.01 .02])
  xlim([20 100])
  ylabel('MI')
  xlabel('Frequency (Hz)')
  title(testname{rgt})
  set(gca, 'FontName', 'Arial', 'FontSize', 20)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  
  subplot(2,4,(rgt-1)*2+2), hold on
  xlim([0.25 3.75])
  ylim([.01 .02])
  title('Theta-Gamma MI')
  ylabel('MI')
  set(gca, 'FontName', 'Arial', 'FontSize', 20)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  set(gca,'XTick',[])
  text(2,.02, 'Stimulation', 'Color', rgb('Red'), 'FontName', 'Arial', 'FontSize', 12)
  text(2,.019, 'No Stimulation', 'Color',  rgb('Blue'), 'FontName', 'Arial', 'FontSize', 12)
  text(2,.018, 'New', 'Color', rgb('Green'), 'FontName', 'Arial', 'FontSize', 12)
  %set(gca,'XTickLabel',{'Immediate', 'One Day'})
  
  
    
  
  
  subplot(2,4,(rgt-1)*2+1+4), hold on
  tmpxbins = recogtest(rgt).ttype(tt).xbins(recogtest(rgt).ttype(tt).comod(:,1)>0, :);
  tmpxbins = tmpxbins(1,:);%same for all, just use first good patient's
  tmpcomoddiff = ...
    recogtest(rgt).ttype(1).comod(recogtest(rgt).ttype(1).comod(:,1)>0, :)...
    -recogtest(rgt).ttype(2).comod(recogtest(rgt).ttype(2).comod(:,1)>0, :);
  
  error_fill_plot(tmpxbins, mean(tmpcomoddiff), std(tmpcomod)/sqrt(length(tmpcomoddiff(:,1))),'Gray');
  plot([20 100], [0 0], '--r')
  ylim([-.004 .004])
  xlim([20 100])
  ylabel('MI')
  xlabel('Frequency (Hz)')
  title('Stim - No Stim Difference')
  set(gca, 'FontName', 'Arial', 'FontSize', 20)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  
  subplot(2,4,(rgt-1)*2+2+4), hold on
  
  tmp_sg_comod_diff = mean(tmpcomoddiff(:,tmpxbins>=30 & tmpxbins<=55),2);
  
  recogtest(rgt).theta_sg_comod_diff = tmp_sg_comod_diff;%to return
  
  %[~,~,CI,~] = ttest(tmp_sg_comod_diff);
  %CI =  abs(mean(tmp_sg_comod_diff)-CI(1));%95% CI
  
  bar(1,mean(tmp_sg_comod_diff), 1,'FaceColor', [.5 .5 .5])
  errorbar(1,mean(tmp_sg_comod_diff), std(tmp_sg_comod_diff)/sqrt(length(tmp_sg_comod_diff(:,1))), 'k')
  ylim([-.004 .004])
  xlim([.25 1.75])
  ylabel('MI')
  title('Stim - No Stim Difference')
  set(gca, 'FontName', 'Arial', 'FontSize', 20)
  set(gca, 'FontWeight', 'bold')
  set(gca, 'LineWidth', 1)
  set(gca,'XTick',[])
  %set(gca,'XTickLabel',{'Immediate', 'One Day'})
end%test
