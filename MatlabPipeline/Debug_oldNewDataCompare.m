patientOld = load("D:\Individuals\Alireza\Data\Amme\Poster\PatientStructwithEEG_OriginalChannels.mat");
patientOld = patientOld.patient;
patientNoShort = load("D:\Individuals\Alireza\Data\Amme\MatlabPipeline\PatientStructL3_bak.mat");
patient = patientNoShort.patient;
%%
pIdx = 6;
phaseIdx = 3;
trialIdx = 1;
rgIdxOld = 3;
rgIdxNew = 7;

disp("Old")
patientOld(pIdx).name   
struct2table(patientOld(pIdx).ipsi_region)
disp("New")
patientOld(pIdx).name 
struct2table(patient(pIdx).ipsi_region)
struct2table(patient(pIdx).phase(3).ipsi_region)

%%
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