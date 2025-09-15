install.packages("effectsize")
library(effectsize)
library(pastecs)

## THIS SCRIPT LOOKS AT IMMEDIATE DATA STIM NO STIM DIFFERENCES ###
immdata <- read_excel("immediate_stim_data.xlsx")

#descriptive
hist(immdata$avg_imm_stim_dprime)
stat.desc(immdata$avg_imm_stim_dprime)

hist(immdata$imm_nostim_dprime)
stat.desc(immdata$imm_nostim_dprime)

#diff between stim and no stim
t.test(immdata$avg_imm_stim_dprime, immdata$imm_nostim_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(immdata$avg_imm_stim_dprime, na.rm = TRUE)
sd(immdata$avg_imm_stim_dprime, na.rm = TRUE)
mean(immdata$imm_nostim_dprime, na.rm = TRUE)
sd(immdata$imm_nostim_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(immdata$avg_imm_stim_dprime, na.rm = TRUE)
mean_nostim<- mean(immdata$imm_nostim_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(immdata$avg_imm_stim_dprime - immdata$imm_nostim_dprime,na.rm = TRUE)
cohenD<- abs(mean_diff/sd_diff)

#if immdata$study == "Duration" {
#hist(immdata$avg_stim_dprime_diff)
#stat.desc(immdata$avg_stim_dprime_diff)

hist(immdata$imm_nostim_dprime)
stat.desc(immdata$imm_nostim_dprime)

#diff between stim and no stim
t.test(immdata$avg_imm_stim_dprime, immdata$imm_nostim_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(immdata$avg_imm_stim_dprime, na.rm = TRUE)
sd(immdata$avg_imm_stim_dprime, na.rm = TRUE)
mean(immdata$imm_nostim_dprime, na.rm = TRUE)
sd(immdata$imm_nostim_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(immdata$avg_imm_stim_dprime, na.rm = TRUE)
mean_nostim<- mean(immdata$imm_nostim_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(immdata$avg_imm_stim_dprime - immdata$imm_nostim_dprime,na.rm = TRUE)
cohenD<- abs(mean_diff/sd_diff)
}

