patientOld = load("D:\Individuals\Alireza\Data\Amme\Poster\PatientStructwithEEG_OriginalChannels.mat");
patientOld = patientOld.patient;
% patientNoShort = load("D:\Individuals\Alireza\Data\Amme\MatlabPipeline\PatientStructL3_EmptyRemoved.mat");PatientStructL3_SinglePatient_p1
patientNoShort = load("D:\Individuals\Alireza\Data\Amme\MatlabPipeline\PatientStructL3OnlyPNAS.mat");
patient = patientNoShort.patient;
%%
pIdx = 1;
phaseIdx = 3;
trialIdx = 1;

disp("Old")
patientOld(pIdx).name   
struct2table(patientOld(pIdx).ipsi_region)
disp("New")
patientOld(pIdx).name 
struct2table(patient(pIdx).ipsi_region)
struct2table(patient(pIdx).phase(3).ipsi_region)

rgIdxOld = 3;
rgIdxNew = 10;
%%
figure
A = patientOld(pIdx).phase(phaseIdx).trial(trialIdx).region(rgIdxOld).lfp;
patientOld(pIdx).ipsi_region(rgIdxOld)

B = patient(pIdx).phase(phaseIdx).trial.region{trialIdx,rgIdxNew};
patient(pIdx).ipsi_region(rgIdxNew)

subplot 211
hold on
pwelch(A,[],[],[],patientOld(pIdx).samprate)
pwelch(B,[],[],[],patient(pIdx).phase(phaseIdx).samprate)


subplot 212
hold on
plot((1:length(A))/patientOld(pIdx).samprate,A)
plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)

%% Visualize Average power

trialType = "stim";
yesno = "yes";
A = struct2table(patientOld(pIdx).phase(phaseIdx).trial);
A = A(A.trial_type == trialType & A.yes_or_no == yesno,:);
A = horzcat(A.region(:,rgIdxOld).lfp);

origsecsbefore = 5;%how many seconds worth of data saved in patient structure prior to image onset
secstouse = .5;%how many seconds of each trial to use
origsampsbefore = round(patientOld(pIdx).samprate * origsecsbefore);   
startind = origsampsbefore+round(patientOld(pIdx).samprate/10);%1/10th sec after image onset
stopind =  origsampsbefore+round(patientOld(pIdx).samprate/10) +round(patientOld(pIdx).samprate * secstouse);
A = A(startind:stopind,:);

B = patient(pIdx).phase(phaseIdx).trial;
B = B(B.trial_type == trialType & B.yes_or_no == yesno,:);
B = horzcat(B.region{:,rgIdxNew});
origsecsbefore = 5;%how many seconds worth of data saved in patient structure prior to image onset
secstouse = .5;%how many seconds of each trial to use
origsampsbefore = round(patient(pIdx).phase(phaseIdx).samprate * origsecsbefore);   
startind = origsampsbefore+round(patient(pIdx).phase(phaseIdx).samprate/10);%1/10th sec after image onset
stopind =  origsampsbefore+round(patient(pIdx).phase(phaseIdx).samprate/10) +round(patient(pIdx).phase(phaseIdx).samprate * secstouse);
B = B(startind:stopind,:);


patient(pIdx).ipsi_region(rgIdxNew)
params.fpass=[1 100]; % band of frequencies to be kept
params.tapers=[5 9]; % taper parameters
params.pad=1; % pad factor for fft
params.err=[2 0.05];
params.trialave = 0;

% figure
% subplot 211
% hold on
% [pa,fa] = pwelch(A,[],[],1:100,patientOld(pIdx).samprate);
% [pb,fb] = pwelch(B,[],[],1:100,patient(pIdx).phase(phaseIdx).samprate);
% plot(fa,mean(10*log10(pa),2))
% plot(fb,mean(10*log10(pb),2))
% 
% subplot 212
figure
params.tapers = [3 5];
[pa,fa] = pwelch(A,300,150,1:100,patientOld(pIdx).samprate);
params.tapers=[5 9]; % taper parameters
[pa2,fa2] = pwelch(A,300,150,1:100,patientOld(pIdx).samprate);
pa(fa>=15,:) = pa2(fa2>=15,:);

