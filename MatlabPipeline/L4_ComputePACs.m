%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "C:\Users\Alireza\Box\InmanLab\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\BLAES\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\BLAES\MatlabPipeline\";

%################################ Add Required Toolboxes
% eeglab_path = "D:\Toolboxes\eeglab";
% addpath(genpath(eeglab_path));

%################################ load patient Structure

% load(RD+"PatientStructL3");
load(RD+"PatientStructL3");
%% Parameters
%################################ Script Control Parameters
phaseToProcess = [1,3];
patientsToProcess = 1:length(patient);

%################################ Timing Parameters
% offset to exclude the image onset. It can be zero
parTime.postImageOffset = 1/10; % 1/10th sec after image onset
parTime.preImageOffset = 1/10; % 1/10th sec before image onset
parTime.postStimOffset = 1/10; % 1/10th sec after Stimulation ends

parTime.imageOnset = 5; % In seconds before Image onset
parTime.postImageDuration = .5; % how many seconds of each trial to use after image onset
parTime.preImageDuration = .5; % how many seconds of each trial to use before image onset as baseline

parTime.stimulationEnd = parTime.imageOnset + 3 + 1 ; % In seconds after Stimulation Ends
parTime.postStimDuration = .5; % how many seconds of each trial to use after Stimulation Ends

Fs = 500; % Assuming that all participants has been resampled 

%---------> Compute indeces
postImageOffset = round(parTime.postImageOffset *Fs); 
preImageOffset = round(parTime.preImageOffset * Fs);
postStimOffset = round(parTime.postStimOffset * Fs);

imageOnset = round(parTime.imageOnset * Fs);
stimulationEnd = round(parTime.stimulationEnd * Fs);
postImageDuration = round(parTime.postImageDuration * Fs);
preImageDuration = round(parTime.preImageDuration * Fs);
postStimDuration = round(parTime.postStimDuration * Fs);
 
parTime.startIdxPost = imageOnset+postImageOffset;
parTime.endIdxPost = imageOnset+postImageOffset+postImageDuration;

parTime.startIdxPre = imageOnset-preImageOffset-preImageDuration;
parTime.endIdxPre = imageOnset-preImageOffset;

parTime.startIdxPostStim = stimulationEnd+postStimOffset;
parTime.endIdxPostStim = stimulationEnd+postStimOffset+postStimDuration;

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
for pIdx = patientsToProcess
    disp("Working on patient: "+string(patient(pIdx).name)+" "+pIdx+"/"+length(patient))
    for phIdx = phaseToProcess
        % Extract EEG data
        regionInfo = patient(pIdx).phase(phIdx).ipsi_region;

        availableRegions = ~cellfun(@isempty,{regionInfo.name}');
        availableRegions = availableRegions & includeRegions(1:length(availableRegions));

        % Create 3dMatrix of the EEG data (samples x trials x channels)
        % stored for different regions
        eegDat = cell(length(regionInfo),1);
        for rgIdx = 1:length(eegDat)
            if(isempty(regionInfo(rgIdx).name))
                continue
            end
            eegDat{rgIdx} = ReturnEEGArray(patient(pIdx).phase(phIdx).trial, rgIdx); 
        end
        %% ------------------- Compute PAC
        results = ComputePACs_Theta_Gamma(eegDat, regionNames,regionInfo, parTime, Fs);


        %%

        patient(pIdx).phase(phIdx).Results = results;

    end
end

%% Remove the trial Data
for pIdx = patientsToProcess
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
save(WR+"PatientStructL4_PAC"+".mat","patient","-v7.3");
