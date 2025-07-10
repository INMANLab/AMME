function T = MergeTablesVertically(T1,T2)

if(isempty(T1))
    T = T2;
    return
elseif(isempty(T2))
    T = T1;
    return
end
% Step 1: Get all variable names
allVars = union(T1.Properties.VariableNames, T2.Properties.VariableNames);

% Step 2: Add missing variables to each table
varTypes = T2.Properties.VariableTypes;
varNames = setdiff(allVars, T1.Properties.VariableNames);
varTypes = varTypes(ismember(T2.Properties.VariableNames, varNames));
T1 = AddEmptyVarstoTable(T1,varNames,varTypes);

varTypes = T1.Properties.VariableTypes;
varNames = setdiff(allVars, T2.Properties.VariableNames);
varTypes = varTypes(ismember(T1.Properties.VariableNames, varNames));
T2 = AddEmptyVarstoTable(T2,varNames,varTypes);

% Step 3: Make sure variable order is the same
T1 = T1(:, allVars);
T2 = T2(:, allVars);

% Step 4: Vertically concatenate
T = [T1; T2];

end