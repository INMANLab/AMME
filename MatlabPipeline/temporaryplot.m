channelPlot = 3;
subplot 211
hold on
tPlot = (0:1/parameters.Fs:10);
plot(tPlot, dat(1:length(tPlot),channelPlot)-mean(dat(1:length(tPlot),channelPlot)));
subplot 212
hold on
pwelch(dat(:,channelPlot)-mean(dat(:,channelPlot)),[],[],[],parameters.Fs)
xlim([0,120])