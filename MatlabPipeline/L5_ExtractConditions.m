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
% load(RD+"PatientStructL4_MartinaChannels_MedianWithoutNoisyCh");
% load(RD+"PatientStructL4_Day2Only_JoeChannels.mat");
% load(RD+"PatientStructL4OnlyPNAS.mat");
fileNameTag = "MartinaChannels";
load(RD+"PatientStructL4_"+fileNameTag+".mat");
% DisplayPatientStructInfo(patient);

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

FileNameStartWith = "Data_"+fileNameTag;
SavePatientsinSeparateFiles = true; % false -> Store in one csv | true -> Store separate csv for each patient

%-------- Desired Results
par.Freqs = [0,100];
par.PatientList = 1:24;
par.Measure = "Coherency";
par.Region = ["HPC","PHG","BLA","PRC","EC","CA","DG"];
par.Phase = 1;
par.ChannelOrder = "1_1"; % For Power use "1"

%################################ Example Parameters for Coherency
%-------- Control output CSV files
% FileNameStartWith = "Data_JoeChannels_";
% SavePatientsinSeparateFiles = false;
% 
% %-------- Desired Results
% par.Freqs = [0,100];
% par.PatientList = [1,4,6,8,11];%[1:5,7:24];1:24;
% 
% 
% par.Measure = "Coherency";
% par.Region = ["PNAS_CA",... % CA region analyzed in the PNAS paper
%               "PNAS_DG",... % DG region analyzed in the PNAS paper
%               "PNAS_PRC",... % PRC region analyzed in the PNAS paper
%               "PNAS_BLA"];
% par.ChannelOrder = "1_1";

% par.Measure = "Power";
% par.Region = ["PHG","BLA", "HPC", "PRC"];
% par.Region = ["PNAS_CA",... % CA region analyzed in the PNAS paper
%               "PNAS_DG",... % DG region analyzed in the PNAS paper
%               "PNAS_PRC",... % PRC region analyzed in the PNAS paper
%               "PNAS_BLA"];
% par.ChannelOrder = "1";

% "PHG","BLA", "HPC", "PRC",...
% par.Region = ["PHG","BLA", "HPC", "PRC",...,
%               "PNAS_CA",... % CA region analyzed in the PNAS paper
%               "PNAS_DG",... % DG region analyzed in the PNAS paper
%               "PNAS_PRC",... % PRC region analyzed in the PNAS paper
%               "PNAS_BLA"];
% par.Phase = 3;
 % For Coherency use "1_1"
%% Extract Results

