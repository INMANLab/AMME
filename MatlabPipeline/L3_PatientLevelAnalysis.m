%% Initialization
clear;
clc;
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%% Parameters
%-------- load patient Structure
load(WR+"PatientStructL2");


%################################ preprocessing parameters
removeChannelsFlag = true;
parameters.Fs = []; % fill it with each patients data

%-------------------------------- Order of doing the preprocess steps
parameters.preprocessStepOrder = ["Bandpass","Bandstop","Rerefrence","Resample"];

%-------------------------------- Bandpass
parameters.Bandpass.FcLow = .6;
parameters.Bandpass.FcHigh = 250;
parameters.Bandpass.rippleStop = 0.005;
parameters.Bandpass.ripplePass = 0.005;

%-------------------------------- Resample
parameters.Resample.FsRes = 500;
parameters.Resample.Method = "pchip"; %Shape-preserving piecewise cubic interpolation is better than linear
%-------------------------------- Bandstop
parameters.BandStop.tapers = [1, 1; 1, 1];
parameters.BandStop.Fpass = [1, 115; 1, 115];
parameters.BandStop.movingwin = [1.5, .5; 2, 1];
parameters.BandStop.Fc = [60; 42];
parameters.BandStop.tau = [10; 10];
parameters.BandStop.pVal = [1e-7; 1e-7];
parameters.BandStop.pad = [1; 1];
parameters.BandStop.err = [2, 0.05; 2, 0.05];
parameters.BandStop.trialave = [0; 0];


%% Load the EEG, Preprocess and Analyze
pList = string(vertcat(patient.name));

for pIdx = 1:length(pList)
    disp("Working on patient: "+string(patient(pIdx).name))
    patientPath = RDD+string(patient(pIdx).name);
    for phaseIdx = [1,3]
        disp("Preprocessing Phase: "+phaseIdx)

        dat = edfread(patientPath+string(filesep)+patient(pIdx).phase(phaseIdx).edfFile);
        info = edfinfo(patientPath+string(filesep)+patient(pIdx).phase(phaseIdx).edfFile);
        Fs = unique(info.NumSamples/seconds(info.DataRecordDuration));
        patient(pIdx).phase(phaseIdx).samprateEDF = Fs;
        if(length(Fs)>1)
            warning("for patient: "+patient(pIdx).name+", phase: "+...
                    phaseIdx+", there descrepent sampling rates: "+Fs)
        end
        chNamesFixed = patient(pIdx).phase(phaseIdx).chNamesAll;
        nameFixIdx = startsWith(chNamesFixed,digitsPattern);
        chNamesFixed(nameFixIdx) = "x"+chNamesFixed(nameFixIdx);
        datArray = ConvertTimetable2Array(dat,chNamesFixed);
        
        % ----------- Remove Undesired Channels
        chIdx = true(1,size(datArray,2));
        if(removeChannelsFlag)
            chIdx(patient(pIdx).phase(phaseIdx).removeChannels.chIdx)=false;
        else
            chIdx(patient(pIdx).phase(phaseIdx).extraChannels.chIdx)=false; % ---> Index in the lfp sync file name
        end
        datArray = datArray(:,chIdx);

        %---------------------------------------------------> Preprocessing
        parameters.Fs = Fs; 
        datF = PreprocesRoutine(datArray, parameters);
        patient(pIdx).phase(phaseIdx).samprate = parameters.Resample.FsRes;

    end
    
end


        