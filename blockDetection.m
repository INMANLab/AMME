function [pks, pk_locs] = blockDetection(lfp, fs, block_thresh, block_start, block_end)

[pks, pk_locs] = findpeaks(lfp, 'MinPeakDistance', (10*fs), 'MinPeakHeight', block_thresh);
pk_locs = pk_locs / fs;
[~,start_pks] = min(abs(pk_locs - block_start));
[~,end_pks] = min(abs(pk_locs - block_end));

pk_locs = pk_locs(start_pks:end_pks);
end