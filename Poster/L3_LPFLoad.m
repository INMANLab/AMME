clear;
clc
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\Poster\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\Poster\";
%% Load Data
load(RD+"PatientStructwithEEG_OriginalChannels.mat")
% load("PatientStructNoEEG.mat")
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
