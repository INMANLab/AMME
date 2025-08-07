%% Sample graphing
pInclude = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
% pInclude = unique(datAll.Patient);
regionNames = ["PNAS_CA","PNAS_BLA","PNAS_PRC"];
conds = ["nostim"];
measureName = "post_Freq_";

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

set(groot, 'defaultLegendInterpreter', 'none');
%% Group levels
regionNames = string(regionLevel.Region);
conds = string(regionLevel.trial_type);
Vals = regionLevel(:,regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
Vals = table2array(Vals);
f = convertCharsToStrings(regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, measureName)));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[f,idx] = sort(f);
Vals = Vals(:,idx);
% regionNames = string(regionLevel.("Region")(index));

figure
plot(f,Vals)
xlabel("Frequency (Hz)")
ylabel("Power (dB)")
legend(regionNames+" "+conds)
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