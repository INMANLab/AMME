%% Initialization
clear;
clc;
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%---------------- Add Required Toolboxes

ChronuX_path = "D:\Toolboxes\chronux_2_12";
addpath(genpath(ChronuX_path));
%% Parameters
%-------- load patient Structure
load(WR+"PatientStructL2");

%################################ preprocessing parameters
removeChannelsFlag = true;
parPrep.Fs = []; % fill it with each patients data

%-------------------------------- Order of doing the preprocess steps
parPrep.preprocessStepOrder = ["Bandpass","Bandstop","Rerefrence","Resample"];

%-------------------------------- Re-Reference
parPrep.ReReference.chIdx = []; % channels to include in median

%-------------------------------- Bandpass
parPrep.Bandpass.FcLow = 1;
parPrep.Bandpass.FcHigh = 200;
parPrep.Bandpass.rippleStop = 0.01;
parPrep.Bandpass.ripplePass = 0.01;

%-------------------------------- Resample
parPrep.Resample.FsRes = 400;
parPrep.Resample.Method = "pchip"; %Shape-preserving piecewise cubic interpolation is better than linear

%-------------------------------- Bandstop
parPrep.BandStop.tapers = [1, 1; 1, 1];
parPrep.BandStop.Fpass = [1, 115; 1, 115];
parPrep.BandStop.movingwin = [1.5, .5; 2, 1];
parPrep.BandStop.Fc = [42; 60];
parPrep.BandStop.tau = [10; 10];
parPrep.BandStop.pVal = [1e-7; 1e-7];
parPrep.BandStop.pad = [1; 1];
parPrep.BandStop.err = [2, 0.05; 2, 0.05];
parPrep.BandStop.trialave = [0; 0];

%################################ Epoching parameters
parEpoch.preStim = 5; % In seconds before stim
parEpoch.postStim = 5; % In seconds after stim

%################################ Epoching parameters
% tempindex = round(patient(p).phase(ph).trial(t).start_time*patient(p).samprate);
% tmplfp = lfp(tempindex-sampsbefore:tempindex+sampsafter-1);
% origsecsbefore = 5;%how many seconds worth of data saved in patient structure prior to image onset
% secstouse = .5;%how many seconds of each trial to use
% origsampsbefore = round(patient(p).samprate * origsecsbefore);
% 
% startind = origsampsbefore+round(patient(p).samprate/10);%1/10th sec after image onset
% stopind =  origsampsbefore+round(patient(p).samprate/10) +round(patient(p).samprate * secstouse);%after image onset, total = secstouse secs plus 100 ms
% prestartind = origsampsbefore-round(patient(p).samprate/10)-round(patient(p).samprate * secstouse);%secstouse plus 100 ms before image onset
% prestopind =  origsampsbefore-round(patient(p).samprate/10);%1/10th sec before image onset

%% Load the EEG, Preprocess and Analyze
pList = string(vertcat(patient.name));

for pIdx = 1:8 %1:length(pList)
    disp("Working on patient: "+string(patient(pIdx).name))
    patientPath = RDD+string(patient(pIdx).name);
    for phIdx = [1,3]
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

        %% -------------> Preprocessing
        parPrep.Fs = Fs; 
        datArray = PreprocesRoutine(datArray, parPrep);
        patient(pIdx).phase(phIdx).samprate = parPrep.Resample.FsRes;
        
        %% -------------> Epoching
        Fs = patient(pIdx).phase(phIdx).samprate;
        
        for tIdx = 1:length(patient(pIdx).phase(phIdx).trial)
            stimIdx = round(patient(pIdx).phase(phIdx).trial(tIdx).start_time*Fs);
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
                patient(pIdx).phase(phIdx).trial(tIdx).region(rgIdx).lfp = lfpTemp;
            end
        end

    end
    save(WR+"PatientStructL3_1upto"+pIdx,"patient");
end
%% Save the data
% patient1 = patient;
% save(WR+"PatientStructL3_1","patient1");


        