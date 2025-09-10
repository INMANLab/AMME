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
% 02/17/2023

%% Clear workspace
clear all; close all; clc;

%% Specify inputs
pID = 'amyg048';            % MANUALLY DEFINE
test_phase = 'study';       % MANUALLY DEFINE
fs = 1024;                  % MANUALLY DEFINE

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
xlabel('Sample')
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

%% Visualize aligned sync pulses

figure(1);
plot(tVec, lfp, 'k')
hold on
xline(LFP_trialtimes, '-r')
title(pID);
xlabel('Time (s)')
ylabel('Voltage (uV)')

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
        filename = strcat(lfp_path, pID, '_', test_phase, '_LFPtrialtimes');
        save(filename, 'LFP_trialtimes');
        disp('Saved LFP trial times!')
    end
    if save_fig
        saveas(gcf, strcat(lfp_path, pID, '_', test_phase, '_SyncPlot.fig'));
        disp('Saved Sync Plot!')
    end
else
    disp('Sync rejected. Troubleshoot or document reason for rejection.')
end
close all;

