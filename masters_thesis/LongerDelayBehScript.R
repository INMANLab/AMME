t.test(dprime_stim_delay ~ dprime_nostim_delay,data = mydata, na.rm = "TRUE", alternative = "two.sided")
t.test(mydata$d_during_sure, mydata$d_nostim_sure, paired = TRUE, alternative = "two.sided")
t.test(mydata$d_during_sure, mydata$d_nostim_sure, paired = TRUE, alternative = "two.sided")

#AMME Timing analyses of longer than 1 day
lm(Perc_Corr_Stim ~ Memory.Delay, data = mydata)
lm(formula = Perc_Corr_Stim_Sure ~ Memory.Delay, data = mydata)

lm(formula = d_stim ~ Memory.Delay, data = mydata)
lm(formula = d_stim_sure ~ Memory.Delay, data = mydata)

t.test(mydata$d_stim_sure, mydata$d_nostim_sure, paired = TRUE, alternative = "two.sided")




#AMME Timing 1 day vs. longer than 1 day in PNAS data
t.test(mydata$dprime_stim_delay, mydata$dprime_nostim_delay, paired = TRUE, alternative = "two.sided", na.rm = "TRUE")
mean(mydata$dprime_stim_delay, na.rm = "TRUE")
mean(mydata$dprime_nostim_delay, na.rm = "TRUE")

t.test(mydata$dprime_sure_stim_delay, mydata$dprime_nostim_sure_delay, paired = TRUE, alternative = "two.sided", na.rm = "TRUE")
mean(mydata$dprime_sure_stim_delay, na.rm = "TRUE")
mean(mydata$dprime_nostim_sure_delay, na.rm = "TRUE")

t.test(mydata$dprime_stim_delay, mydata$dprime_sure_stim_delay, paired = TRUE, alternative = "two.sided", na.rm = "TRUE")
mean(mydata$dprime_stim_delay, na.rm = "TRUE")
mean(mydata$dprime_sure_stim_delay, na.rm = "TRUE")

t.test(mydata$dprime_nostim_delay, mydata$dprime_nostim_sure_delay, paired = TRUE, alternative = "two.sided", na.rm = "TRUE")
mean(mydata$dprime_nostim_delay, na.rm = "TRUE")
mean(mydata$dprime_nostim_sure_delay, na.rm = "TRUE")

library(dplyr)
library(ggplot2)
ggplot(mydata,aes(x = dprime_sure_stim_delay, y = dprime_nostim_sure_delay))+geom_point()+stat_smooth(method="lm",se=F)+annotate("text",x=1,y=4,label=(paste("slope==",m2$coefficients[2])),parse=TRUE)

m3<- lm(dprime_stim_diff ~ mem.delay,data = mydata)
summary(m3)
ggplot(mydata,aes(x = mem.delay, y = dprime_stim_diff))+geom_point()+stat_smooth(method="lm",se=F)+annotate("text",x=5,y=4,label=(paste("slope==",m2$coefficients[2])),parse=TRUE)

m4<- lm(dprime_sure_stim_diff ~ mem.delay,data = mydata, na.rm = "TRUE")
summary(m4)
ggplot(mydata,aes(x = mem.delay, y = dprime_sure_stim_diff))+geom_point()+stat_smooth(method="lm",se=F)+annotate("text",x=5,y=4,label=(paste("slope==",m2$coefficients[2])),parse=TRUE)




##############################################
#### delay and stim test including AMME duration, AMME timing, and PNAS data #####

#stim vs no stim delay diff
t.test(All_AMME_data$stim_delay_dprime,All_AMME_data$nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = "TRUE")
mean(All_AMME_data$stim_delay_dprime, na.rm = TRUE)
sd(All_AMME_data$stim_delay_dprime, na.rm = TRUE)
mean(All_AMME_data$nostim_delay_dprime, na.rm = TRUE)
sd(All_AMME_data$nostim_delay_dprime, na.rm = TRUE)

#stim vs no stim sure delay diff
t.test(All_AMME_data$sure_stim_delay_dprime,All_AMME_data$sure_nostim_delay_dprime, paired = TRUE, alternative = "two.sided", na.rm = "TRUE")
mean(All_AMME_data$sure_stim_delay_dprime, na.rm = TRUE)
sd(All_AMME_data$sure_stim_delay_dprime, na.rm = TRUE)
mean(All_AMME_data$sure_nostim_delay_dprime, na.rm = TRUE)
sd(All_AMME_data$sure_nostim_delay_dprime, na.rm = TRUE)

m1<- lm(stimulation_dprime_diff ~ mem.delay,data = All_AMME_data)
summary(m1)
ggplot(alldata,aes(x = alldata$Memory.Delay, y = alldata$delay_dprime_diff))+geom_point()+stat_smooth(method="lm",se=F)+annotate("text",x=5,y=4,label=(paste("slope==",m1$coefficients[2])),parse=TRUE)

m2<- lm(sure_stimulation_dprime_diff ~ Memory.Delay,data = AMME_timing_PNAS_data)
summary(m2)
ggplot(alldata,aes(x = Memory.Delay, y = sure_delay_dprime_diff))+geom_point()+stat_smooth(method="lm",se=F)+annotate("text",x=5,y=4,label=(paste("slope==",m2$coefficients[2])),parse=TRUE)

install.packages("effectsize")
library(effectsize)
cohens_d(All_AMME_data$stim_delay_dprime ~ All_AMME_data$nostim_delay_dprime, paired = TRUE)
cohens_d(stimulation_dprime_diff ~ mem.delay,data = All_AMME_data)
levels(AMME_timing_PNAS_data$stim_delay_dprime)




##############################################

m3<- lm(stim_delay_dprime ~ Memory.Delay,data = alldata)
summary(m3)

m4<- lm(sure_stim_delay_dprime ~ Memory.Delay,data = alldata)
summary(m4)

m5<- lm(nostim_delay_dprime ~ Memory.Delay,data = alldata)
summary(m5)

m6<- lm(sure_nostim_delay_dprime ~ Memory.Delay,data = alldata)
summary(m6)

#treating memory delay as a categorical variable (dummy coded)
m7<- lm(stimulation_dprime_diff ~ mem.delay,data = alldata)
summary(m7)

m8<- lm(stim_delay_dprime ~ mem.delay,data = alldata)
summary(m8)

##############################################
Descriptives

hist(AMME_timing_PNAS_data$stimulation_dprime_diff)


