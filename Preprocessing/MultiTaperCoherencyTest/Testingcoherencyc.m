% Test Function
%% Init
clear
clc
close all
load LIPdata.mat


t = 0:1/1000:1;
plot(t, sin(2*pi*t));
hold on
plot(t, sin(2*pi*10*t));
figure
plot(t, sin(2*pi*t+pi/2));
hold on
plot(t, sin(2*pi*10*t+pi/2));

%%

fmin = 1; 
fmax = 10;
freqs = linspace(1,3, 1024);
n_cycles=2/freqs;

pname='data';
params.Fs = sfreq; % sampling frequency
params.fpass = [1 10]; % band of frequencies to be kept
params.tapers=[]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave=1;
movingwin=[0.5 0.05];


wintrig=[5*movingwin(1) 5*movingwin(1)];
winseg=2*movingwin(1);

%% Data
NT=round(params.Fs*10*movingwin(1));
data=dlfp(1:NT,:);
data1=data(:,1:2);data2=data(:,3:4);
%% Test


[C,phi,S12,S1,S2,f,confC,phierr,Cerr]=coherencyc(data1,data2,params); 
figure;plot(f,C)
figure;plot(f,C,f,Cerr(1,:),f,Cerr(2,:));xlabel('frequency'); ylabel('Coherency');

%%

[C,~,~,S1,S2,f]=coherencyc(temphiplfpdata(tt).lfp',tempblalfpdata(tt).lfp',params);



% compute spectrum of the first few seconds of LFP channels 1-2

data1=data(:,1:2);
[S,f,Serr]=mtspectrumc(data1,params);
figure;
plot(f,10*log10(S),f,10*log10(Serr(1,:)),f,10*log10(Serr(2,:))); xlabel('Frequency Hz'); ylabel('Spectrum');
%%% pause

% compute derivative of the spectrum for the same data
phi=[0 pi/2];
[dS,f]=mtdspectrumc(data1,phi,params);
figure;
plot(f,dS(1,:),f,dS(2,:)); xlabel('frequency Hz'); ylabel('Derivatives'); legend('Time','Frequency');
%%% pause

% compute coherency between  channels 1-2 and  3-4


