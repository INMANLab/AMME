%% Initialization
clear;
clc;
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%% Parameters
%-------- load patient Structure
load(WR+"PatientStructL2");


%------------------------- preprocessing pipeline parameters
removeChannelsFlag = true;

% preprocessing filtering parameters
params.fpass = [1 120]; % band of frequencies to be kept
params.tapers = [1 1]; % taper parameters
params.pad = 1; % It should be based on the sampling frequency for each patient
params.err = [2 0.05];
params.trialave = 1;
movingwin = [.5 .05];


%% Load the EEG, Preprocess and Analyze
pList = string(vertcat(patient.name));

for pIdx = 1:length(pList)
    disp("Working on patient: "+string(patient(pIdx).name))
    patientPath = RDD+string(patient(pIdx).name);
    for phaseIdx = [1,3]
        disp("Preprocessing Phase: "+phaseIdx)

        dat = edfread(patientPath+string(filesep)+patient(pIdx).phase(phaseIdx).edfFile);
        datArray = convertTimetable2Array(dat,patient(pIdx).phase(phaseIdx).chNamesAll);

        params.Fs=patient(p).samprate;

        lowcut = 1;
        highcut = 248;
        [n,fo,mo,w] = remezord([lowcut-1 lowcut highcut highcut+1], [0 1 0], [1 1 1]*0.01, samprate);
        
        %---------------------------------------------------> Preprocessing
        if(removeChannelsFlag)
            EEGdat = dat(patient(pIdx).removeChannelsIdx{phaseIdx});
        end
        medlfp = median(dat);

        lfp = lfp-medlfp;
        lfp = rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
        lfp = rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad




        for regionIdx = 1:length(patient(pIdx).ipsi_region)
            
        end
    end
    
end


        