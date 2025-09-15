install.packages("effectsize")
library(effectsize)
library(pastecs)

### THIS SCRIPT LOOKS AT IMMEDIATE TEST AND 1-DAY TEST D' DIFFERENCES

immdata = immediate_stim_data$imm_stimulation_dprim_diff
hist(immdata)
stat.desc(immdata)

onedaydata = avg_amyg_stim_nolongerdelay$stimulation_dprime_diff
hist(onedaydata)
stat.desc(onedaydata)

var.test(immdata, onedaydata)

#diff between imm and 1day
#t.test(immdata, onedaydata, paired = TRUE, alternative = "two.sided", na.rm = TRUE, var.equal = TRUE)
t.test(immdata, onedaydata, var.equal = TRUE, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(immdata, na.rm = TRUE)
sd(immdata, na.rm = TRUE)
mean(onedaydata, na.rm = TRUE)
sd(onedaydata, na.rm = TRUE)

#calc cohen's D
mean_imm<- mean(immdata, na.rm = TRUE)
mean_oneday<- mean(onedaydata, na.rm = TRUE)
mean_diff<- mean_imm - mean_oneday
sd_diff = sd(immdata - onedaydata,na.rm = TRUE)
cohenD<- abs(mean_diff/sd_diff)