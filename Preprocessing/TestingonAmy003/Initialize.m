%% Initialize codes running from Github to get required directories

rdDir = uigetdir([],"Choose Reading Directory");
rdDir = string(rdDir) + string(filesep);
wrDir = uigetdir(readDir,"Choose Writing Directory");
wrDir = string(wrDir) + string(wrDir);