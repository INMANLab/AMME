clc
clear
close all

n_epochs = 1;
n_channels = 2;
n_times = 200;
sfreq = 100;
t = (0:n_times-1) / sfreq;

rng(2); % Set random seed
% data = rand(n_epochs, n_channels, n_times);

for i = 1:n_epochs
    for c = 1:n_channels
        wave_freqs = linspace(2, 40, 5);
        % Introduce random phase for each channel
        phase = rand(1) * 2 * pi;
        x = zeros(1, n_times);
        for fSine = wave_freqs
            % Introduce random component to amplitude
            [b, a] = butter(5, (sfreq/5) / (sfreq / 2), "low");
            amp = filter(b, a, rand(1, n_times)*2-1);
            % Generate group of sines
            x = x + sin(2 * pi * fSine * t + phase / (4*fSine)) + amp;
        end
        data(i, c, :) = x / length(wave_freqs);
    end
end

subplot 221
x = squeeze(data(1,1,:));
plot(t, x)
subplot 222
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
subplot 223
x = squeeze(data(1,2,:));
plot(t,x)
subplot 224
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')


load simulated_eeg.mat
figure
subplot 221
x = squeeze(eeg_data(1,1,:));
plot(t, x)
subplot 222
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
subplot 223
x = squeeze(eeg_data(1,2,:));
plot(t,x)
subplot 224
[pxx,f]=pwelch(x,[],[],[],sfreq);
plot(f,10*log10(pxx))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
