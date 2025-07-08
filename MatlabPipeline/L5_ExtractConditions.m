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
load(WR+"PatientStructL4Small");

% patient = patient([1:9,11:24]);
% DisplayPatientStructInfo(patient);

%% Parameters
% This routine extracts processed data for specified conditions from patient 
% structure for visualization or statistical analysis or exporting data.
%################################ Parameters
% Frequency 
par.Freqs = [0,50];
par.PatientList = [1:9,11:24];
par.Measure = "Power";
par.Region = ["HPC","PHG","BLA"];
par.Phase = 3;
par.ChannelOrder = "1"; % Don't change this for Coherency use "1_1"

%% Extract Results
for pIdx = par.PatientList
    dat = table;
    for rgIdx = 1:length(par.Region)
        phIdx = par.Phase;
    
        datRes = struct2table(patient(pIdx).phase(phIdx).trial);
        result = patient(pIdx).phase(phIdx).Results;
        result = result(result.Measure == par.Measure,:);
        result = result(result.ChOrder == par.ChannelOrder,:);
        result = result(result.Region == par.Region(rgIdx),:);
        if(size(result,1)==0)
            continue;
        end

        measureIdx = result.EpochTime=="PreImage";
        freqIdx = result.Freqs{measureIdx}>=par.Freqs(1)  & result.Freqs{measureIdx}<=par.Freqs(2);
        freqVals = result.Freqs{measureIdx}(freqIdx);
        values = result.Value{measureIdx};
        values1 = values(freqIdx,:)';
    
        measureIdx = result.EpochTime=="PostImage";
        freqIdx = result.Freqs{measureIdx}>=par.Freqs(1)  & result.Freqs{measureIdx}<=par.Freqs(2);
        values = result.Value{measureIdx};
        values2 = values(freqIdx,:)';
    
        values = db(values2)-db(values1);
    
    
        datRes.Patient = repmat(string(patient(pIdx).name), size(datRes,1),1);
        datRes.Phase = repmat(phIdx, size(datRes,1),1);
        datRes.Measure = repmat(par.Measure, size(datRes,1),1);
        datRes.Region = repmat(par.Region(rgIdx), size(datRes,1),1);
        datRes.Values = values;
        dat = cat(1,dat,datRes);
    end
    % writetable(datRes,WR+"patient"+pIdx+"phase"+phIdx+"Measure"+par.Measure+".csv")
    writetable(datRes,WR+string(patient(pIdx).name)+"phase"+phIdx+"Measure"+par.Measure+".csv")
end
save(WR+"FreqValsfor"+"_phase"+phIdx+"_Measure","freqVals");
%% Save the data
% save(WR+"PatientStructL4","patient","-v7.3");
