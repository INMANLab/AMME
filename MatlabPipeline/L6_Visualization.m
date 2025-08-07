%% Sample graphing
% pInclude = ["amyg003"];%, "amyg008", "amyg010", "amyg013", "amyg017"];
pInclude = unique(datAll.Patient);

set(groot, 'defaultLegendInterpreter', 'none');

%% Shaded Graphs Single Condition
regioncolor={ 'Magenta','Orange', 'Cyan'};

regionNames = ["HPC","BLA","PRC"];
% regionNames = ["BLA_HPC","HPC_PRC","BLA_PRC"];
conds = ["stim"];
measureName = "post_Freq_";


datAll.trial_type = convertCharsToStrings(datAll.trial_type);
stimConds = ["1s stim", "3s stim", "After stim", "Before stim", "During stim", "stim"];
datAll.trial_type(ismember(datAll.trial_type,stimConds)) = "stim";

convertCharsToStrings(unique(datAll.trial_type))

index = ismember(datAll.Region,regionNames) &...
        ismember(datAll.trial_type,conds) &...
        ismember(datAll.Patient,pInclude);


datGraph = datAll(index,:);
unique(datGraph.Patient)


trial = datGraph.trial_type;
newIdx = strcmp(trial,"new");
nostimIdx = strcmp(trial,"nostim");
trial(~(newIdx|nostimIdx)) = repmat({'stim'},sum(~(newIdx|nostimIdx)),1);
datGraph.trial_type = categorical(trial);
datGraph.Region = categorical(datGraph.Region);
pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
                             "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));
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
xlim([0,55])
legend(regionNames)
title(conds)


%% Shaded Graphs Stim noStim single Region
condcolor={'Red', 'Blue', 'Green'};

regionNames = ["PRC"]; %"HPC", "BLA","PRC"
% regionNames = ["PNAS_CA_PNAS_BLA","PNAS_PRC_PNAS_BLA","PNAS_CA_PNAS_PRC"];
% regionNames = ["BLA_PRC"]; %"BLA_HPC","HPC_PRC","BLA_PRC"
conds = ["nostim","stim"];
measureName = "diff_Freq_";

datAll.trial_type = convertCharsToStrings(datAll.trial_type);
stimConds = ["1s stim", "3s stim", "After stim", "Before stim", "During stim", "stim"];
datAll.trial_type(ismember(datAll.trial_type,stimConds)) = "stim";

convertCharsToStrings(unique(datAll.trial_type))

index = ismember(datAll.Region,regionNames) &...
        ismember(datAll.trial_type,conds) &...
        ismember(datAll.Patient,pInclude);


datGraph = datAll(index,:);
unique(datGraph.Patient)


trial = datGraph.trial_type;
newIdx = strcmp(trial,"new");
nostimIdx = strcmp(trial,"nostim");
trial(~(newIdx|nostimIdx)) = repmat({'stim'},sum(~(newIdx|nostimIdx)),1);
datGraph.trial_type = categorical(trial);
datGraph.Region = categorical(datGraph.Region);
pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
                             "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, measureName)));
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
xlim([0,55])
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
% plot(f,Vals)
% xlabel("Frequency (Hz)")
% ylabel("Power (dB)")
% legend(regionNames+" "+conds)
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