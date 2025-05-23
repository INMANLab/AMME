function datArray = convertTimetable2Array(dat,chNames)

datArray = [];
for chIdx = 1:length(chNames)
     datTemp = vertcat(dat.(chNames(chIdx)){:});
     datArray = cat(2,datArray,datTemp);
end


end