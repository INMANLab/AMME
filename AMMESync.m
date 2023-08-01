% AMMESync detects sync pulses in the LFP data. The user identifies a clear
% trial sync pulse, and loads in the appropriate .log file with experiment
% sync times. The script determines the LFP times for all other sync
% pulses, and exports those values along with the corresponding sync plot.
%
% Inputs:
%   pID (str): patient ID (e.g., 'amyg020')
%   test_phase (str): specify which phase of the task (e.g., 'study', 'day2')
%   save_sync (bool): export the LFP sync times (i.e., true, false)
%   save_fig (bool): export the figure as a .fig file (i.e., true, false)
%
% Justin Campbell & Krista Wahlstrom
% justin.campbell@hsc.utah.edu
% 06/12/2023

%% Clear workspace
clear all; close all; clc;

%% Specify inputs
pID = 'amyg030';            % MANUALLY DEFINE
test_phase = 'study';       % MANUALLY DEFINE
fs = 1023.999;              % MANUALLY DEFINE
sync_thresh = 8000;         % MANUALLY DEFINE
minIPI = 10; % in seconds; ~10s for study, _s for immediate
sep_blocks = 0; % default = 0, 1 = separate start/end/threshold for each block

save_sync = true;
save_fig = true;

lfp_path = strcat('\\rolstonserver\D\Data\AMME_Data_Emory\AMME_Data\', pID);
cd(lfp_path);

%% Select & Load LFP File

[lfp_file, lfp_path] = uigetfile(strcat('\\rolstonserver\D\Data\AMME_Data_Emory\AMME_Data\', pID),'Select the sync channel (LFP.mat file)'); 

load(strcat(lfp_path,lfp_file));
tVec = [1:length(lfp)];
tVec = tVec / fs;

%% Interact w/ Raw Data to ID Sync Pulse

% visualize raw data from sync channel
figure(1);
plot(tVec, lfp, 'k');
title(pID);
xlabel('Time (s)')
ylabel('Voltage (uV)')

% instructions for selection of sync pulse
clc;
disp('Depending on the phase of the task (study, immediate test, day 2 test), zoom into the appropriate section of the plot. Select the known sync pulse.');
input('Hit enter when done selecting sync trial.')

% request user input
prompt = {'Enter known trial #:','Enter trial x-value (sec; all decimal points):'};
dlgtitle = 'Sync Trial Info';
dims = [1 70];
definput = {'',''};
answer = inputdlg(prompt,dlgtitle,dims,definput);

% save user input
trial_no = str2num(answer{1});
LFP_trialtime = str2num(answer{2});
close all;

%% Use GetSecs times for sync alignment

vars = whos;
uiimport;
clc;
disp('Select all "GetSecs" times for the appropriate phase of the task (study, immediate test, day 2 test)');
input('Hit enter when done importing GetSecs times.')
vars2 = whos;
all_get_secs = setdiff({vars2.name}, {vars.name});
all_get_secs = eval(all_get_secs{1});
all_get_secs = all_get_secs{:,1};
trial_get_secs = all_get_secs(trial_no);
pad_time = trial_get_secs - LFP_trialtime;
LFP_trialtimes = all_get_secs - pad_time;
LFP_trialtimes = LFP_trialtimes';

%% Peak detection

% Initial find peaks
study_start = LFP_trialtimes(1);
study_end = LFP_trialtimes(end);

[pks, pk_locs] = findpeaks(lfp, 'MinPeakDistance', (minIPI*fs), 'MinPeakHeight', sync_thresh);
pk_locs = pk_locs / fs;
[~,start_pks] = min(abs(pk_locs - study_start));
[~,end_pks] = min(abs(pk_locs - study_end));

pk_locs = pk_locs(start_pks:end_pks);

% Search blocks separately
if sep_blocks == 1
    figure(1);
    plot(tVec, lfp, 'k')
    hold on
    xline(LFP_trialtimes, '-r')
    xline(pk_locs, '--c')
    title(pID);
    xlabel('Time (s)')
    ylabel('Voltage (uV)')
    xlim([study_start - 5, study_end + 5])
    clc;
    input('Hit enter when done separating blocks.')
    
    block_thresholds = [1000, 1000, 1000, 1000];            % MANUALLY DEFINE
    block_starts = [LFP_trialtimes(1), 1550, 2230, 3500];   % MANUALLY DEFINE
    block_ends = [1440, 2100, 2720, LFP_trialtimes(end)];   % MANUALLY DEFINE
    
    pk_locs = [];
    for i = 1:length(block_thresholds)
        [~, block_pk_locs] = blockDetection(lfp, fs, block_thresholds(i), block_starts(i), block_ends(i));
        pk_locs = [pk_locs, block_pk_locs];
    end
end

%% Visualize aligned sync pulses

figure(1);
plot(tVec, lfp, 'k')
hold on
xline(LFP_trialtimes, '-r')
xline(pk_locs, '--b')
title(pID);
xlabel('Time (s)')
ylabel('Voltage (uV)')
xlim([study_start - 5, study_end + 5])

clc;
input('Hit enter when done reviewing sync plot.')

%% Alignment check

% Alignment check
answer = questdlg('Do you approve the sync alignment?', ...
	'Alignment Check', ...
	'Approve','Reject', 'Reject');
% Handle response
switch answer
    case 'Approve'
        export = 1;
    case 'Reject'
        export = 0;
end

%% Export

clc;
fprintf('<strong>%s %s</strong> \n', pID, test_phase);
if export
    if save_sync
        filename = strcat(lfp_path, pID, '_', test_phase, '_GetSecsTrialTimes');
        save(filename, 'LFP_trialtimes');
        disp('Saved GetSecs trial times!')

        filename = strcat(lfp_path, pID, '_', test_phase, '_FindPkTrialTimes');
        save(filename, 'pk_locs');
        disp('Saved find peaks trial times!')
    end
    if save_fig
        saveas(gcf, strcat(lfp_path, pID, '_', test_phase, '_SyncPlot.fig'));
        disp('Saved Sync Plot!')
    end
else
    disp('Sync rejected. Troubleshoot or document reason for rejection.')
end
close all;
