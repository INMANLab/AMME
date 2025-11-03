%% Sample graphing
pInclude = ["amyg008", "amyg010", "amyg013", "amyg017"];%,"amyg003" "amyg008", "amyg010", "amyg013", "amyg017"];
pInclude = unique(datAll.Patient);

set(groot, 'defaultLegendInterpreter', 'none');
% Problems to solve: BLA Amyg057 BLA Amyg030
%% Shaded Graphs Single Condition
regioncolor={ 'Magenta','Orange', 'Cyan'};

% regionNames = ["HPC","BLA","PRC"];
% regionNames = ["PNAS_PRC","PNAS_CA","PNAS_BLA"];
regionNames = ["PNAS_CA_PNAS_BLA","PNAS_PRC_PNAS_BLA","PNAS_CA_PNAS_PRC"];
% regionNames = ["BLA_HPC","HPC_PRC","BLA_PRC"];
conds = ["nostim"];
measureName = "post_Freq_";
yes_no = ["yes"];


datAll.trial_type = convertCharsToStrings(datAll.trial_type);
stimConds = ["1s stim", "3s stim", "After stim", "Before stim", "During stim", "stim"];
datAll.trial_type(ismember(datAll.trial_type,stimConds)) = "stim";

convertCharsToStrings(unique(datAll.trial_type))

index = ismember(datAll.Region,regionNames) &...
        ismember(datAll.trial_type,conds) &...
        ismember(datAll.Patient,pInclude) &...
        ismember(datAll.yes_or_no,yes_no);


datGraph = datAll(index,:);
unique(datGraph.Patient)



datGraph.trial_type = categorical(datGraph.trial_type);
datGraph.Region = categorical(datGraph.Region);
% pLevel = groupsummary(datGraph,["Patient","Region"],...
                             % "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));
% regionLevel = groupsummary(pLevel,["Region"],...
                                  % "mean",pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));

pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
                             "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));
df1 = 2*pLevel.GroupCount*5;
df2 = 2*pLevel.GroupCount*9;
df1 = -(1./(df1-2));
df2 = -(1./(df2-2));
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
df = zeros(size(pLevel,1),length(f));
df(:,f<=15)=repmat(df1,1,sum(f<=15));
df(:,f>15)=repmat(df2,1,sum(f>15));
pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName))) = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName))) + df;

regionLevel = groupsummary(pLevel,["trial_type","Region"],...
                                  "mean",pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));


