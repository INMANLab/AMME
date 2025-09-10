install.packages("effectsize")
library(effectsize)
library(pastecs)

################################################
####### ALL SESSIONS ALL DELAYS ################
################################################


#### Averaged #####
#descriptive
hist(all_sessions_amyg_stim_delay$stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_delay$stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_delay$avg_stim_delay_dprime, all_sessions_amyg_stim_delay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$avg_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$avg_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(all_sessions_amyg_stim_delay$avg_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(all_sessions_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(all_sessions_amyg_stim_delay$avg_stim_delay_dprime - all_sessions_amyg_stim_delay$nostim_delay_dprime,na.rm = TRUE)
cohenD<- abs(mean_diff/sd_diff)


#### Sure Averaged #####
#descriptive
hist(all_sessions_amyg_stim_delay$sure_stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_delay$sure_stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime, all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime - all_sessions_amyg_stim_delay$sure_nostim_delay_dprime,na.rm = TRUE)
sure_cohenD<- abs(sure_mean_diff/sure_sd_diff)


#### 1s after stim #####
hist(all_sessions_amyg_stim_delay$X1s_stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_delay$X1s_stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_delay$X1s_stim_delay_dprime, all_sessions_amyg_stim_delay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$X1s_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$X1s_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(all_sessions_amyg_stim_delay$X1s_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(all_sessions_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(all_sessions_amyg_stim_delay$X1s_stim_delay_dprime - all_sessions_amyg_stim_delay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff)


#### Sure 1s after stim #####
#descriptive
hist(all_sessions_amyg_stim_delay$X1s_sure_stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_delay$X1s_sure_stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_delay$sure_1s_stim_delay_dprime, all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$sure_1s_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$sure_1s_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(all_sessions_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(all_sessions_amyg_stim_delay$avg_sure_stim_delay_dprime - all_sessions_amyg_stim_delay$sure_nostim_delay_dprime,na.rm = TRUE)
 abs(sure_mean_diff/sure_sd_diff)#Cohen's D


################################################
####### ALL SESSIONS AT 1-DAY DELAY ############
################################################

#### Averaged #####
#descriptive
hist(all_sessions_amyg_stim_nolongerdelay$stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_nolongerdelay$stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_nolongerdelay$avg_stim_delay_dprime, all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$avg_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$avg_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(all_sessions_amyg_stim_nolongerdelay$avg_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(all_sessions_amyg_stim_nolongerdelay$avg_stim_delay_dprime - all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff)#Cohen's D


#### Sure Averaged #####
#descriptive
hist(all_sessions_amyg_stim_nolongerdelay$sure_stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_nolongerdelay$sure_stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime - all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime,na.rm = TRUE)
abs(sure_mean_diff/sure_sd_diff)#Cohen's D


#### 1s after stim #####
hist(all_sessions_amyg_stim_nolongerdelay$X1s_stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_nolongerdelay$X1s_stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(all_sessions_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(all_sessions_amyg_stim_nolongerdelay$X1s_stim_delay_dprime - all_sessions_amyg_stim_nolongerdelay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff)#Cohen's D


#### Sure 1s after stim #####
#descriptive
hist(all_sessions_amyg_stim_nolongerdelay$X1s_sure_stimulation_dprime_diff)
stat.desc(all_sessions_amyg_stim_nolongerdelay$X1s_sure_stimulation_dprime_diff)

#diff between stim and no stim
t.test(all_sessions_amyg_stim_nolongerdelay$sure_1s_stim_delay_dprime, all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$sure_1s_stim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$sure_1s_stim_delay_dprime, na.rm = TRUE)
mean(all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(all_sessions_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime - all_sessions_amyg_stim_nolongerdelay$sure_nostim_delay_dprime,na.rm = TRUE)
abs(sure_mean_diff/sure_sd_diff)#Cohen's D





################################################
####### AVERAGED SESSIONS ALL DELAYS ###########
################################################

#### Averaged #####
#descriptive
hist(avg_amyg_stim_delay$stimulation_dprime_diff)
stat.desc(avg_amyg_stim_delay$stimulation_dprime_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_delay$avg_stim_delay_dprime, avg_amyg_stim_delay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_delay$avg_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$avg_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(avg_amyg_stim_delay$avg_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(avg_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(avg_amyg_stim_delay$avg_stim_delay_dprime - avg_amyg_stim_delay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff) #Cohen's D


#### Sure Averaged #####
#descriptive
hist(avg_amyg_stim_delay$sure_stim_dprime_diff)
stat.desc(avg_amyg_stim_delay$sure_stim_dprime_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_delay$avg_sure_stim_delay_dprime, avg_amyg_stim_delay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(avg_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(avg_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(avg_amyg_stim_delay$avg_sure_stim_delay_dprime - avg_amyg_stim_delay$sure_nostim_delay_dprime,na.rm = TRUE)
sure_cohenD<- abs(sure_mean_diff/sure_sd_diff)


#### 1s after stim #####
hist(avg_amyg_stim_delay$X1s_stimulation_dprim_diff)
stat.desc(avg_amyg_stim_delay$X1s_stimulation_dprim_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_delay$X1s_stim_delay_dprime, avg_amyg_stim_delay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_delay$X1s_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$X1s_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(avg_amyg_stim_delay$X1s_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(avg_amyg_stim_delay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(avg_amyg_stim_delay$X1s_stim_delay_dprime - avg_amyg_stim_delay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff)


#### Sure 1s after stim #####
#descriptive
hist(avg_amyg_stim_delay$X1s_sure_stimulation_dprim_diff)
stat.desc(avg_amyg_stim_delay$X1s_sure_stimulation_dprim_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_delay$sure_1s_stim_delay_dprime, avg_amyg_stim_delay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_delay$sure_1s_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$sure_1s_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(avg_amyg_stim_delay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(avg_amyg_stim_delay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(avg_amyg_stim_delay$avg_sure_stim_delay_dprime - avg_amyg_stim_delay$sure_nostim_delay_dprime,na.rm = TRUE)
abs(sure_mean_diff/sure_sd_diff)


################################################
####### AVERAGED SESSIONS AT 1-DAY DELAY #######
################################################

#### Averaged #####
#descriptive
hist(avg_amyg_stim_nolongerdelay$stimulation_dprime_diff)
stat.desc(avg_amyg_stim_nolongerdelay$stimulation_dprime_diff)

hist(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime)
stat.desc(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime)

hist(avg_amyg_stim_nolongerdelay$nostim_delay_dprime)
stat.desc(avg_amyg_stim_nolongerdelay$nostim_delay_dprime)

#diff between stim and no stim
t.test(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime, avg_amyg_stim_nolongerdelay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(avg_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(avg_amyg_stim_nolongerdelay$avg_stim_delay_dprime - avg_amyg_stim_nolongerdelay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff)#Cohen's D


#### Sure Averaged #####
#descriptive
hist(avg_amyg_stim_nolongerdelay$sure_stim_dprime_diff)
stat.desc(avg_amyg_stim_nolongerdelay$sure_stim_dprime_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime - avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime,na.rm = TRUE)
abs(sure_mean_diff/sure_sd_diff)#Cohen's D


#### 1s after stim #####
hist(avg_amyg_stim_nolongerdelay$X1s_stimulation_dprime_diff)
stat.desc(avg_amyg_stim_nolongerdelay$X1s_stimulation_dprime_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, avg_amyg_stim_nolongerdelay$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
mean_stim<- mean(avg_amyg_stim_nolongerdelay$X1s_stim_delay_dprime, na.rm = TRUE)
mean_nostim<- mean(avg_amyg_stim_nolongerdelay$nostim_delay_dprime, na.rm = TRUE)
mean_diff<- mean_stim - mean_nostim
sd_diff = sd(avg_amyg_stim_nolongerdelay$X1s_stim_delay_dprime - avg_amyg_stim_nolongerdelay$nostim_delay_dprime,na.rm = TRUE)
abs(mean_diff/sd_diff)#Cohen's D


#### Sure 1s after stim #####
#descriptive
hist(avg_amyg_stim_nolongerdelay$X1s_sure_stimulation_dprime_diff)
stat.desc(avg_amyg_stim_nolongerdelay$X1s_sure_stimulation_dprime_diff)

#diff between stim and no stim
t.test(avg_amyg_stim_nolongerdelay$sure_1s_stim_delay_dprime, avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$sure_1s_stim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$sure_1s_stim_delay_dprime, na.rm = TRUE)
mean(avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sd(avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)

#calc cohen's D
sure_mean_stim<- mean(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime, na.rm = TRUE)
sure_mean_nostim<- mean(avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime, na.rm = TRUE)
sure_mean_diff<- sure_mean_stim - sure_mean_nostim
sure_sd_diff = sd(avg_amyg_stim_nolongerdelay$avg_sure_stim_delay_dprime - avg_amyg_stim_nolongerdelay$sure_nostim_delay_dprime,na.rm = TRUE)
abs(sure_mean_diff/sure_sd_diff)#Cohen's D




################################################
#### ALL SESSIONS AT LONG DELAY ONLY ###########
################################################

m1<- lm(stimulation_dprime_diff ~ dummy_hemi,data = all_sessions_amyg_stim_delay,na.rm = TRUE)
summary(m1)

m2<- lm(X1s_stimulation_dprime_diff ~ dummy_hemi,data = all_sessions_amyg_stim_delay,na.rm = TRUE)
summary(m2)

m3<- lm(stimulation_dprime_diff ~ dummy_hemi,data = all_sessions_amyg_stim_nolongerdelay,na.rm = TRUE)
summary(m3)

m4<- lm(X1s_stimulation_dprime_diff ~ dummy_hemi,data = all_sessions_amyg_stim_nolongerdelay,na.rm = TRUE)
summary(m4)


################################################
#### ALL SESSIONS AT LONG DELAY ONLY ###########
################################################

#### Averaged #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)

#### Sure Averaged #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)


#### 1s after stim #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)


#### Sure 1s after stim #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)



################################################
#### AVERAGED SESSIONS AT LONG DELAY ONLY ######
################################################


#### Averaged #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)


#### Sure Averaged #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)


#### 1s after stim #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)


#### Sure 1s after stim #####
#descriptive
hist(all_amyg_stim_sessions$stimulation_dprime_diff)
stat.desc(all_amyg_stim_sessions$stimulation_dprime_diff)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)

