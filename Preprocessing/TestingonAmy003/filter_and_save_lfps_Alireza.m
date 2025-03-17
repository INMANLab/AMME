%% Initialization:


%%

samprate = 500;params.Fs;%based on EDFbrowser and feedback from EMU director (via Cory) to use this rather than 500 

%Let's minimally filter to get rid of what looks like low frequency motion artifact (and DC offset)
lowcut = params.fpass(1);
highcut = params.fpass(2)-1;
%get parameters for filtering
[n,fo,mo,w] = remezord([lowcut-1 lowcut highcut highcut+1], [0 1 0], [1 1 1]*0.01, samprate);
b = remez(n,fo,mo,w);
a=1;

wo = 60/(500/2);  
bw = wo/(floor(params.Fs));
[bN60,aN60] = iirnotch(wo,bw);

wo = 42/(500/2);  
bw = wo/floor(params.Fs);
[bN42,aN42] = iirnotch(wo,bw);

% wo = 120/(500/2);  
% bw = wo/35;
% [bN120,aN120] = iirnotch(wo,bw);
% filterAnalyzer(b,a)



%%%%%%%%PATIENT 003%%%%%%%%%%%
% cd \HUMAN_STIM_DATA
% cd amyg003  

alllfps= edfread(rdDir+"amyg003_objectMemory_day1_05mA.edf");
info= edfinfo(rdDir+"amyg003_objectMemory_day1_05mA.edf");
info.SignalLabels
fs = info.NumSamples/seconds(info.DataRecordDuration);
T = vertcat(alllfps.L1d1{:});


fprintf('Working on amyg003:\n')
%%%day 1%%%

