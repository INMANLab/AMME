%% Sample graphing
pInclude = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
regionNames = "PRC";
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
                             "mean",["Values"]);
regionLevel = groupsummary(pLevel,["trial_type","Region"],...
                                  "mean",["mean_Values"]);


regionNames = string(regionLevel.Region);
conds = string(regionLevel.trial_type);
powerVals = regionLevel.("mean_mean_Values");

% regionNames = string(regionLevel.("Region")(index));

figure
plot(freqVals,powerVals)
xlabel("Frequency (Hz)")
ylabel("Power (dB)")
legend(regionNames+" "+conds)