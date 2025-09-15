%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

%---------------- Add Required Toolboxes
ChronuX_path = "D:\Toolboxes\chronux_2_12";
addpath(genpath(ChronuX_path));
%% Parameters
%-------- load patient Structure
load(RD+"PatientStructL2");
%################################ Script Control Parameters
removeChannelsFlag = false; %Whether All specified channels being excluded from Median or not
phaseToProcess = 3;%[1,3];

% Important Note
% All the channel indeces has to be based on the EDF file
%################################ preprocessing parameters
parPrep.Fs = []; % fill it with each patients data

%-------------------------------- Order of doing the preprocess steps
% parPrep.preprocessStepOrder = ["Bandpass","Bandstop","Rerefrence","Resample"];
parPrep.preprocessStepOrder = ["Bandpass","Resample","Rerefrence","Bandstop"];

%-------------------------------- Re-Reference
parPrep.ReReference.chIdx = []; % channels to include in median

%-------------------------------- Bandpass
parPrep.Bandpass.FcLow = 1;
parPrep.Bandpass.FcHigh = 150;
parPrep.Bandpass.rippleStop = 0.01;
parPrep.Bandpass.ripplePass = 0.01;

%-------------------------------- Resample
parPrep.Resample.FsRes = 400;
parPrep.Resample.Method = "pchip"; %Shape-preserving piecewise cubic interpolation is better than linear

%-------------------------------- Bandstop
parPrep.BandStop.tapers = [1, 1; 1, 1];
parPrep.BandStop.Fpass = [1, 115; 1, 115];
parPrep.BandStop.movingwin = [1.5, .5; 2, 1];
parPrep.BandStop.Fc = [60; 42];
parPrep.BandStop.tau = [10; 10];
parPrep.BandStop.pVal = [1e-7; 1e-7];
parPrep.BandStop.pad = [1; 1];
parPrep.BandStop.err = [2, 0.05; 2, 0.05];
parPrep.BandStop.trialave = [0; 0];

%################################ Epoching parameters
parEpoch.preStim = 5; % In seconds before stimilus onset
parEpoch.postStim = 5; % In seconds after stimilus onset

