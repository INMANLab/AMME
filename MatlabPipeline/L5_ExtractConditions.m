%% Initialization
clear;
clc;
%-----------Raw Data Path
RDD = "Z:\Data\AMME_Data_Emory\AMME_Data\";
%-----------Read Processed Data from:
RD = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\";
%-----------Write Processed Data to:
WR = "D:\Individuals\Alireza\Data\Amme\MatlabPipeline\CSVOutput\";

%################################ Add Required Toolboxes
ChronuX_path = "D:\Toolboxes\chronux_2_12";
addpath(genpath(ChronuX_path));
%################################ load patient Structure
load(RD+"PatientStructL4");
DisplayPatientStructInfo(patient);

%------------ Name of regions for reference:
% "CA";... % "ipsi CA fields"
% "DG";... % "ipsi DG"
% "PHG";... % "ipsi PHG"
% "BLA";... % "ipsi BLA"
% "HPC";... % "all ipsi hippocampus"
% "EC";...  % "all ipsi EC"
% "PRC";...  % "all ipsi PRC"
%% Parameters 
% This routine extracts processed data for specified conditions from patient 
% structure for visualization or statistical analysis or exporting data.
%################################ Example Parameters for Power
%-------- Control output CSV files
FileNameStartWith = "Data_";
SavePatientsinSeparateFiles = false;

%-------- Desired Results
par.Freqs = [0,100];
par.PatientList = [1:24];
par.Measure = "Power";
par.Region = ["HPC","PHG","BLA","PRC","EC","CA","DG"];
par.Phase = 3;
par.ChannelOrder = "1"; % For Power use "1"

%################################ Example Parameters for Coherency
%-------- Control output CSV files
FileNameStartWith = "Data_";
SavePatientsinSeparateFiles = false;

%-------- Desired Results
par.Freqs = [0,100];
par.PatientList = [1:24];
par.Measure = "Coherency";
par.Region = ["BLA_HPC"];
par.Phase = 3;
par.ChannelOrder = "1_1"; % For Coherency use "1_1"
%% Extract Results
datAll = table;
for pIdx = par.PatientList
    dat = table;

    phIdx = par.Phase;
    
    %========================> Extract Specified Results
    result = patient(pIdx).phase(phIdx).Results;
    %-------- Check if Measure is available in this patient
    if(~ismember(par.Measure, unique(result.Measure)))
        continue;
    end
    result = result(result.Measure == par.Measure, :);
    %-------- Check if Channel is available in this patient
    if(~ismember(par.ChannelOrder, unique(result.ChOrder)))
        continue;
    end
    result = result(result.ChOrder == par.ChannelOrder, :);

    %=======================> Loop over available regions
    for rgIdx = 1:length(par.Region)        
        availableRegions = unique(result.Region);

        availableRGIdx = find(contains(availableRegions, par.Region(rgIdx)))';
        %-------- Check if Region is available in this patient
        if(isempty(availableRGIdx))
            continue;
        end
        resultTemp = result;
        %-------- Loop over Available Regions
        for aRGIdx = availableRGIdx
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
        
            values = values2-values1;% Values Already converted to db for power and fisher-z transformed for coherency
        
            datRes.Patient = repmat(string(patient(pIdx).name), size(datRes,1),1);
            datRes.Experiment = repmat(string(patient(pIdx).exp), size(datRes,1),1);
            datRes.Phase = repmat(phIdx, size(datRes,1),1);
            datRes.Measure = repmat(par.Measure, size(datRes,1),1);
            datRes.Region = repmat(availableRegions(aRGIdx), size(datRes,1),1);
            datRes.Values = values;
            dat = cat(1,dat,datRes);
        end
        
    end

    if(SavePatientsinSeparateFiles)
        % writetable(datRes,WR+"patient"+pIdx+"phase"+phIdx+"Measure"+par.Measure+".csv")
        writetable(dat,WR+FileNameStartWith+string(patient(pIdx).name)+"phase"+phIdx+"Measure"+par.Measure+".csv") %#ok<UNRCH>
    else
        datAll = MergeTablesVertically(datAll,dat);
    end
end
if(~SavePatientsinSeparateFiles)
    writetable(datAll,WR+FileNameStartWith+string(patient(pIdx).name)+"phase"+phIdx+"Measure"+par.Measure+".csv")
end
save(WR+FileNameStartWith+"FreqValsfor"+"_phase"+phIdx+"_Measure","freqVals");



