%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Martina\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Martina\Data\Amme\MatlabPipeline\CSVOutput\";

%################################ Add Required Toolboxes
ChronuX_path = "D:\Toolboxes\chronux_2_12";
addpath(genpath(ChronuX_path));

%################################ load patient Structure
load(RD+"PatientStructL4NoEEG.mat");

%DisplayPatientStructInfo(patient);

%% Parameters
% This routine extracts processed data for specified conditions from patient 
% structure for visualization or statistical analysis or exporting data.
%################################ Parameters
% Frequency 
par.Freqs = [0,100];
par.PatientList = [1:9,11:24];
par.Measure = "Coherence";
par.Region = ["HPC","PHG","BLA","PRC","EC","CA","DG"]; % alternatively we can specify combinations ["EC_HPC"|"HPC_EC"];
par.Phase = 3;
par.ChannelOrder = "1_1"; % for power, use "1", for Coherency use "1_1" for the first channel in the list

% "CA";... % "ipsi CA fields"
% "DG";... % "ipsi DG"
% "PHG";... % "ipsi PHG"
% "BLA";... % "ipsi BLA"
% "HPC";... % "all ipsi hippocampus"
% "EC";...  % "all ipsi EC"
% "PRC"];  % "all ipsi PRC"

%% Extract Results
for pIdx = par.PatientList
    dat = table;
    phIdx = par.Phase;

    fprintf("------ working on patient %s \n", patient(pIdx).name)
    result = patient(pIdx).phase(phIdx).Results; %Extract Specified Results
    if(~ismember(par.Measure, unique(result.Measure))) %Check if Measure is available in this patient
        continue;
    end
    result = result(result.Measure == par.Measure, :);
    if(~ismember(par.ChannelOrder, unique(result.ChOrder))) %Check if Channel is available in this patient
        fprintf('️Warning! No channel found for Patient = %s, Measure = %s, Region = %s\n'...
                , patient(pIdx).name, par.Measure, par.Region{rgIdx})
        continue;
    end
    result = result(result.ChOrder == par.ChannelOrder, :);

    for rgIdx = 1:length(par.Region)  %Loop over available regions      
        availableRegions = unique(result.Region);
        availableRGIdx = find(contains(availableRegions, par.Region(rgIdx)))'; % for coherence find if pair contains specified region
        if(isempty(availableRGIdx)) % Check if Region is available in this patient
            fprintf('⚠️ Warning! No results found for Patient = %s, Measure = %s, Region = %s\n'...
                , patient(pIdx).name, par.Measure, par.Region{rgIdx});
            continue;
        end
        resultTemp = result;

        for aRGIdx = availableRGIdx %Loop over Available Regions
            result = resultTemp(resultTemp.Region == availableRegions(aRGIdx), :);

            datRes = struct2table(patient(pIdx).phase(phIdx).trial);

        measureIdx = result.EpochTime=="PreImage";
        freqIdx = result.Freqs{measureIdx}>=par.Freqs(1)  & result.Freqs{measureIdx}<=par.Freqs(2);
        freqVals = result.Freqs{measureIdx}(freqIdx);
        values = result.Value{measureIdx};
        values1 = values(freqIdx,:)';
    
        measureIdx = result.EpochTime=="PostImage";
        freqIdx = result.Freqs{measureIdx}>=par.Freqs(1)  & result.Freqs{measureIdx}<=par.Freqs(2);
        values = result.Value{measureIdx};
        values2 = values(freqIdx,:)';
    
        values = values2-values1;% Values Already converted to db for power 
        %  and fisher-z transformed for coherency
    
        datRes.Patient = repmat(string(patient(pIdx).name), size(datRes,1),1);
        datRes.Experiment = repmat(string(patient(pIdx).exp), size(datRes,1),1);
        datRes.Phase = repmat(phIdx, size(datRes,1),1);
        datRes.Measure = repmat(par.Measure, size(datRes,1),1);
        datRes.Region = repmat(par.Region(rgIdx), size(datRes,1),1);

        % Assign frequency-labeled columns
        datRes(:, strcat("Freq_", string(freqVals))) = array2table(values);

        dat = cat(1,dat,datRes);
        end
    end
    % writetable(datRes,WR+"patient"+pIdx+"phase"+phIdx+"Measure"+par.Measure+".csv")
    writetable(dat,WR+string(patient(pIdx).name)+"phase"+phIdx+"_1-100Hz"+par.Measure+".csv")
end
%save(WR+"FreqValsfor"+"_phase"+phIdx+"_Measure","freqVals");

