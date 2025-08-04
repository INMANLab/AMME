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
movingwin = [1 .5];

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
        chNamesFixed = patient(pIdx).phase(phaseIdx).chNamesAll;
        nameFixIdx = startsWith(chNamesFixed,digitsPattern);
        chNamesFixed(nameFixIdx) = "x"+chNamesFixed(nameFixIdx);
        datArray = ConvertTimetable2Array(dat,chNamesFixed);
        
        %---------------------------------------------------> Preprocessing
        
        % ----------- Remove Undesired Channels
        chIdx = true(1,size(datArray,2));
        if(removeChannelsFlag)
            chIdx(patient(pIdx).phase(phaseIdx).removeChannels.chIdx)=false;
        else
            chIdx(patient(pIdx).phase(phaseIdx).extraChannels.chIdx)=false; % ---> Index in the lfp sync file name
        end
        datArray = datArray(:,chIdx);

        % ----------- Re-reference to Median
        % medlfp = median(datArray,2);
        % datArray = datArray-medlfp;
        % Order:         
        %       Resample
        %       Re-ref to Med
        %       Low-Pass
        %       Notch

        % ----------- Re-sample EEG to fixed sampling rate
        t = (0:(size(datArray,1)-1))/Fs;
        datRes = resample(datArray, t ,FsRes);
        patient(pIdx).phase(phaseIdx).samprate = FsRes;

        % figure
        % channelPlot = 10;
        % pwelch(datArray(:,channelPlot),[],[],[],Fs)
        % hold on
        % pwelch(datRes(:,channelPlot),[],[],[],FsRes)
        % xlim([0,50])

        medlfpRes = median(datRes,2);

        datReRef = datRes - medlfpRes;

        % figure
        % hold on
        % plot(t,medlfp)
        % plot((0:(size(datRes,1)-1))/FsRes,medlfpRes)     

        datReRef = datArray;
        params.Fs = patient(pIdx).samprate;
        % ----------- Band-Pass filter
        params.Fs = patient(pIdx).phase(phaseIdx).samprate;

        lowcut = 1;
        highcut = 249;
        % New Remezord Filter in Matlab is called from firpmord Func.
        [n,fo,mo,w] = remezord([lowcut-1 lowcut highcut highcut+1], [0 1 0], [1 1 1]*0.01, params.Fs);
        b = firpm(n,fo,mo,w);
        a=1;

        datReRefF = filtfilt(b,a, datReRef);

        medlfpRes = median(datReRefF,2);
        datReRefF = datReRefF - medlfpRes;

        % pwelch(datReRef(:,10),[],[],[],FsRes)
        % hold on
        % pwelch(datReRefF(:,10),[],[],[],FsRes)
        % hold off
        
        % ---------- Notch Filters
        % datReRefF = rmlinesmovingwinc(datReRefF,[1.5 .5],10, params,.00000001,'n', 60);%remove 60 Hz noise
        % datReRefF = rmlinesmovingwinc(datReRefF,[2 1],10, params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad


        params.tapers = [1 1]; % taper parameters
        channelPlot = 32;
        A0 = datReRefF(:,channelPlot);
        % figure;plot(A0(1:10000))
        A = rmlinesmovingwinc(A0,[1.5 .5],10, params,.00000001,'n', 60);%remove 60 Hz noise
        A = rmlinesmovingwinc(A,[2 1],10, params,.00000001,'n', 42);%remove 42 Hz noise (source?); use [2 1] since not as bad

        
        movingwin = [.5,.05];

        wo = 60/(params.Fs/2);  
        bw = 1/(params.Fs/2);wo/35;
        % [bN60,aN60] = iirnotch(wo,bw);
        [bN60,aN60] = designNotchPeakIIR(Response="notch",FilterOrder=20,CenterFrequency=wo,Bandwidth=bw);
        wo = 42/(params.Fs/2);  
        bw = 1/(params.Fs/2);wo/35;
        % [bN42,aN42] = iirnotch(wo,bw);
        [bN42,aN42] = designNotchPeakIIR(Response="notch",FilterOrder=20,CenterFrequency=wo,Bandwidth=bw);

        B = filtfilt(bN60,aN60, datReRefF(:,channelPlot));
        B = filtfilt(bN42,aN42, B);

        % [S,f] = mtspectrumsegc(datReRef(:,channelPlot),movingwin(1),params);
        [Sc1,fc1] = mtspectrumsegc(datReRefF(:,channelPlot),movingwin(1),params);
        [Sc2,fc2] = mtspectrumsegc(A,movingwin(1),params);
        [Sc3,fc3] = mtspectrumsegc(B,movingwin(1),params);
        figure
        % plot(f,10*log10(S),fc1,10*log10(Sc1),fc2,10*log10(Sc2),fc3,10*log10(Sc3));
        % legend("Raw","Band-Passed","MT","Notch")
        plot(fc1,10*log10(Sc1),fc2,10*log10(Sc2),fc3,10*log10(Sc3));
        legend("Band-Passed","MT","Notch")

        figure
        pwelch(datReRef(:,channelPlot),[],[],[],FsRes)
        hold on
        pwelch(datReRefF(:,channelPlot),[],[],[],FsRes)
        pwelch(A,[],[],[],FsRes)
        pwelch(B,[],[],[],FsRes)
        legend("Raw","Band-Passed","MT","Notch")

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


        