patientOld = load("D:\Individuals\Alireza\Data\Amme\Poster\PatientStructwithEEG_OriginalChannels.mat");
patientOld = patientOld.patient;
patientNoShort = load("D:\Individuals\Alireza\Data\Amme\MatlabPipeline\PatientStructL3_bak.mat");
patient = patientNoShort.patient;
%%
pIdx = 1;
phaseIdx = 3;
trialIdx = 50;
rgIdxOld = 1;
rgIdxNew = 5;

disp("Old")
struct2table(patientOld(pIdx).ipsi_region)
disp("New")
struct2table(patient(pIdx).ipsi_region)
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
plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)


subplot 313
hold on
plot((1:length(A))/patientOld(pIdx).samprate,A)
plot((1:length(B))/patient(pIdx).phase(phaseIdx).samprate,B)