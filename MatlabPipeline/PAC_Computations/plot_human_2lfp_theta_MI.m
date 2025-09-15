function  [xbins, Comodulogram] = plot_human_2lfp_theta_MI(lfp1,lfp2, samprate, color, showplot)
%[xbins, Comodulogram] = plot_2lfp_theta_MI(lfp1,lfp2, color, showplot)
%lfp1 = Phase lfp
%lfp2 = Amplitude lfp
%showplot: 1 = plot (default); 2 = no plot
%e.g., CA1 theta phase(lfp1) modulating CA3 gamma amplitude (lfp2)
%Original from Adriano Tort
%modified by JRM 11/28/12
%updated for human lfp 10/20/16 JRM
%this version assumes that you have filtered lfp1 for theta already

if nargin < 4, showplot = 1; end

% Define the Amplitude- and Phase- Frequencies
%PhaseFreqVector=5:2:50;%only one range: theta
AmpFreqVector=20:5:170;
%PhaseFreq_BandWidth=4;
AmpFreq_BandWidth=20;



if( length(lfp1(1,:)) ~= length(lfp2(1,:))   || length(lfp1(:,1)) ~= length(lfp2(:,1)) )
  error('lfp1 and lfp2 data must be of same size')
end

data_length = length(lfp1(1,:));

Comodulogram=single(zeros(1,length(AmpFreqVector)));
Comodulogram_ctr=single(zeros(1, length(AmpFreqVector)));

% For comodulation calculation (only has to be calculated once)
nbin = 18;
position=zeros(1,nbin); % this variable will get the beginning (not the center) of each phase bin (in rads)
winsize = 2*pi/nbin;
for j=1:nbin
  position(j) = -pi+(j-1)*winsize;
end

for trial = 1:length(lfp1(:,1))
  %fprintf('Working on trial %d\n', trial)
  % Do filtering and Hilbert transform
  AmpFreqTransformed = zeros(length(AmpFreqVector), data_length);
  
  
  for ii=1:length(AmpFreqVector)
    Af1 = AmpFreqVector(ii);
    Af2=Af1+AmpFreq_BandWidth;
    AmpFreq=eegfilt(lfp2(trial,:),samprate,Af1,Af2); % just filtering
    AmpFreqTransformed(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
  end
  
  
  %PhaseFreq=eegfilt(lfp1(trial,:),samprate,5,7); % filtering in theta range
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  CHANGED BY JRM TO ASSUME lfp1 IS ALREADY FILTERED %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  PhaseFreq = lfp1(trial,:);%so just copy 
  PhaseFreqTransformed = angle(hilbert(PhaseFreq)); % this is getting the phase time series

  
  
  % Do comodulation calculation
 
    
    counter2=0;
    for jj=1:length(AmpFreqVector)
      counter2=counter2+1;
      
      Af1 = AmpFreqVector(jj);
      Af2 = Af1+AmpFreq_BandWidth;
      [MI,MeanAmp]=ModIndex_v2(PhaseFreqTransformed', AmpFreqTransformed(jj, :), position);
      Comodulogram(counter2)=Comodulogram(counter2)+MI;
      Comodulogram_ctr(counter2)=Comodulogram_ctr(counter2)+1;
    end

end%end of trial loop

Comodulogram = Comodulogram ./ Comodulogram_ctr; %get average across trials

% Graph comodulogram
%contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram',30,'lines','none')
xbins = AmpFreqVector+AmpFreq_BandWidth/2;
if(showplot)
  plot(xbins,Comodulogram, color)
end








