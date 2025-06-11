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

% resampling Freq
FsRes = 500;

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
        datArray = convertTimetable2Array(dat,patient(pIdx).phase(phaseIdx).chNamesAll);
        
        %---------------------------------------------------> Preprocessing
        
        % ----------- Remove Undesired Channels
        chIdx = true(1,size(datArray,2));
        if(removeChannelsFlag)
            chIdx(patient(pIdx).phase(phaseIdx).removeChannels.chIdx)=false;
        else
            chIdx(patient(pIdx).phase(phaseIdx).ExtraChannels.chIdx)=false; % ---> Index in the lfp sync file name
        end
        datArray = datArray(:,chIdx);

        % % ----------- Re-reference to Median
        % medlfp = median(datArray,2);
        % 
        % % Order:         
        % %       Resample
        % %       Re-ref to Med
        % %       Low-Pass
        % %       Notch
        % 
        % % ----------- Re-sample EEG to fixed sampling rate
        % t = (0:(size(datArray,1)-1))/Fs;
        % datRes = resample(datArray, t ,FsRes);
        % 
        % figure
        % channelPlot = 10;
        % pwelch(datArray(:,channelPlot),[],[],[],Fs)
        % hold on
        % pwelch(datRes(:,channelPlot),[],[],[],FsRes)
        % xlim([0,50])
        % 
        % medlfpRes = median(datRes,2);
        % 
        % figure
        % hold on
        % plot(t,medlfp)
        % plot((0:(size(datRes,1)-1))/FsRes,medlfpRes)
        % 
        % 
        % patient(pIdx).phase(phaseIdx).samprate = FsRes;
        % 
        % 
        % % ----------- Band-Pass filter
        % params.Fs = patient(pIdx).phase(phaseIdx).samprate;
        % 
        % lowcut = 1;
        % highcut = 250;
        % % New Remezord Filter in Matlab is called from firpmord Func.
        % [n,fo,mo,w] = firpmord([lowcut-1 lowcut highcut highcut+1], [0 1 0], [1 1 1]*0.01, Fs);
        % b = firpm(n,fo,mo,w);
        % a=1;
        % 
        % datArrayF = filtfilt(b,a, datArray);
        % medlfpF = median(datArrayF,2);
        % 
        % pwelch(medlfpF,[],[],[],params.Fs)
        % 
        % 
        % datFRes = resample(datArrayF, t ,FsRes);
        % medlfpFRes = median(datFRes,2);



        
        % figure
        % hold on
        % channelPlot = 10;
        % pwelch(datArrayF(:,channelPlot),[],[],[],Fs)
        % pwelch(datFRes(:,channelPlot),[],[],[],FsRes)
        % xlim([0,50])
        % 
        % figure
        % hold on
        % plot(t,medlfpF)
        % plot((0:(size(datRes,1)-1))/FsRes,medlfpFRes)

        % lfp = lfp-medlfp;
        % lfp = rmlinesmovingwinc(lfp,[1.5 .5],10,params,.00000001,'n', 60);%remove 60 Hz noise
        % lfp = rmlinesmovingwinc(lfp,[2 1],10,params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad
        % 
        % 
        % 
        % 
        % for regionIdx = 1:length(patient(pIdx).ipsi_region)
        % 
        % end
    end
    
end


        