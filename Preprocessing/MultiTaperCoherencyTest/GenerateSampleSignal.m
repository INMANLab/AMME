function [data,wave_freqs] = GenerateSampleSignal(n_epochs, n_channels, n_times, sfreq)

t = (0:n_times-1) / sfreq;
data = zeros(n_epochs,n_channels,n_times);
for i = 1:n_epochs
    % Introduce random phase for each channel
    phase = rand(1,n_channels) * pi;
    for c = 1:n_channels
        wave_freqs = linspace(2, 40, 5);
        x = zeros(1, n_times);
        for fSine = wave_freqs
            % Introduce random component to amplitude
            [b, a] = butter(5, (sfreq/5) / (sfreq / 2), "low");
            amp = filter(b, a, rand(1, n_times)*2-1);
            % Generate group of sines
            x = x + sin(2 * pi * fSine * t + phase(c)) + amp;
        end
        data(i, c, :) = x / length(wave_freqs);
    end
end

end