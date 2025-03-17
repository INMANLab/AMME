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

write.csv(ExChannels,paste(RD,"ExcludedChannelsAll.csv",sep =""),row.names = F)


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


write.csv(ExEpochs,paste(RD,"ExcludedEpochsAll.csv",sep =""),row.names = F)
