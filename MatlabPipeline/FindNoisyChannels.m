%% Initialization
clear;
clc;
close all;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";

%---------------- Add Required Toolboxes
ChronuX_path = "D:\Toolboxes\chronux_2_12";
addpath(genpath(ChronuX_path));

%################################ Important Note
% All the channel indeces has to be based on the EDF file
%% Stim Code Mapping

%% Parameters
%-------- load patient Structure
load(RD+"PatientStructL2");
%################################ Script Control Parameters
removeChannelsFlag = true; %Whether All specified channels being excluded from Median or not
fileNameTag = "MartinaChannels";

phaseToProcess = [1,3];
patientsToProcess = 1:length(patient);%[1,4,6,8,11]; %


figure
set(gcf,'position',[500,100,1300,1000])
%% Load the EEG, Preprocess and Analyze
for pIdx = patientsToProcess
    disp("Working on patient: "+string(patient(pIdx).name))
    patientPath = RDD+string(patient(pIdx).name);
    for phIdx = phaseToProcess
        disp("Preprocessing Phase: "+phIdx)

        %% -------------> Load EEG
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
        clear dat; %---------------> To save memory
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
        
        %%
        parPrep.ReReference.chIdx = chIdx;


        dat = datArray(:,chIdx);
        chNamesAll = patient(pIdx).phase(phIdx).chNamesAll;
        chNamesAll = chNamesAll(chIdx);

%% Filter Signal
        fRes = 500;
        t = (1:(size(dat, 1)))/Fs;
        datF = resample(dat, t, fRes, "pchip");
        

        [n,fo,mo,w] = remezord([.5 1.5 200 201], [0 1 0], [1 1 1]*0.01, fRes);
		b = firpm(n,fo,mo,w);
		a=1;
		%------------- Apply the filter
		datF = filtfilt(b,a, datF);
        
        medVal = median(datF,2);
        meanVal = mean(datF,2);
        datFMed = datF-medVal;
        datFMean = datF-meanVal;
%% Save plots
        for i=1:length(chNamesAll)
            clf

            subplot 411
            hold on
            xline(60,'k--','Alpha',0.3)
            pwelch(dat(:,i),[],[],0:.1:150,Fs)            
            % xlim([0,130])
            title("Raw  | "+chNamesAll(i))

            subplot 412
            hold on
            xline(60,'k--','Alpha',0.3)
            pwelch(datF(:,i),[],[],0:.1:150,fRes)                       
            title("BP_Filtered 1-200  | "+chNamesAll(i))

            subplot 413
            hold on
            xline(60,'k--','Alpha',0.3)
            pwelch(datFMed(:,i),[],[],0:.1:150,fRes)            
            title("Median Removed  | "+chNamesAll(i))

            subplot 414
            hold on
            xline(60,'k--','Alpha',0.3)
            pwelch(datFMean(:,i),[],[],0:.1:150,fRes)              
            title("Mean Removed  | "+chNamesAll(i))
            saveas(gcf,RD+"Images\"+string(patient(pIdx).name)+"_phase"+phIdx+"_ch_"+chNamesAll(i)+"_chIdx"+i+".png")
        end
    
    end
end



