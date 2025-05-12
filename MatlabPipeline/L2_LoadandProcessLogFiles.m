%% Initialization

%%
%---------Original
LoadandprocessLogFilesOriginalGroup;
%---------Duration
LoadandprocessLogFilesDurationGroup;

%-------Timing
LoadandprocessLogFilesTimingGroup;

save("PatientStructNoEEG","patient");

%% Export Patient Channel Info
pList = string(vertcat(patient.name));
T = table;
for pIdx = 1:length(pList)
    tempTab = struct2table(patient(pIdx).ipsi_region);
    tempTab.pName = repmat(string(patient(pIdx).name),size(tempTab,1),1);

    d=2;
    tempTab.phase = repmat("day"+string(d),size(tempTab,1),1);
    tempTab.synchChNum = repmat(patient(pIdx).sync_chnum,size(tempTab,1),1);
    tempTab.samplingRate = repmat(patient(pIdx).samprate,size(tempTab,1),1);

    if strcmp(patient(pIdx).name, 'amyg045') == 1 || strcmp(patient(pIdx).name, 'amyg048') == 1 || strcmp(patient(pIdx).name, 'amyg054') == 1 || strcmp(patient(pIdx).name, 'amyg060') == 1 || strcmp(patient(pIdx).name, 'amyg072') == 1
        hdrName = sprintf('day%dLamyg_hdr.mat', d);
    elseif strcmp(patient(pIdx).name, 'amyg057') ==1
        hdrName = sprintf('day%dbipolar_hdr.mat',d);
    elseif strcmp(patient(pIdx).name, "amyg030")
        hdrName = sprintf('day%dbilateral_hdr.mat',d);
    else
        hdrName = "day2_hdr.mat";
    end


    if(strcmp(patient(pIdx).exp,'Original'))
        indexOffset = 1;
    else
        indexOffset = 0;
    end
    hdr = load(string(patient(pIdx).name)+string(filesep)+hdrName).hdr;
    for regionIdx = 1:length(tempTab.lfpnum)
        tempTab.chName(regionIdx) = {[convertCharsToStrings(hdr.label(tempTab.lfpnum{regionIdx}+indexOffset))]};
        tempTab.synchChName(regionIdx) = {[convertCharsToStrings(hdr.label(tempTab.synchChNum(regionIdx)+indexOffset))]};
    end
    T = vertcat(T,tempTab);
end

for rowIdx = 1:length(T.pName)
    for lfpIdx = 1:length(T.lfpnum{rowIdx})
        T.("chIdx"+string(lfpIdx)){rowIdx} = T.lfpnum{rowIdx}(lfpIdx);
        T.("chName"+string(lfpIdx)){rowIdx} = T.chName{rowIdx}(lfpIdx);
    end
end
T = removevars(T,{'lfpnum','chName'});
writetable(T,"ChannelList.csv")
%% Checking Channel List
% PatientNames = ["amyg003", "amyg008", "amyg010", "amyg013", "amyg017"];
% pList = string(vertcat(patient.name));
% pIndex = find(ismember(pList,PatientNames));
% T = table;
% for pIdx = pIndex'
%     tempTab = struct2table(patient(pIdx).region);
%     tempTab = tempTab([1,3,4],:);
%     tempTab.pName = repmat(string(patient(pIdx).name),size(tempTab,1),1);
%     hdr = load(string(patient(pIdx).name)+string(filesep)+"day2_hdr.mat").hdr;
%     tempTab.chName = convertCharsToStrings(hdr.label(cell2mat(tempTab.lfpnum)+1))';
%     T = vertcat(T,tempTab);
% end