for phIdx = par.Phase
    datAll = table;
    for pIdx = par.PatientList
        dat = table;
        %========================> Extract Specified Results
        result0 = patient(pIdx).phase(phIdx).Results;
        %-------- Check if Measure is available in this patient
        if(~ismember(par.Measure, unique(result0.Measure)))
            continue;
        end
        result0 = result0(result0.Measure == par.Measure, :);

        if(par.ChannelOrder~="All")
            % result.ChOrder = string(result.ChOrder);  %----------> Why this happened?
            chanOrders = par.ChannelOrder;
        else
            chanOrders = unique(result0.ChOrder);
        end
        %=======================> Loop over available Channels within regions
        for chIdx = 1:length(chanOrders)
            %-------- Check if Channel is available in this patient
            if(~ismember(chanOrders(chIdx), unique(result0.ChOrder)))
                continue;
            end
            result = result0(result0.ChOrder == chanOrders(chIdx), :);
            %=======================> Loop over available regions
            for rgIdx = 1:length(par.Region)        
                availableRegions = unique(result.Region);
       
                availableRGIdx = find(contains(availableRegions, par.Region(rgIdx)))';
                % %-------- Check if Region is available in this patient
                % if(isempty(availableRGIdx))
                %     fprintf('⚠️ Warning! No results found for Patient = %s, Measure = %s, Region = %s\n'...
                %         , patient(pIdx).name, par.Measure, par.Region{rgIdx});
                %     continue;
                % end
                resultTemp = result;
                %-------- Loop over Available Regions
                for aRGIdx = availableRGIdx
                    result = resultTemp(resultTemp.Region == availableRegions(aRGIdx), :);
                    resultTemp = resultTemp(resultTemp.Region ~= availableRegions(aRGIdx), :);
        
                    datRes = patient(pIdx).phase(phIdx).trial;
                    if(isstruct(datRes))
                        datRes = struct2table(datRes);
                    end
                    emptyTrials = isnan(datRes.start_time);
                    datRes = datRes(~emptyTrials,:);
            
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
                    datRes.ChanOrder = repmat(unique(result.ChOrder), size(datRes,1),1);
                    datRes.ChanName = repmat(unique(result.ChName), size(datRes,1),1);
        
                    datRes(:, "pre_Freq_"+string(round(freqVals,2))) = array2table(values1); %pre
                    datRes(:, "post_Freq_"+string(round(freqVals,2))) = array2table(values2); %post
                    datRes(:, "diff_Freq_"+string(round(freqVals,2))) = array2table(values); %baseline corrected for stim-nostim graph per region
        
                    dat = cat(1,dat,datRes);
                end
                result = resultTemp;
            end % end Region
        end %end Channel Order
        
        if(SavePatientsinSeparateFiles)
            % writetable(datRes,WR+"patient"+pIdx+"phase"+phIdx+"Measure"+par.Measure+".csv")
            writetable(dat,WR+FileNameStartWith+string(patient(pIdx).name)+"phase"+phIdx+"Measure"+par.Measure+".csv") %#ok<UNRCH>
        else
            if(pIdx>=16)
                dat.confrt = str2double(dat.confrt);
            end
            datAll = MergeTablesVertically(datAll,dat);
        end
    end
    if(~SavePatientsinSeparateFiles)
        writetable(datAll,WR+FileNameStartWith+"_AllPatients"+"_phase"+phIdx+"_Measure"+par.Measure+".csv")
    end
    % save(WR+FileNameStartWith+"FreqValsfor"+"_phase"+phIdx+"_Measure","freqVals");
end





%% Sample graphing
% 
% pInclude = unique(datAll.Patient);
% regionNames = ["PNAS_CA","PNAS_BLA","PNAS_PRC"];
% conds = ["stim"];
% measureName = "post_Freq_";
% 
% % regionNames = ["PNAS_PRC"];
% % conds = ["nostim","stim"];
% % measureName = "diff_Freq_";
% 
% index = ismember(datAll.Region,regionNames) &...
%         ismember(datAll.trial_type,conds) &...
%         ismember(datAll.Patient,pInclude);
% datGraph = datAll(index,:);
% unique(datGraph.Patient)
% 
% 
% trial = datGraph.trial_type;
% newIdx = strcmp(trial,"new");
% nostimIdx = strcmp(trial,"nostim");
% trial(~(newIdx|nostimIdx)) = repmat({'stim'},sum(~(newIdx|nostimIdx)),1);
% datGraph.trial_type = categorical(trial);
% datGraph.Region = categorical(datGraph.Region);
% pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
%                              "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));
% regionLevel = groupsummary(pLevel,["trial_type","Region"],...
%                                   "mean",pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
% 
% set(groot, 'defaultLegendInterpreter', 'none');
% 
% %--------- patient levels
% regionNames = string(pLevel.Region);
% conds = string(pLevel.trial_type)+string(pLevel.Patient);
% Vals = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
% Vals = table2array(Vals);
% f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
% f = regexp(f,'\d+\.?\d*', 'match');
% f = vertcat(f{:});
% f = str2double(f);
% [f,idx] = sort(f);
% Vals = Vals(:,idx);
% 
% figure
% subplot 131
% hold on
% plot(f,Vals(contains(regionNames,"PRC"),:),'LineWidth',1)
% % legend("Old","new")
% title("PERI")
% 
% subplot 132
% hold on
% plot(f,Vals(contains(regionNames,"CA"),:),'LineWidth',1)
% % legend("Old","new")
% title("HPC")
% 
% subplot 133
% hold on
% plot(f,Vals(contains(regionNames,"BLA"),:),'LineWidth',1)
% % legend("Old","new")
% title("BLA")