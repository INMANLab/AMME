

% Fs = 999.4121;
t = 0:1/Fs:100;
y = chirp(t,0,10,250);
% y = repmat(y,1,10);
% pspectrum(y,Fs,"spectrogram",TimeResolution=0.1, ...
%     OverlapPercent=50,Leakage=0.85)
plot(y)

lowCut = parameters.Bandpass.FcLow;
highCut = parameters.Bandpass.FcHigh;
rS = parameters.Bandpass.rippleStop;
rP = parameters.Bandpass.ripplePass;

[n,fo,mo,w] = firpmord([lowCut-.5 lowCut highCut highCut+.5], [0 1 0], [.001 rP .001], Fs);

bR = firpm(n,fo,mo,w);
aR=1;
freqz(bR,aR,2048,Fs)
%%
%------------- Apply the filter
figure
yF = filtfilt(bR,aR, y);

clf
subplot 411
hold on
plot(t, y);
plot(t,yF)

subplot 412
pspectrum(y,Fs,"spectrogram",TimeResolution=0.1, ...
    OverlapPercent=50,Leakage=0.85)
pspectrum(yF,Fs,"spectrogram",TimeResolution=0.1, ...
    OverlapPercent=50,Leakage=0.85)

subplot 413
hold on
pwelch(y,[],[],[],Fs)
pwelch(yF,[],[],[],Fs)
xlim([0,120])


params.fpass = [1 120]; % band of frequencies to be kept
params.tapers = [1 1]; % taper parameters
params.pad = 1; % It should be based on the sampling frequency for each patient
params.err = [2 0.05];
params.trialave = 1;
movingwin = [.5 .05];
params.Fs = Fs;
[Sc1,fc1] = mtspectrumsegc(y,movingwin(1),params);
params.Fs = Fs;
[Sc2,fc2] = mtspectrumsegc(yF,movingwin(1),params);
subplot 414
plot(fc1,10*log10(Sc1),fc2,10*log10(Sc2));
legend("dat0","dat1")