params.tapers = [3 5];
[pb,fb] = pwelch(B,[],[],1:100,patient(pIdx).phase(phaseIdx).samprate);
params.tapers=[5 9]; % taper parameters
[pb2,fb2] = pwelch(B,[],[],1:100,patient(pIdx).phase(phaseIdx).samprate);
pb(fb>=15,:) = pb2(fb2>=15,:);


params.Fs = patientOld(pIdx).samprate;
params.tapers = [3 5];
[S,f] = mtspectrumc(A,params);
params.tapers=[5 9]; % taper parameters
[S2,f2] = mtspectrumc(A,params);
S(f>=15,:) = S2(f2>=15,:);

params.Fs = patient(pIdx).phase(phaseIdx).samprate;
params.tapers = [3 5];
[Sc,fc] = mtspectrumc(B,params);
params.tapers=[5 9]; % taper parameters
[Sc2,fc2] = mtspectrumc(B,params);
Sc(fc>=15,:) = Sc2(fc2>=15,:);
plot(f,mean(10*log10(S),2),fc,mean(10*log10(Sc),2));
legend("old","new")

%%
figure
subplot 311
A = patientOld(pIdx).phase(phaseIdx).trial(trialIdx).region(rgIdxOld).lfp;
patientOld(pIdx).ipsi_region(rgIdxOld)
plot((1:length(A))/patientOld(pIdx).samprate,A)
% 
% subplot 312
% B = patient(pIdx).phase(phaseIdx).trial(trialIdx).region(rgIdxNew).lfp;
% patient(pIdx).ipsi_region(rgIdxNew)
% plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)
% 
% subplot 313
% hold on
% plot((1:length(A))/patientOld(pIdx).samprate,A)
% plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)

subplot 312
B = patient(pIdx).phase(phaseIdx).trial.region{trialIdx,rgIdxNew};
patient(pIdx).ipsi_region(rgIdxNew)
% plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)

hold on
pwelch(A,[],[],[],patientOld(pIdx).samprate)
pwelch(B,[],[],[],patient(pIdx).phase(phaseIdx).samprate)


subplot 313
hold on
plot((1:length(A))/patientOld(pIdx).samprate,A)
plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)

%% List of Channels
pInclude = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
A = struct2table(patient);
A = A(ismember(A.name,pInclude),:);
for pIdx = 1:length(pInclude)
    i=1;
    for rgIdx = [1,3,4]
        A.rg(pIdx,i) = "_"+string(A.region(pIdx,rgIdx).lfpnum);
        i=i+1;
    end
end
A = A(:,["name","rg"]);

%%
pInclude = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
A = struct2table(patient);
A = A(ismember(A.name,pInclude),:);
for pIdx = 1:length(pInclude)
    i=1;
    for rgIdx = [1,3,4]
        temp = "";
        for tI = 1:length(A.ipsi_region(pIdx,rgIdx).lfpnum)
            temp = temp+"_"+string(A.ipsi_region(pIdx,rgIdx).lfpnum(tI));
        end
        A.rg(pIdx,i) = temp;
        i=i+1;
    end
end
A = A(:,["name","rg"]);

%% 
pInclude = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
A = struct2table(patient);
A = A(ismember(A.name,pInclude),:);
for pIdx = 1:length(pInclude)
    i=1;
    for rgIdx = [8,10,11]
        temp = "";
        for tI = 1:length(A.ipsi_region(pIdx,rgIdx).lfpnum)
            temp = temp+"_"+string(A.ipsi_region(pIdx,rgIdx).lfpnum(tI));
        end
        A.rg(pIdx,i) = temp;
        i=i+1;
    end
end
A = A(:,["name","rg"]);