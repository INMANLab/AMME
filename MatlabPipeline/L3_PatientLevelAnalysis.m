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
parameters.preprocessStepOrder = ["Resample","Rerefrence","Bandpass","Bandstop"];

%-------------------------------- Bandpass
parameters.Bandpass.FcLow = .6;
parameters.Bandpass.FcHigh = 448;
parameters.Bandpass.rippleStop = 0.005;
parameters.Bandpass.ripplePass = 0.005;

%-------------------------------- Resample
parameters.Resample.FsRes = 500;
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
        dat0 = datArray;

        parameters.preprocessStepOrder = ["Bandpass","Resample", "Rerefrence", "Bandstop"];
        parameters.Fs = Fs; 

        datF = PreprocesRoutine(datArray, parameters);


        parameters.preprocessStepOrder = ["Bandpass", "Rerefrence", "Bandstop","Resample"];

        datF2 = PreprocesRoutine(dat0, parameters);
        
        % patient(pIdx).phase(phaseIdx).samprate = FsRes;

        Fs1 = 500;
        Fs2 = 500;
        channelPlot = 28;
        clf
        subplot 311
        hold on
        t = (0:1/Fs:10);
        plot(t, dat0(1:length(t),channelPlot)-mean(dat0(1:length(t),channelPlot)));
        t = (0:1/Fs1:10);
        plot(t, datF(1:length(t),channelPlot));
        t = (0:1/Fs2:10);
        plot(t, datF2(1:length(t),channelPlot));
        legend("dat0","dat1","dat2")

        params.fpass = [1 120]; % band of frequencies to be kept
        params.tapers = [1 1]; % taper parameters
        params.pad = 1; % It should be based on the sampling frequency for each patient
        params.err = [2 0.05];
        params.trialave = 1;
        movingwin = [.5 .05];

        params.Fs = Fs;
        [Sc1,fc1] = mtspectrumsegc(dat0(:,channelPlot)-mean(dat0(:,channelPlot)),movingwin(1),params);
        params.Fs = Fs1;
        [Sc2,fc2] = mtspectrumsegc(datF(:,channelPlot),movingwin(1),params);
        params.Fs = Fs2;
        [Sc3,fc3] = mtspectrumsegc(datF2(:,channelPlot),movingwin(1),params);
        subplot 312
        plot(fc1,10*log10(Sc1),fc2,10*log10(Sc2),fc3,10*log10(Sc3));
        legend("dat0","dat1","dat2")

        subplot 313
        hold on
        pwelch(dat0(:,channelPlot)-mean(dat0(:,channelPlot)),[],[],[],Fs)
        pwelch(datF(:,channelPlot),[],[],[],Fs1)
        pwelch(datF2(:,channelPlot),[],[],[],Fs2)
        xlim([0,120])
        legend("dat0","dat1","dat2")

    end
    
end


        