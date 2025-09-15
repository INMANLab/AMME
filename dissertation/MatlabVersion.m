%% Init
clear
clc
close all

%% Signal Parameters
n_epochs = 1;
n_channels = 2;
t_max = 8; %seconds
sfreq = 100;

n_samples = sfreq * t_max;
t = (0:n_samples-1) / sfreq;
rng(2)
[data,wave_freqs] = GenerateSampleSignal(n_epochs, n_channels, n_samples, sfreq);
dataCh = permute(data,[3,1,2]); %(Epoch/Trials,Channel,Samples) -> (Samples,Epochs/Trials,Channels)
%% Plot Signal
figure
subplot 221
x = squeeze(data(1,1,:));
plot(t, x)
xlabel('Time (S)')
ylabel('Amplitude')
subplot 222
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
hold on
xline(wave_freqs)
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

subplot 223
x = squeeze(data(1,2,:));
plot(t,x)
xlabel('Time (S)')
ylabel('Amplitude')
subplot 224
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
hold on
xline(wave_freqs)
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

%% Compare with Python
load simulated_eeg.mat
figure
subplot 221
x = squeeze(eeg_data(1,1,:));
plot(t, x)
xlabel('Time (S)')
ylabel('Amplitude')
subplot 222
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
hold on
xline(wave_freqs)
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

subplot 223
x = squeeze(eeg_data(1,2,:));
plot(t,x)
xlabel('Time (S)')
ylabel('Amplitude')
subplot 224
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
hold on
xline(wave_freqs)
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

%% Connectivity Parameters
% freqs = np.linspace(1,3, num =1024)
% con_time = spectral_connectivity_time(data_epoch, 
%                                       method="coh",
%                                       mode = 'multitaper',
%                                       mt_bandwidth = 3,
%                                       average = True,
%                                       sfreq=sfreq,
%                                       indices = (np.array([0]),
%                                                  np.array([1])),
%                                       fmin = 1, 
%                                       fmax = 10, 
%                                       freqs=freqs,
%                                       n_cycles=2/freqs)

% freqs = linspace(1,3, 1024);
fmin = 0; 
fmax = 50;
% n_cycles=2/freqs;

%% chronux parameters
fmin = 0; 
fmax = 50;
pname='data';
params.Fs = sfreq; % sampling frequency
params.fpass = [fmin fmax]; % band of frequencies to be kept
params.tapers=[3 15]; % taper parameters
params.pad=-1; % pad factor for fft
params.trialave=1;

%% Compute Connectivity
[C,Phi,S12,S1,S2,f]=coherencyc(dataCh(:,:,1),dataCh(:,:,2),params); 

N = size(dataCh(:,:,1),1);
nfft = 2^nextpow2(N);
Y = fft(dataCh(:,:,1),nfft);
fs = sfreq*(0:nfft/2-1)/nfft;
figure
plot(fs,abs(Y(1:length(fs))))
xlabel("Frequency (Hz)")
ylabel("|FFT|")
length(Y(fs>=fmin & fs<=fmax))
figure
plot(fs(fs>=fmin & fs<=fmax),abs(Y(fs>=fmin & fs<=fmax)))
xlabel("Frequency (Hz)")
ylabel("|FFT|")

N = size(dataCh(:,:,1),1);
tapers = dpsschk([3,5],N,sfreq);
tapers = dpsschk([sfreq/2,N/sfreq,1],N,sfreq);
legend("1","2","3","4","5")
Y = mtfftc(dataCh(:,:,1),tapers,nfft);
fs = sfreq*(0:nfft/2-1)/nfft;
figure
plot(fs,abs(Y(1:length(fs))))
xlabel("Frequency (Hz)")
ylabel("|FFT|")
length(Y(fs>=fmin & fs<=fmax))
figure
plot(fs(fs>=fmin & fs<=fmax),abs(Y(fs>=fmin & fs<=fmax)))
xlabel("Frequency (Hz)")
ylabel("|FFT|")
J=mtfftc(data,tapers,nfft,Fs)
% fs = sfreq*(-nfft/2:nfft/2-1)/nfft;
% plot(fs,abs(fftshift(Y)))
% xlabel("Frequency (Hz)")
% ylabel("|y|")
%% Plot Signals
figure
subplot 421
x = squeeze(dataCh(:,:,1));
plot(t, x)
xlabel('Time (S)')
ylabel('Amplitude')
subplot 422
plot(f,10*log10(S1))
hold on
xline(wave_freqs(wave_freqs<=fmax))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

subplot 423
x = squeeze(dataCh(:,:,2));
plot(t,x)
xlabel('Time (S)')
ylabel('Amplitude')
subplot 424
plot(f,10*log10(S2))
hold on
xline(wave_freqs(wave_freqs<=fmax))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

subplot 413
plot(f,C)
xlabel('frequency'); 
ylabel('Coherency');

subplot 414
plot(f,10*log10(abs(S12)))
hold on
xline(wave_freqs(wave_freqs<=fmax))
xlabel('frequency'); 
ylabel('cross PSD');