Vals = regionLevel(:,regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[~,idx] = sort(f);
ValsGroup = Vals(:,idx);

Vals = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[f,idx] = sort(f);
Vals = Vals(:,idx);


figure
hold on
for rgIdx = 1:length(regionNames)
    groupRGNames = string(regionLevel.Region);
    gDat = ValsGroup(strcmp(groupRGNames,regionNames(rgIdx)),:);
    plot(f,gDat,'LineWidth',2,Color=rgb(regioncolor{rgIdx}))
end
for rgIdx = 1:length(regionNames)
    patientRGNames = string(pLevel.Region);
    gDat = Vals(strcmp(patientRGNames,regionNames(rgIdx)),:);
    patch([f; flip(f)], [mean(gDat)-std(gDat)/sqrt(size(gDat,1)), flip(mean(gDat)+std(gDat)/sqrt(size(gDat,1)))]', rgb(regioncolor{rgIdx}), 'FaceAlpha',0.25,'EdgeColor','none')
end
xlabel("Frequency (Hz)")
ylabel(unique(datAll.Measure))
% xlim([0,55])
legend(regionNames)
title(conds)

%% patient levels
regioncolor={ 'Magenta','Orange', 'Cyan'};
phase = 3;
% regionNames = ["HPC","BLA","PRC"];
regionNames = ["PNAS_PRC","PNAS_CA","PNAS_BLA"];
% regionNames = ["PNAS_CA_PNAS_BLA","PNAS_PRC_PNAS_BLA","PNAS_CA_PNAS_PRC"];
% regionNames = ["BLA_HPC","HPC_PRC","BLA_PRC"];
conds = ["nostim","stim"];
measureName = "post_Freq_";
yes_no = ["yes"];

datAll.trial_type = convertCharsToStrings(datAll.trial_type);
stimConds = ["1s stim", "3s stim", "After stim", "Before stim", "During stim", "stim"];
datAll.trial_type(ismember(datAll.trial_type,stimConds)) = "stim";
convertCharsToStrings(unique(datAll.trial_type))

index = ismember(datAll.Region,regionNames) &...
        ismember(datAll.trial_type,conds) &...
        ismember(datAll.Patient,pInclude) &...
        ismember(datAll.Phase,phase) &...
        ismember(datAll.yes_or_no,yes_no);
datGraph = datAll(index,:);

datGraph.trial_type = categorical(datGraph.trial_type);
datGraph.Region = categorical(datGraph.Region);
pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
                             "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));

Vals = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[freqs,idx] = sort(f);
Vals = Vals(:,idx);

stimIdx = (pLevel.Region == regionNames(1) & pLevel.trial_type == "stim");
noStimIdx = (pLevel.Region == regionNames(1) & pLevel.trial_type == "nostim");
stimDataP = Vals(stimIdx,:);
noStimDataP = Vals(noStimIdx,:);
bothDataP = cat(3,stimDataP,noStimDataP);
bothDataP = mean(bothDataP,3);

stimIdx = (pLevel.Region == regionNames(2) & pLevel.trial_type == "stim");
noStimIdx = (pLevel.Region == regionNames(2) & pLevel.trial_type == "nostim");
stimDataHPC = Vals(stimIdx,:);
noStimDataHPC = Vals(noStimIdx,:);
bothDataHPC = cat(3,stimDataHPC,noStimDataHPC);
bothDataHPC = mean(bothDataHPC,3);

stimIdx = (pLevel.Region == regionNames(3) & pLevel.trial_type == "stim");
noStimIdx = (pLevel.Region == regionNames(3) & pLevel.trial_type == "nostim");
stimDataBLA = Vals(stimIdx,:);
noStimDataBLA = Vals(noStimIdx,:);
bothDataBLA = cat(3,stimDataBLA,noStimDataBLA);
bothDataBLA = mean(bothDataBLA,3);
pNameList = unique(pLevel.Patient);

figure
subplot 131
gDat = stimDataP;
plot(freqs,gDat,'LineWidth',2)
legend(pNameList)
title("PERI")

subplot 132
gDat = stimDataHPC;
plot(freqs,gDat,'LineWidth',2)
legend(pNameList)
title("HPC")

subplot 133
gDat = stimDataBLA;
plot(freqs,gDat,'LineWidth',2)
legend(pNameList)
title("BLA")
%% patient levels
regionNames = string(pLevel.Region);
conds = string(pLevel.trial_type)+string(pLevel.Patient);
Vals = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[f,idx] = sort(f);
Vals = Vals(:,idx);

figure
plot(f,Vals)
xlabel("Frequency (Hz)")
ylabel("Power (dB)")
legend(regionNames+" "+conds)
%% Shaded Graphs Stim noStim single Region
condcolor={'Red', 'Blue', 'Green'};

% regionNames = ["PRC"]; %"HPC","BLA",
% regionNames = ["PNAS_PRC"]; %"PNAS_HPC", "PNAS_BLA","PNAS_PRC"
regionNames = ["PNAS_CA_PNAS_PRC"]; %"PNAS_CA_PNAS_BLA","PNAS_PRC_PNAS_BLA",
% regionNames = ["BLA_PRC"]; %"BLA_HPC","HPC_PRC","BLA_PRC"
conds = ["nostim","stim"];
measureName = "diff_Freq_";
yes_no = ["yes"];

datAll.trial_type = convertCharsToStrings(datAll.trial_type);
stimConds = ["1s stim", "3s stim", "After stim", "Before stim", "During stim", "stim"];
datAll.trial_type(ismember(datAll.trial_type,stimConds)) = "stim";

convertCharsToStrings(unique(datAll.trial_type))

index = ismember(datAll.Region,regionNames) &...
        ismember(datAll.trial_type,conds) &...
        ismember(datAll.Patient,pInclude)&...
        ismember(datAll.yes_or_no,yes_no);


datGraph = datAll(index,:);
unique(datGraph.Patient)


datGraph.trial_type = categorical(datGraph.trial_type);
datGraph.Region = categorical(datGraph.Region);
pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
                             "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));
df1 = 2*pLevel.GroupCount*5;
df2 = 2*pLevel.GroupCount*9;
df1 = -(1./(df1-2));
df2 = -(1./(df2-2));
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
df = zeros(size(pLevel,1),length(f));
df(:,f<=15)=repmat(df1,1,sum(f<=15));
df(:,f>15)=repmat(df2,1,sum(f>15));
pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName))) = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName))) + df;

