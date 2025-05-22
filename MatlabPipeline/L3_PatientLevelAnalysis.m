%% Initilization
clear;
clc;
WD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

% save the current path
cPath = pwd;
cd(WD) %change the working directory
load(WR+"PatientStructL2");     
%% set the parameters
% pipeline parameters
removeChannelsFlag = true;

% preprocessing filtering parameters
params.fpass=[1 120]; % band of frequencies to be kept
params.tapers=[1 1]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave=1;
movingwin = [.5 .05];
fcut

%% Load the EEG, Preprocess and Analyze
pList = string(vertcat(patient.name));

for pIdx = 1:length(pList)
    disp("Working on patient: "+string(patient(pIdx).name))
    for phaseIdx = [1,3]
        dat = edfread(WD+string(patient(pIdx).name)+string(filesep)+patient(pIdx).phase(phaseIdx).edfFile);

        %---------------------------------------------------> Preprocessing
        if(removeChannelsFlag)
            EEGdat = dat(patient(pIdx).removeChannelsIdx{phaseIdx})
        end
        medlfp = median(dat)

        lfp = lfp-medlfp;
        lfp = rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
        lfp = rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad




        for regionIdx = 1:length(patient(pIdx).ipsi_region)
            
        end
    end
    
end


        