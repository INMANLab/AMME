%% Initialize codes running from Github to get required directories

rdDir = uigetdir([],"Choose Reading Directory");
rdDir = string(rdDir) + string(filesep);
wrDir = uigetdir(rdDir,"Choose Writing Directory");
wrDir = string(wrDir) + string(wrDir);


if isempty(which('chronux')) % Check if Chronux is in the path
    disp('Chronux package not found in the path.');
    folderPath = uigetdir(pwd, 'Select the Chronux package folder');
    if folderPath ~= 0 % If the user selects a folder
        addpath(genpath(folderPath));
        savepath; % Save the updated path
        disp('Chronux package added to the path.');
    else
        disp('Chronux package not added. Please ensure it is accessible.');
    end
else
    disp('Chronux package is already in the path.');
end