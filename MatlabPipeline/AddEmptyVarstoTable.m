function T = AddEmptyVarstoTable(T,varNames,varTypes)

tTemp = table('Size',[size(T,1),length(varNames)],'VariableTypes',varTypes,'VariableNames',varNames);
numericTypes = ["double", "single", "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64"];
for idx = find(ismember(tTemp.Properties.VariableTypes,numericTypes))
    tTemp.(idx) = nan(size(tTemp,1),1);
end
tTemp.Properties.VariableTypes = varTypes;
T = cat(2,T,tTemp);

end