### this script compares basic neuropsych scores at the 1-day delay
### for stimulation responders vs anti-responders based on quartile cutoffs
library(pastecs)
install.packages("dplyr")
library(dplyr)


#checking distribution and stats
hist(mydata$FSIQ)
stat.desc(mydata$FSIQ)

hist(mydata$RAVLT_dprime)
stat.desc(mydata$RAVLT_dprime)

hist(mydata$age)
stat.desc(mydata$age)

hist(mydata$avg_stim_dprime_diff)
stat.desc(mydata$avg_stim_dprime_diff)

#checking normality assumptions of regression & t-test
#if the p-value is greater than 0.5 then the normality assumption is obtained
shapiro.test(mydata$FSIQ) #borderline
shapiro.test(mydata$RAVLT_dprime) #ok
shapiro.test(mydata$age) #not normal
shapiro.test(mydata$avg_stim_dprime_diff) #not normal

#create intercept GLM models and extract the residual 
m1<- lm(avg_stim_dprime_diff ~ 1,data = mydata)
summary(m1)
resm1<-resid(m1)

m2<- lm(RAVLT_dprime ~ 1,data = mydata)
summary(m2)
resm2<-resid(m2)

m3<- lm(age ~ 1,data = mydata)
summary(m3)
resm3<-resid(m3)

m4<- lm(FSIQ ~ 1,data = mydata)
summary(m4)
resm4<-resid(m4)

#create Q-Q plot for residuals - if dots aligns at the line visually, it's normally distributed
qqnorm(resm1) #borderline ok
qqline(resm1) 

qqnorm(resm2)
qqline(resm2) #ok

qqnorm(resm3)
qqline(resm3) #borderline ok

qqnorm(resm4) #ok
qqline(resm4) 

#create density plot - if roughly bell shaped, then it's normally distributed
plot(density(resm1)) #ok
plot(density(resm2)) #ok
plot(density(resm3)) #not sure
plot(density(resm4)) #ok


#produce residual vs. fitted plot, if data points look normally distributed then ok
plot(fitted(m1), resm1)
abline(0,0)#add a horizontal line at 0 
plot(resm1)
plot(mydata$avg_stim_dprime_diff, resm1, 
      ylab="Residuals", xlab="Dprime")
abline(0,0)


plot(fitted(m2), resm2)
abline(0,0)
plot(resm2)
plot(mydata$RAVLT_dprime, resm2, 
     ylab="Residuals", xlab="RAVLT dprime")
abline(0,0)


plot(fitted(m3), resm3)
abline(0,0)
plot(resm3)
plot(mydata$age, resm3, 
     ylab="Residuals", xlab="age")
abline(0,0)


plot(fitted(m4), resm4)
abline(0,0)plot(resm4)
plot(resm4)
plot(mydata$FSIQ, resm4, 
     ylab="Residuals", xlab="FSIQ")
abline(0,0)