%% Load the EEG, Preprocess and Analyze
for pIdx = 1:length(patient)
    disp("Working on patient: "+string(patient(pIdx).name))
    patientPath = RDD+string(patient(pIdx).name);
    for phIdx = phaseToProcess
        disp("Preprocessing Phase: "+phIdx)

        %% -------------> Load EDF Data
        dat = edfread(patientPath+string(filesep)+patient(pIdx).phase(phIdx).edfFile);
        info = edfinfo(patientPath+string(filesep)+patient(pIdx).phase(phIdx).edfFile);
        Fs = unique(info.NumSamples/seconds(info.DataRecordDuration));
        patient(pIdx).phase(phIdx).samprateEDF = Fs;
        if(length(Fs)>1)
            warning("for patient: "+patient(pIdx).name+", phase: "+...
                phIdx+", there descrepent sampling rates: "+Fs)
        end
        chNamesFixed = patient(pIdx).phase(phIdx).chNamesAll;
        nameFixIdx = startsWith(chNamesFixed,digitsPattern);
        chNamesFixed(nameFixIdx) = "x"+chNamesFixed(nameFixIdx);
        datArray = ConvertTimetable2Array(dat,chNamesFixed);
        %% -------------> Pick required samples
        offsetMargin = 10;% Minutes
        tEnd = round(max(patient(pIdx).phase(phIdx).trial.start_time,[],"omitmissing")*Fs+offsetMargin*60*Fs); %with 5 minutes margin
        tStart = round(min(patient(pIdx).phase(phIdx).trial.start_time,[],"omitmissing")*Fs-offsetMargin*60*Fs); %with 5 minutes margin
        if(tStart<=0)
            tStart = 1;
        end
        if(tEnd>size(datArray,1))
            tEnd=size(datArray,1);
        end
        datArray = datArray(tStart:tEnd,:);
        %% -------------> Find Index of Channels for Median
        chIdx = true(1,size(datArray,2));
        if(removeChannelsFlag)
            chIdx(patient(pIdx).phase(phIdx).removeChannels.chIdx) = false;
        else
            chIdx(patient(pIdx).phase(phIdx).extraChannels.chIdx) = false; % ---> Index in the lfp sync file name
        end
        % patient(pIdx).phase(phIdx).chNamesKept = patient(pIdx).phase(phIdx).chNamesAll(chIdx);
        % datArray = datArray(:,chIdx);
        parPrep.ReReference.chIdx = chIdx;
        patient(pIdx).phase(phIdx).chNamesKept = chIdx;
        %% -------------> Preprocessing
        parPrep.Fs = Fs;
        datArray = PreprocesRoutine(datArray, parPrep);
        patient(pIdx).phase(phIdx).samprate = parPrep.Resample.FsRes;

        % figure
        % subplot 211
        % hold on
        % params.fpass = [1 120]; % band of frequencies to be kept
        % params.tapers = [3 5]; % taper parameters
        % params.pad = 1; % It should be based on the sampling frequency for each patient
        % params.Fs = 400;
        % [Sc1,fc1] = mtspectrumsegc(datArray(:,10),.5,params);
        % plot(fc1,10*log10(Sc1));
        %
        % params.fpass = [1 120]; % band of frequencies to be kept
        % params.tapers = [3 5]; % taper parameters
        % params.pad = 1; % It should be based on the sampling frequency for each patient
        % params.Fs = Fs;
        % [Sc1,fc1] = mtspectrumsegc(datArray(:,10),.5,params);
        % plot(fc1,10*log10(Sc1));
        %
        % subplot 212
        % hold on
        % pwelch(datArray(:,10),[],[],[],400)
        % pwelch(datArray(:,10),[],[],[],Fs)
        %% -------------> Epoching
        Fs = patient(pIdx).phase(phIdx).samprate;
        if(tStart >1)
            tStart = round(min(patient(pIdx).phase(phIdx).trial.start_time,[],"omitmissing")*Fs-offsetMargin*60*Fs);
        end
        for tIdx = 1:size(patient(pIdx).phase(phIdx).trial,1)
            stimIdx = round(patient(pIdx).phase(phIdx).trial.start_time(tIdx)*Fs)-tStart+1;
            if(isnan(stimIdx))
                continue;
            end
            startIdx =  stimIdx-round(Fs * parEpoch.preStim);
            endIdx   =  stimIdx+round(Fs * parEpoch.postStim);
            for rgIdx = 1:length(patient(pIdx).phase(phIdx).ipsi_region)
                lfpTemp = [];
                for chIdx = 1:length(patient(pIdx).phase(phIdx).ipsi_region(rgIdx).lfpIdx)
                    chNum = patient(pIdx).phase(phIdx).ipsi_region(rgIdx).lfpIdx(chIdx);
                    % chIdxInArray = find(strcmp(patient(pIdx).phase(phIdx).chNamesKept,chName));
                    datEpoch = datArray(startIdx:endIdx,chNum);
                    lfpTemp = cat(2,lfpTemp,datEpoch);
                end
                % region(rgIdx).lfp = lfpTemp;
                % patient(pIdx).phase(phIdx).trial.region(tIdx).lfp(rgIdx) = lfpTemp;
                patient(pIdx).phase(phIdx).trial.region(tIdx,rgIdx) = {lfpTemp};
            end
            % patient(pIdx).phase(phIdx).trial.region(tIdx) = {region};
            % clear region;
        end
    end

    %% Saving Each patient
    % To Improve memory performance save each patient data separately and 
    % free-up memory at the end of the script they are being concatenated.
    save(WR+"PatientStructL3_SinglePatient_p"+pIdx,"patient");
    clear patient
    load(RD+"PatientStructL2");
end
%% Load and Combine Separate Patient Data
load(RD+"PatientStructL2");
patientTemp = patient;
for pIdx = 1:length(patient)
    load(WR+"PatientStructL3_SinglePatient_p"+pIdx);
    patientTemp(pIdx) = patient(pIdx);
end
clear patient;
patient = patientTemp;
save(WR+"PatientStructL3_EmptyRemoved","patient","-v7.3");


%% 
% T = table;
% for pIdx = 1:24
%     for phaseIdx = [1,3]
%         tTemp = table;
%         tTemp.pName = patient(pIdx).name;
%         tTemp.Phase = phaseIdx;
%         tTemp.chNames = join(patient(pIdx).phase(phaseIdx).chNamesAll',"', '");
%         T = cat(1,T,tTemp);
%     end
% end
% writetable(T,"emptyChannels.csv")