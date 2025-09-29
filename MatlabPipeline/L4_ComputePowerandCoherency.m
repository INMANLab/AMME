%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

%################################ Add Required Toolboxes
ChronuX_path = "D:\Toolboxes\chronux_2_12";
addpath(genpath(ChronuX_path));

%################################ load patient Structure
load(RD+"PatientStructL3_Fixed");

%% Parameters
%################################ Script Control Parameters
phaseToProcess = 3;%[1,3];

%################################ Timing Parameters
% offset to exclude the image onset. It can be zero
parTime.postStimOffset = 1/10; % 1/10th sec after image onset
parTime.preStimOffset = 1/10; % 1/10th sec before image onset

parTime.stimOnset = 5; % In seconds before stimilus onset
parTime.postStimDuration = .5; % how many seconds of each trial to use after image onset
parTime.preStimDuration = .5; % how many seconds of each trial to use before image onset as baseline

Fs = 400; % Assuming that all participants has been resampled 

%---------> Compute indeces
postStimOffset = round(parTime.postStimOffset *Fs); 
preStimOffset = round(parTime.preStimOffset * Fs);
stimOnset = round(parTime.stimOnset * Fs);
postStimDuration = round(parTime.postStimDuration * Fs);
preStimDuration = round(parTime.preStimDuration * Fs);
 
parTime.startIdxPost = stimOnset+postStimOffset;
parTime.endIdxPost = stimOnset+postStimOffset+postStimDuration;

parTime.startIdxPre = stimOnset-preStimOffset-preStimDuration;
parTime.endIdxPre = stimOnset-preStimOffset;
%################################ Power and Coherency parameters
multitaperPar.Fs = Fs; % Assuming that all participants has been resampled 
multitaperPar.tapers = [3, 5;...
                        5, 9]; % Use different taper pareameters for the thesta range <=15hz vs gamma range >15hz
multitaperPar.Fpass = [1, 15;...
                       15.01, 100];

multitaperPar.pVal = 1e-7;
multitaperPar.pad = 1;
multitaperPar.err = [2, 0.05];
multitaperPar.trialave = 0;

%################################ Region Parameters
regionNames = ["CA";...  % "ipsi CA fields"
               "DG";...  % "ipsi DG"
               "PHG";... % "ipsi PHG"
               "BLA";... % "ipsi BLA"
               "HPC";... % "all ipsi hippocampus"
               "EC";...  % "all ipsi EC"
               "PRC";... % "all ipsi PRC"
               "PNAS_CA";... % CA region analyzed in the PNAS paper
               "PNAS_DG";... % DG region analyzed in the PNAS paper
               "PNAS_PRC";... % PRC region analyzed in the PNAS paper
               "PNAS_BLA"];  % BLA region analyzed in the PNAS paper

includeRegions = [true;... % "ipsi CA fields"
                  true;... % "ipsi DG"
                  true;... % "ipsi PHG"
                  true;... % "ipsi BLA"
                  true;... % "all ipsi hippocampus"
                  true;... % "all ipsi EC"
                  true;... % "all ipsi PRC"
                  true;... % CA region analyzed in the PNAS paper
                  true;... % DG region analyzed in the PNAS paper
                  true;... % PRC region analyzed in the PNAS paper
                  true];   % BLA region analyzed in the PNAS paper
%% Compute Trial Level Power and Coherency 
for pIdx = 1:length(patient)
    disp("Working on patient: "+string(patient(pIdx).name)+" "+pIdx+"/"+length(patient))
    for phIdx = phaseToProcess
        % Extract EEG data
        regionInfo = patient(pIdx).phase(phIdx).ipsi_region;

        availableRegions = ~cellfun(@isempty,{regionInfo.name}');
        availableRegions = availableRegions & includeRegions(1:length(availableRegions));

        % availableRegionIdx = find(1-availableRegionIdx); % Ignore regions with no data
        % availableLFPs = cellfun(@length,{patient(pIdx).phase(phIdx).ipsi_region.lfpIdx});
        % availableLFPs = availableLFPs(availableRegionIdx); % Ignore regions with no data

        % Create 3dMatrix of the EEG data (samples x trials x channels)
        % stored for different regions
        eegDat = cell(length(regionInfo),1);
        for rgIdx = 1:length(eegDat)
            if(isempty(regionInfo(rgIdx).name))
                continue
            end
            eegDat{rgIdx} = ReturnEEGArray(patient(pIdx).phase(phIdx).trial, rgIdx); 
        end

        % % -------------------- Compute Power and Coherency
        results = ComputePowerandCoherencyMultiTaper(eegDat(availableRegions), regionNames(availableRegions),...
                                                         regionInfo(availableRegions), parTime, multitaperPar);

        % -------------------- Compute Measures: Power, PACs, Standard,
        % FoooF
        % Feautures, and HOSA
        % results = ComputeTrialLevelMeasures(eegDat(availableRegions), regionNames(availableRegions),...
        %                                                  regionInfo(availableRegions), parTime, multitaperPar);
        % -> Compute the Phase of Theta and Gamma at the stimulation(Brain)
        % onset

        patient(pIdx).phase(phIdx).Results = results;

    end
end

%% Remove the trial Data
for pIdx = 1:length(patient)
    disp("Working on patient: "+string(patient(pIdx).name)+" "+pIdx+"/"+length(patient))
    for phIdx = phaseToProcess
        tempDat = patient(pIdx).phase(phIdx).trial;
        if(isstruct(tempDat))
            tempDat = struct2table(tempDat);
        end
        tempDat = removevars(tempDat,"region");
        patient(pIdx).phase(phIdx).trial = tempDat;
    end
end
%% Save the data
save(WR+"PatientStructL4_Day2Only_JoeChannels.mat","patient","-v7.3");
