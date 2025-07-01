%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

%% Parameters
%-------- load patient Structure
load(WR+"PatientStructL3");

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
regionNames = ["CA";... % "ipsi CA fields"
               "DG";... % "ipsi DG"
               "PHG";... % "ipsi PHG"
               "BLA";... % "ipsi BLA"
               "HPC";... % "all ipsi hippocampus"
               "EC";...  % "all ipsi EC"
               "PRC"];  % "all ipsi PRC"
includeRegions = [true;... % "ipsi CA fields"
                  true;... % "ipsi DG"
                  true;... % "ipsi PHG"
                  true;... % "ipsi BLA"
                  true;... % "all ipsi hippocampus"
                  true;...  % "all ipsi EC"
                  true];  % "all ipsi PRC"
%% Compute Trial Level Power and Coherency 
pList = string(vertcat(patient.name));

for pIdx = 19:length(pList)
    disp("Working on patient: "+string(patient(pIdx).name)+" "+pIdx+"/"+length(pList))
    for phIdx = [1,3]
%        %% Data Table
        datRes = struct2table(patient(pIdx).phase(phIdx).trial);
 %       %% Extract EEG data
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

   %     %% Compute Power and Coherency
        results = ComputePowerandCoherencyMultiTaper(eegDat(availableRegions), regionNames(availableRegions),...
                                                         regionInfo(availableRegions), parTime, multitaperPar);
        patient(pIdx).phase(phIdx).Results = results;


        % df = 2*(length(temphiplfpdata(tt).lfp(:,1)))*params.tapers(2);%degrees of freedom = 2 * #trials * #tapers
        % C = atanh(C)-(1/(df-2));%Fisher-transformed and bias corrected
        % %first LFP spectra/power (Hippocampus)
        % S1 = 10*(log10(S1)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
        % %second LFP spectra/power (BLA)
        % S2 = 10*(log10(S2)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
        % %pre-trial basline
        % preC = atanh(preC)-(1/(df-2));%Fisher-transformed and bias corrected
        % preS1 = 10*(log10(preS1)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
        % preS2 = 10*(log10(preS2)-psi(df/2)+log(df/2));%log transformed and bias corrected and X10 bel-->decibel
        % tempmeanC = mean(C,2);
        % diffC = C - preC;

    end
end
%% Save the data
save(WR+"PatientStructL4","patient","-v7.3");