for ch = 2:129
    templfp = alllfps(:,ch);
    timeSeries = vertcat(templfp.(1){:});
  % templfp = alllfps(:,ch);
  % T = timetable2table(templfp);
  % T = T(:,2);
  % timeSeries = [];
  % for i=1:height(T)
  %     timeSeries = cat(1,timeSeries,T.(T.Properties.VariableNames{1}){i});
  % end
  fn = sprintf('day1_lfp_%03d.mat', ch-1); % use channel - 1 since first channel is event channel
  fprintf('\tFiltering and saving %s\n', fn)
  timeSeries = decimate(timeSeries*1e-6,round(params.Fs/500));
  %filters signal in eeg with McClellan-Parks FIR filter
  lfp = filtfilt(bN60,aN60, timeSeries');
  lfp = filtfilt(bN42,aN42, lfp);
  lfp = filtfilt(bN120,aN120, lfp);
  lfp = filtfilt(b,a, lfp);
  % save(fn, 'lfp');
  clear templfp;
  clear lfp;
end
clear alllfps
clear hdr

%% Decimated lfp day 1
lfp_Signal = load(rdDir+"day1_lfp_001.mat").lfp;
t = 0:1/params.Fs:length(lfp_Signal)/params.Fs-1/params.Fs;

tDecim = 0:1/500:length(lfp)/500-1/500;

pyData = load(rdDir+"python_data_day1.mat").data;
tPy = 0:1/500:length(pyData(1,:))/500-1/500;


figure
tMax = 10;
subplot(4,2,1)
plot(t(t<tMax),lfp_Signal(t<tMax)*1e-6)
title("S1: Joe's Saved LFP")
subplot(4,2,2)
pwelch(lfp_Signal(t<50)*1e-6,[],[],[],params.Fs)
xlim([0,250])
subplot(4,2,3)
plot(tDecim(tDecim<tMax),lfp(tDecim<tMax))
title("S2: Rerun of Joe's Code but resampled to 500hz")
subplot(4,2,4)
pwelch(lfp(tDecim<tMax),[],[],[],500)
subplot(4,2,5)
plot(tPy(tPy<tMax),pyData(1,(tPy<tMax)))
title("S3: Martina's Python Code")
subplot(4,2,6)
pwelch(pyData(1,(tPy<tMax)),[],[],[],500)
subplot(4,1,4)
plot(t(t<tMax),lfp_Signal(t<tMax)*1e-6)
hold on
plot(tDecim(tDecim<tMax),lfp(tDecim<tMax))
plot(tPy(tPy<tMax),pyData(1,(tPy<tMax)))
title("all together")
legend("S1","S2","S3")



%% Day 2
%%%day 2%%%

alllfps= edfread(rdDir+"amyg003_objectMemory_day2_05mA.edf");
info= edfinfo(rdDir+"amyg003_objectMemory_day2_05mA.edf");
info.SignalLabels
fs = info.NumSamples/seconds(info.DataRecordDuration);
T = vertcat(alllfps.L1d1{:});

%% temporary test for raw signals in mat and edf file.
ch32EDF = vertcat(alllfps.L15d3{:});
ch32EDF = ch32EDF - mean(ch32EDF);
ch32EDF = ch32EDF/std(ch32EDF);

ch33EDF = vertcat(alllfps.L15d4{:});
ch33EDF = ch33EDF - mean(ch33EDF);
ch31EDF = vertcat(alllfps.L15d2{:});
ch31EDF = ch31EDF - mean(ch31EDF);

ch32rawMatFile = load(rdDir+"day2_lfp_032.mat");
ch32rawMatFile = ch32rawMatFile.lfp;
ch32rawMatFile = ch32rawMatFile - mean(ch32rawMatFile);
ch32rawMatFile = ch32rawMatFile/std(ch32rawMatFile);

pythonDat = load(rdDir+"Raw.mat");
pythonDat = pythonDat.eeg_data;
ch32Python = pythonDat(33,:);
ch32Python = ch32Python-mean(ch32Python);
ch32Python = ch32Python/std(ch32Python);

figure
plot(ch31EDF)
hold on
plot(ch32EDF)
plot(ch33EDF)
plot(ch32rawMatFile)
legend("31","32","33","32MatFile")

figure
plot(ch32Python*1e6)
hold on
plot(ch32EDF)
plot(ch32rawMatFile)
legend("32Python","32EDF","32MatFile")


%%
for ch = 2:129
    templfp = alllfps(:,ch);
    timeSeries = vertcat(templfp.(1){:});
    fn = sprintf('day2_lfp_%03d.mat', ch-1); % use channel - 1 since first channel is event channel
    fprintf('\tFiltering and saving %s\n', fn)
    %filters signal in eeg with McClellan-Parks FIR filter
    timeSeries = decimate(timeSeries*1e-6,round(params.Fs/500));
    lfp = filtfilt(bN60,aN60, timeSeries');
    lfp = filtfilt(bN42,aN42, lfp);
    lfp = filtfilt(bN120,aN120, lfp);
    lfp = filtfilt(b,a, lfp);
    % save(fn, 'lfp');
    clear templfp;
    clear lfp;
end
clear alllfps;
clear hdr;

%%  Comparing with Python Day2
lfp_Signal = load(rdDir+"day2_lfp_001.mat").lfp;
t = 0:1/params.Fs:length(lfp_Signal)/params.Fs-1/params.Fs;

pyData = load(rdDir+"python_data_day2.mat").data;
tPy = 0:1/500:length(pyData(1,:))/500-1/500;


figure
tMax = 50;
subplot(3,1,1)
plot(t(t<tMax),lfp_Signal(t<50)*1e-6)
subplot(3,1,2)
plot(tPy(tPy<tMax),pyData(1,(tPy<tMax)))
subplot(3,1,3)
plot(t(t<tMax),lfp_Signal(t<50)*1e-6)
hold on
plot(tPy(tPy<tMax),pyData(1,(tPy<tMax)))
legend("Joe's","Python")

%% Decimated lfp day 2
lfp_Signal = load(rdDir+"day2_lfp_001.mat").lfp;
t = 0:1/params.Fs:length(lfp_Signal)/params.Fs-1/params.Fs;


tDecim = 0:1/500:length(lfp)/500-1/500;

pyData = load(rdDir+"python_data_day2.mat").data;
tPy = 0:1/500:length(pyData(1,:))/500-1/500;


figure
tMax = 10;
subplot(4,2,1)
plot(t(t<tMax),lfp_Signal(t<tMax)*1e-6)
title("S1: Joe's Saved LFP")
subplot(4,2,2)
pwelch(lfp_Signal(t<50)*1e-6,[],[],[],params.Fs)
% xlim([0,250])
subplot(4,2,3)
plot(tDecim(tDecim<tMax),lfp(tDecim<tMax))
title("S2: Rerun of Joe's Code but resampled to 500hz")
subplot(4,2,4)
pwelch(lfp(tDecim<tMax),[],[],[],500)
subplot(4,2,5)
plot(tPy(tPy<tMax),pyData(1,(tPy<tMax)))
title("S3: Martina's Python Code")
subplot(4,2,6)
pwelch(pyData(1,(tPy<tMax)),[],[],[],500)
subplot(4,1,4)
plot(t(t<tMax),lfp_Signal(t<tMax)*1e-6)
hold on
plot(tDecim(tDecim<tMax),lfp(tDecim<tMax))
plot(tPy(tPy<tMax),pyData(1,(tPy<tMax)))
title("all together")
legend("S1","S2","S3")
