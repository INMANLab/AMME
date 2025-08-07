clear;
clc
load("PatientStructNoEEG.mat")
% addpath("mtit")
% addpath('chronux_2_12')
%% Original Group
LoadLFPintoPatientStruct_Original
plotfirst5patients(patient) 
% save("PatientStructwithEEG_Original","patient");

%% Duration Group

LoadLFPintoPatientStruct_Duration
% save("PatientStructwithEEG_Duration","patient");

%% Timing Group
% patient = patientTemp;
LoadLFPintoPatientStruct_Timing;
% save("PatientStructwithEEG_Timing","patient");

%%
save("PatientStructwithEEG","patient","-v7.3");
