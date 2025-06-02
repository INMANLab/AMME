clear all; close all; 
clc;
%% Add path to wherever eeglab is downloaded before running script
addpath 'D:\Data\AMME_Data_Emory\AMME_Data\eeglab2024.0';
eeglab nogui;
%% Change directory location as needed
uof = {'uniformoutput',0};
d = dir("D:\Data\AMME_Data_Emory\AMME_Data\amyg*\*Day2.edf");
sids = cellfun( @(n) n(1:end), {d.name}', uof{:} );
nsubj = numel(sids);
which_subs = 1:4; %% for testing, use 1:4; for all, use 1:nsubj
d = d(which_subs);
sids = sids(which_subs);
%% define params
samprate = 499.70714;
lowcut = 1;
highcut = 248;
[n, fo, mo, w] = remezord([lowcut-1 lowcut highcut highcut+1], [0 1 0], [1 1 1]*0.01, samprate);
b = remez(n, fo, mo, w);
a = 1;
%% define notch params and create filters for harmonics
nfreqs = [60, 120, 180, 240];  % remove/change these to specify harmonics
nbw = 2;
nfilters = cell(length(nfreqs), 1);

for i = 1:length(nfreqs)
    f0 = nfreqs(i);
    nfilters{i} = designfilt('bandstopiir', ...
        'FilterOrder', 2, ...
        'HalfPowerFrequency1', f0-nbw/2, ...
        'HalfPowerFrequency2', f0+nbw/2, ...
        'SampleRate', samprate);
end

% filter loop
for si = 1:length(sids)
    sid = sids{si};
    disp(['processing ' sid]);

    parts = regexp(sid, 'amyg(\d+)_.*_([Dd]ay\d+).*\.edf', 'tokens');
    if isempty(parts) || length(parts{1}) < 2
        disp(['Skipping ' sid ', parsing failed.']);
        continue;
    end

    subj = parts{1}{1};
    stimReg = parts{1}{1};  % change for each stim location
    day = parts{1}{2};
    filePath = fullfile('D:\Data\AMME_Data_Emory\AMME_Data', ['amyg' subj], sid);
    fileDir = fileparts(filePath);

    try
        EEG = pop_biosig(filePath);
    catch ME
        disp(['Error processing ' sid ': ' getReport(ME)]);
        continue;
    end

    alllfps = EEG.data;
    hdr = EEG.chanlocs;
    hdr_filename = fullfile(fileDir, sprintf('%s_day%s_hdr.mat', stimReg, day));
    save(hdr_filename, 'hdr');

    % loop chans and apply filters
    for ch = 2:129
        templfp = alllfps(ch, :);

        % notch filt
        for nf = 1:length(nfilters)
            templfp = filtfilt(nfilters{nf}, templfp);
        end

        % bp filt
        lfp = filtfilt(b, a, templfp); 
        fn = fullfile(fileDir, sprintf('%s_day%s_lfp_%03d.mat', stimReg, day, ch-1));
        save(fn, 'lfp');
        clear templfp;
        clear lfp;
    end
    clear alllfps;
    clear hdr;
end