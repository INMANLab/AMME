%% Sample graphing
%pInclude = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
pInclude = unique(datAll.Patient);
regionNames = "BLA";
conds = ["stim","nostim"];
index = ismember(datAll.Region,regionNames) &...
        ismember(datAll.trial_type,conds) &...
        ismember(datAll.Patient,pInclude);
datGraph = datAll(index,:);

trial = datGraph.trial_type;
newIdx = strcmp(trial,"new");
nostimIdx = strcmp(trial,"nostim");
trial(~(newIdx|nostimIdx)) = repmat({'stim'},sum(~(newIdx|nostimIdx)),1);
datGraph.trial_type = categorical(trial);
datGraph.Region = categorical(datGraph.Region);
pLevel = groupsummary(datGraph,["Patient","trial_type","Region"],...
                             "mean",datGraph.Properties.VariableNames(contains(datGraph.Properties.VariableNames, "Freq_")));
regionLevel = groupsummary(pLevel,["trial_type","Region"],...
                                  "mean",pLevel.Properties.VariableNames(contains(pLevel.Properties.VariableNames, "mean_Freq_")));


regionNames = string(regionLevel.Region);
conds = string(regionLevel.trial_type);
powerVals = regionLevel(:,regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, "Freq_")));
powerVals = table2array(powerVals);
f = convertCharsToStrings(regionLevel.Properties.VariableNames(contains(regionLevel.Properties.VariableNames, "Freq_")));
f = regexp(f,'\d+\.?\d*', 'match');
f = vertcat(f{:});
f = str2double(f);
[f,idx] = sort(f);
powerVals = powerVals(:,idx);
% regionNames = string(regionLevel.("Region")(index));

figure
plot(f,powerVals)
xlabel("Frequency (Hz)")
ylabel("Power (dB)")
legend(regionNames+" "+conds)