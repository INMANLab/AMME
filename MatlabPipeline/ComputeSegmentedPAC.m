function Comodulogram = ComputeSegmentedPAC(lfp1,lfp2)

% lfp1 -> Phase
% lfp2 -> Amplitude
% lfps = Samples x Trials



if( length(lfp1(1,:)) ~= length(lfp2{1}(1,:))   || length(lfp1(:,1)) ~= length(lfp2{1}(:,1)) )
  error('lfp1 and lfp2 data must be of same size')
end

data_length = size(lfp1,1);
LAmps = length(lfp2);
trialNum  = size(lfp1,2);

Comodulogram = zeros(trialNum,LAmps);

% For comodulation calculation (only has to be calculated once)
nbin = 18;
position=zeros(1,nbin); % this variable will get the beginning (not the center) of each phase bin (in rads)
winsize = 2*pi/nbin;
for j=1:nbin
  position(j) = -pi+(j-1)*winsize;
end

for trial = 1:trialNum
  %fprintf('Working on trial %d\n', trial)
  % Do filtering and Hilbert transform
  AmpFreqTransformed = zeros(LAmps, data_length);
  
  
  for ampIdx=1:LAmps
    % Af1 = AmpFreqVector(ii);
    % Af2=Af1+AmpFreq_BandWidth;
    % AmpFreq=eegfilt(lfp2(trial,:),samprate,Af1,Af2); % just filtering
    % [n,fo,mo,w] = remezord([Af1-1 Af1 Af2 Af2+1], [0 1 0], [1 1 1]*0.01, samprate);
    % b = remez(n,fo,mo,w);a=1;
    
    % sig = lfp2(trial,:);
    % [sigPadded,idx] = PaddwithReversed(sig);

    % AmpFreq=eegfilt(sig,samprate,Af1,Af2);
    % figure;
    % hold on
    % pwelch(lfp2(trial,:),[],[],1:.5:100,samprate)
    % pwelch(AmpFreq,[],[],1:.1:100,samprate)
    % figure;
    % hold on
    % plot(lfp2(trial,:))
    % plot(AmpFreq)
    % 
    % 
    % sigPadded=eegfilt(sigPadded,samprate,Af1,Af2);
    % AmpFreq = sigPadded(idx);
    % figure;
    % hold on
    % pwelch(lfp2(trial,:),[],[],1:.5:100,samprate)
    % pwelch(AmpFreq,[],[],1:.1:100,samprate)
    % figure;
    % hold on
    % plot(lfp2(trial,:))
    % plot(AmpFreq)
    % 
    % 
    % sigPadded = filtfilt(b,a,sigPadded);
    % AmpFreq = sigPadded(idx);

    % AmpFreq = filtfilt(b,a,lfp2(trial,:));
    AmpFreq = lfp2{ampIdx}(:,trial)';
    AmpFreqTransformed(ampIdx, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
  end
  
  
  %PhaseFreq=eegfilt(lfp1(trial,:),samprate,5,7); % filtering in theta range
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %  CHANGED BY JRM TO ASSUME lfp1 IS ALREADY FILTERED %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  PhaseFreq = lfp1(:,trial)';

  PhaseFreqTransformed = angle(hilbert(PhaseFreq)); % this is getting the phase time series

  % Do comodulation calculation
    for ampIdx=1:LAmps
      
      % Af1 = AmpFreqVector(jj);
      % Af2 = Af1+AmpFreq_BandWidth;
      [MI,~] = ModIndex_v2(PhaseFreqTransformed', AmpFreqTransformed(ampIdx, :), position);
      Comodulogram(trial,ampIdx) = MI;
    end

end%end of trial loop