regionLevel = groupsummary(pLevel,["trial_type","Region"],...
                                  "mean",pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));



Vals = regionLevel(:,regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[~,idx] = sort(f);
ValsGroup = Vals(:,idx);

Vals = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[f,idx] = sort(f);
Vals = Vals(:,idx);


figure
hold on
for cIdx = 1:length(conds)
    groupConds = string(regionLevel.trial_type);
    gDat = ValsGroup(strcmp(groupConds,conds(cIdx)),:);
    plot(f,gDat,'LineWidth',2,Color=rgb(condcolor{cIdx}))
end
for cIdx = 1:length(conds)
    patientConds = string(pLevel.trial_type);
    gDat = Vals(strcmp(patientConds,conds(cIdx)),:);
    patch([f; flip(f)], [mean(gDat)-std(gDat)/sqrt(size(gDat,1)), flip(mean(gDat)+std(gDat)/sqrt(size(gDat,1)))]', rgb(condcolor{cIdx}), 'FaceAlpha',0.25,'EdgeColor','none')
end
xlabel("Frequency (Hz)")
ylabel(unique(datAll.Measure))
xlim([0,20])
legend(conds)
title(regionNames,'Interpreter','none')
%% Group levels
% regionNames = string(regionLevel.Region);
% conds = string(regionLevel.trial_type);
% Vals = regionLevel(:,regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
% Vals = table2array(Vals);
% f = convertCharsToStrings(regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
% f = regexp(f,'\d+\.?\d*', 'match');
% f = vertcat(f{:});
% f = str2double(f);
% [f,idx] = sort(f);
% Vals = Vals(:,idx);
% % regionNames = string(regionLevel.("Region")(index));
% 
% figure
% plot(f,Vals)
% xlabel("Frequency (Hz)")
% ylabel("Power (dB)")
% legend(regionNames+" "+conds)
%% patient levels
regionNames = string(pLevel.Region);
conds = string(pLevel.trial_type)+string(pLevel.Patient);
Vals = pLevel(:,pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[f,idx] = sort(f);
Vals = Vals(:,idx);

figure
plot(f,Vals)
xlabel("Frequency (Hz)")
ylabel("Power (dB)")
legend(regionNames+" "+conds)
%% Collapsed Condition
% gDat = pLevel;
% gDat = groupsummary(gDat,["Patient","Region"],...
%                              "mean",gDat.Properties.VariableNames(contains(gDat.Properties.VariableNames, measureName)));
% gDat = groupsummary(gDat,["Region"],...
%                              "mean",gDat.Properties.VariableNames(contains(gDat.Properties.VariableNames, measureName)));
% 
% regionNames = string(gDat.Region);
% Vals = gDat(:,gDat.Properties.VariableNames(contains(gDat.Properties.VariableNames, measureName)));
% Vals = table2array(Vals);
% f = convertCharsToStrings(gDat.Properties.VariableNames(contains(gDat.Properties.VariableNames, measureName)));
% f = regexp(f,'\d+\.?\d*', 'match');
% f = vertcat(f{:});
% f = str2double(f);
% [f,idx] = sort(f);
% Vals = Vals(:,idx);
% % regionNames = string(regionLevel.("Region")(index));
% 
% figure
% plot(f,Vals)
% xlabel("Frequency (Hz)")
% ylabel("Power (dB)")
% legend(regionNames)