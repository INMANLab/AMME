function plot_human_comodulogram(lfp)
%Original from Adriano Tort
%modified by JRM 11/27/12
%updated 10/19/16 by JRM for human data


%% Define the Amplitude- and Phase- Frequencies
PhaseFreqVector=5:2:50;
AmpFreqVector=10:5:200;
PhaseFreq_BandWidth=4;
AmpFreq_BandWidth=10;
samprate = 1500;


data_length = length(lfp(1,:));

Comodulogram=single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
Comodulogram_ctr=single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));

%% For comodulation calculation (only has to be calculated once)
nbin = 18;
position=zeros(1,nbin); % this variable will get the beginning (not the center) of each phase bin (in rads)
winsize = 2*pi/nbin;
for j=1:nbin
  position(j) = -pi+(j-1)*winsize;
end

for trial = 1:length(lfp(:,1))
  fprintf('Working on trial %d\n', trial)
  %% Do filtering and Hilbert transform
  AmpFreqTransformed = zeros(length(AmpFreqVector), data_length);
  PhaseFreqTransformed = zeros(length(PhaseFreqVector), data_length);
  
  for ii=1:length(AmpFreqVector)
    Af1 = AmpFreqVector(ii);
    Af2=Af1+AmpFreq_BandWidth;
    AmpFreq=eegfilt(lfp(trial,:),samprate,Af1,Af2); % just filtering
    AmpFreqTransformed(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
  end
  
  for jj=1:length(PhaseFreqVector)
    Pf1 = PhaseFreqVector(jj);
    Pf2 = Pf1 + PhaseFreq_BandWidth;
    PhaseFreq=eegfilt(lfp(trial,:),samprate,Pf1,Pf2); % this is just filtering
    PhaseFreqTransformed(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
  end
  
  
  %% Do comodulation calculation
  counter1=0;
  for ii=1:length(PhaseFreqVector)
    counter1=counter1+1;
    
    Pf1 = PhaseFreqVector(ii);
    Pf2 = Pf1+PhaseFreq_BandWidth;
    
    counter2=0;
    for jj=1:length(AmpFreqVector)
      counter2=counter2+1;
      
      Af1 = AmpFreqVector(jj);
      Af2 = Af1+AmpFreq_BandWidth;
      [MI,MeanAmp]=ModIndex_v2(PhaseFreqTransformed(ii, :), AmpFreqTransformed(jj, :), position);
      Comodulogram(counter1,counter2)=Comodulogram(counter1,counter2)+MI;
      Comodulogram_ctr(counter1,counter2)=Comodulogram_ctr(counter1,counter2)+1;
    end
  end
end%end of trial loop

Comodulogram = Comodulogram ./ Comodulogram_ctr; %get average across trials

%% Graph comodulogram
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram',30,'lines','none')
set(gca,'fontsize',14)
ylabel('Amplitude Frequency (Hz)')
xlabel('Phase Frequency (Hz)')
colorbar







