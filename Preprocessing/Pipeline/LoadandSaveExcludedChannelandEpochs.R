rm(list=ls(all=TRUE))

x = readline()
D:\GithubRep\AMME\Preprocessing\TestingonAmy003
setwd(x)
getwd()

library(pacman)
p_load(ez,
       lme4,
       ggplot2,
       tidyr,
       plyr,
       dplyr,
       effects,
       rstatix,
       sjPlot,
       flexplot,
       MuMIn)

RD = "C:\\Users\\alire\\Box\\InmanLab\\AMME_Data_Emory\\AMME_Data\\"
WD = "C:\\Users\\alire\\Box\\InmanLab\\AMME_Data_Emory\\AMME_Data\\"
################################## 
PatientList = read.csv(paste(RD,"PatientList.csv",sep =""))


ExChannels = NULL
for (pName in PatientList$Patient){
  print(pName)
  fileName = "DroppedChans.csv"
  PathOffset = "\\PreprocessedData\\Martinas_preprocessing\\"
  channFile = read.csv(paste(RD,pName,PathOffset,fileName,sep =""))
  names(channFile) = c("c1","c2")
  A = data.frame(Patient= pName, Channels = channFile$c2)
  ExChannels = rbind(ExChannels,A)
}
write.csv(ExChannels,paste(WD,"ExcludedChannelsAll.csv",sep =""),row.names = F)


ExEpochs = NULL
for (pName in PatientList$Patient){
  print(pName)
  fileName = "DroppedEpochs.csv"
  PathOffset = "\\PreprocessedData\\Martinas_preprocessing\\"
  channFile = read.csv(paste(RD,pName,PathOffset,fileName,sep =""))
  if(nrow(channFile>0)){
    names(channFile) = c("c1","c2")
    A = data.frame(Patient= pName, Epochs = channFile$c2)
    ExEpochs = rbind(ExEpochs,A)
  }
}
write.csv(ExEpochs,paste(WD,"ExcludedEpochsAll.csv",sep =""),row.names = F)

####################################
EDFFileList = NULL
for (pName in PatientList$Patient){
  print(pName)
  edfFiles = list.files(paste(RD,pName,sep =""), pattern = "*.edf")
  A = data.frame(Patient= pName, Files = edfFiles)
  EDFFileList = rbind(EDFFileList,A)
}
EDFFileList$Day = case_when(grepl("day1",EDFFileList$Files,ignore.case = T)~"Day1",
                            grepl("day2",EDFFileList$Files,ignore.case = T)~"Day2")

EDFFileList = EDFFileList[!is.na(EDFFileList$Day),]
write.csv(EDFFileList,paste(WD,"EDFFileList.csv",sep =""),row.names = F)

####################################
EDFFileList = read.csv(paste(WD,"EDFFileList.csv",sep =""))
LogList = NULL
for (pName in unique(EDFFileList$Patient)){
  print(pName)
  Files = list.files(paste(RD,pName,sep =""), pattern = ".log")
  A = data.frame(Patient= pName, LogFile = Files)
  LogList = rbind(LogList,A)
}
LogList$Day = ifelse(grepl("day2",LogList$LogFile,ignore.case = T),"Day2","Day1")
EDFFileList = merge(EDFFileList,LogList,by = c("Patient","Day"),all.x = T)

trialTimes = NULL
for (pName in PatientList$Patient){
  print(pName)
  trilTFiles = list.files(paste(RD,pName,sep =""), pattern = "_day2_trialtimes.mat")
  A = data.frame(Patient= pName, TrialTimeFiles = trilTFiles)
  A$Day = "Day2"
  trialTimes = rbind(trialTimes,A)
}
FileList = merge(EDFFileList,trialTimes,by = c("Patient","Day"),all.x = T)

FileList = FileList %>% group_by(Patient) %>%
  mutate(N = n()) %>% as.data.frame()

write.csv(FileList,paste(RD,"FileInfoList.csv",sep =""),row.names = F)
