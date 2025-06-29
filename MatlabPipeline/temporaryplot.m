channelPlot = 3;
subplot 211
hold on
tPlot = (0:1/parameters.Fs:5);
plot(tPlot, dat(1:length(tPlot),channelPlot)-mean(dat(1:length(tPlot),channelPlot)));
subplot 212
hold on
pwelch(dat(:,channelPlot)-mean(dat(:,channelPlot)),[],[],[],parameters.Fs)
xlim([0,120])



%%
dat1 = resample(dat, t, FsRes, "pchip");
dat2 = resample(dat, t, FsRes);

channelPlot = 3;
figure
subplot 311
hold on
tPlot = (0:1/Fs:5);
plot(tPlot, dat(1:length(tPlot),channelPlot));
tPlot = (0:1/FsRes:5);
plot(tPlot, dat1(1:length(tPlot),channelPlot));
tPlot = (0:1/FsRes:5);
plot(tPlot, dat2(1:length(tPlot),channelPlot));

subplot 312
hold on
pwelch(dat(:,channelPlot),[],[],[],Fs)
pwelch(dat1(:,channelPlot),[],[],[],FsRes)
pwelch(dat2(:,channelPlot),[],[],[],FsRes)
xlim([0,120])

subplot 313
hold on
params.tapers = [3 5]; % taper parameters
movingwin = [0.5, .05];
params.Fs = Fs;
[Sc1,fc1] = mtspectrumsegc(dat(:,channelPlot),movingwin(1),params);
params.Fs = FsRes;
[Sc2,fc2] = mtspectrumsegc(dat1(:,channelPlot),movingwin(1),params);
[Sc3,fc3] = mtspectrumsegc(dat2(:,channelPlot),movingwin(1),params);
plot(fc1,10*log10(Sc1),fc2,10*log10(Sc2),fc3,10*log10(Sc3));
xlim([0,120])