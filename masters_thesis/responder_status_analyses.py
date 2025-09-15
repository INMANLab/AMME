import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from scipy import stats
from scipy.stats import f_oneway, norm, uniform, kruskal, mannwhitneyu
import researchpy as rp
from statsmodels.stats.multicomp import pairwise_tukeyhsd
from statsmodels.graphics.gofplots import qqplot
import scikit_posthocs as sp



#Define the dataframe and make a boxplot.
df = pd.read_csv('for3Dplot_responder_tercilebased2.csv')
df = df.dropna()

#create a mask 
responder = df['responder_dummy'] == 1
nonresponder = df['responder_dummy'] == 0
antiresponder = df['responder_dummy'] == -1


################### FSIQ RESULTS ###################################

#Define each group for ANOVA
#create a mask 
responder = df['responder_dummy'] == 1
nonresponder = df['responder_dummy'] == 0
antiresponder = df['responder_dummy'] == -1

#filter df by the mask
resp_FSIQ = df[responder]
nresp_FSIQ = df[nonresponder]
anresp_FSIQ  = df[antiresponder]
#print(resp_FSIQ)

#create ANOVA variables
resp_FSIQ = resp_FSIQ['FSIQ']
nresp_FSIQ = nresp_FSIQ['FSIQ']
anresp_FSIQ = anresp_FSIQ['FSIQ']

#print(resp_FSIQ)
#print(nresp_FSIQ)
#print(anresp_FSIQ)

#checking normality: if p < 0.05 then not normally distributed data
shapiro = stats.shapiro(df['FSIQ'])
print(shapiro)

#checking homogeneity of variance: if p < 0.05 then the sample is heterogeneous
levene = stats.levene(resp_FSIQ, anresp_FSIQ)
print(levene)

#checking distribution normality 
fig, axs = plt.subplots(1, 1, figsize =(10, 7), tight_layout = True)
axs.hist(df['FSIQ'])
plt.xlabel("FSIQ")
plt.show()

#checking normality assumption with QQ plot: if not close to the line it's not normally distributed
plt.rcParams['figure.figsize'] = [10, 7]
plt.rc('font', size=14)
qqplot(df['FSIQ'],norm,fit=True,line="45")
plt.show()



#perform ANOVA
fvalue, pvalue = stats.f_oneway(resp_FSIQ, nresp_FSIQ, anresp_FSIQ)
print('ANOVA')
print(fvalue, pvalue)

#run post-hoc test
tukey = pairwise_tukeyhsd(endog=df['FSIQ'],
                          groups=df['responder_status'],
                          alpha=0.05)

print(tukey)

#independent t-test
summary, results= rp.ttest(resp_FSIQ, anresp_FSIQ)
print('t-test resp vs antiresp') 
print(summary, results)

summary, results= rp.ttest(resp_FSIQ, nresp_FSIQ)
print('t-test resp vs nonresp') 
print(summary, results)

summary, results= rp.ttest(nresp_FSIQ, anresp_FSIQ)
print('t-test nonresp vs antiresp') 
print(summary, results)


# color palette as dictionary
palette = {"Original":"tab:cyan",
           "Duration":"tab:orange", 
           "Timing":"tab:purple"}


sns.barplot(data = df, x = 'responder_status', y = 'FSIQ', palette='Greens', ci=95)
sns.stripplot(data = df, x = 'responder_status', y = 'FSIQ', hue= 'Experiment', size=9, palette=palette)
plt.title('FSIQ by Responder Status and Experiment')
plt.ylim([df['FSIQ'].min()-5, df['FSIQ'].max()+5])
plt.show()


'''
################### RAVLT RESULTS ###################################


#filter df by the mask
resp_RAVLT = df[responder]
nresp_RAVLT = df[nonresponder]
anresp_RAVLT  = df[antiresponder]

#create variables
resp_RAVLT = resp_RAVLT['RAVLT_dprime']
nresp_RAVLT= nresp_RAVLT['RAVLT_dprime']
anresp_RAVLT = anresp_RAVLT['RAVLT_dprime']

print(resp_RAVLT)
print(nresp_RAVLT)
print(anresp_RAVLT)

#checking sample independence 
shapiro = stats.shapiro(df['RAVLT_dprime'])
print(shapiro)

#checking homogeneity of variance
levene = stats.levene(resp_RAVLT, anresp_RAVLT)
print(levene)

#checking distribution normality 
fig, axs = plt.subplots(1, 1, figsize =(10, 7), tight_layout = True)
axs.hist(df['RAVLT_dprime'])
plt.xlabel("RAVLT d' scores")
plt.show()


#checking normality assumption
plt.rcParams['figure.figsize'] = [10, 7]
plt.rc('font', size=14)
qqplot(df['RAVLT_dprime'],norm,fit=True,line="45")
plt.show()


#ANOVA
#fvalue, pvalue = stats.f_oneway(resp_RAVLT, nresp_RAVLT, anresp_RAVLT)
statistic, pvalue = stats.kruskal(resp_RAVLT, nresp_RAVLT, anresp_RAVLT)
print('ANOVA')
print(statistic, pvalue)

#perform non-parametric post hoc test
summary= sp.posthoc_dunn([resp_RAVLT, nresp_RAVLT, anresp_RAVLT], p_adjust = 'sidak')
print(summary)


#independent t-test
statistic, pvalue = stats.mannwhitneyu(resp_RAVLT, anresp_RAVLT)
print('Mann-Whitney t-test resp vs antiresp') 
print(statistic, pvalue)

statistic, pvalue = stats.mannwhitneyu(resp_RAVLT, nresp_RAVLT)
print('Mann-Whitney t-test resp vs nonresp') 
print(statistic, pvalue)

statistic, pvalue = stats.mannwhitneyu(nresp_RAVLT, anresp_RAVLT)
print('Mann-Whitney t-test nonresp vs antiresp') 
print(statistic, pvalue)



# color palette as dictionary
palette = {"Original":"tab:cyan",
           "Duration":"tab:orange", 
           "Timing":"tab:purple"}


sns.barplot(data = df, x = 'responder_status', y = 'RAVLT_dprime', palette='Greens', ci=95)
sns.swarmplot(data = df, x = 'responder_status', y = 'RAVLT_dprime', hue= 'Experiment', size=9, palette=palette)
plt.title('RAVLT Dprime by Responder Status and Experiment')
plt.ylim([df['RAVLT_dprime'].min()-1, df['RAVLT_dprime'].max()+5])
plt.show()



################### AGE RESULTS ###################################


#filter df by the mask
resp_age = df[responder]
nresp_age = df[nonresponder]
anresp_age = df[antiresponder]

#create ANOVA variables
resp_age = resp_age['age']
nresp_age= nresp_age['age']
anresp_age = anresp_age['age']

print(resp_age)
print(nresp_age)
print(anresp_age)


#checking sample independence 
shapiro = stats.shapiro(df['age'])
print(shapiro)

#checking homogeneity of variance
levene = stats.levene(resp_age, anresp_age)
print(levene)

#checking distribution normality 
fig, axs = plt.subplots(1, 1, figsize =(10, 7), tight_layout = True)
axs.hist(df['age'])
plt.xlabel("Age")
plt.show()

#checking normality assumption wiht QQ plot
plt.rcParams['figure.figsize'] = [10, 7]
plt.rc('font', size=14)
qqplot(df['age'],norm,fit=True,line="45")
plt.show()


#ANOVA
statistic, pvalue = stats.kruskal(resp_age, nresp_age, anresp_age)
print('ANOVA')
print(statistic, pvalue)

#post hoc test
summary= sp.posthoc_dunn([resp_age, nresp_age, anresp_age], p_adjust = 'sidak')
print(summary)


#independent t-test
summary, results = stats.mannwhitneyu(resp_age, anresp_age)
print('Mann-Whitney t-test resp vs antiresp') 
print(summary, results)

summary, results = stats.mannwhitneyu(resp_age, nresp_age)
print('Mann-Whitney t-test resp vs nonresp') 
print(summary, results)

summary, results = stats.mannwhitneyu(nresp_age, anresp_age)
print('Mann-Whitney t-test nonresp vs antiresp') 
print(summary, results)

# color palette as dictionary
palette = {"Original":"tab:cyan",
           "Duration":"tab:orange", 
           "Timing":"tab:purple"}


sns.barplot(data = df, x = 'responder_status', y = 'age', palette='Greens', ci=95)
sns.stripplot(data = df, x = 'responder_status', y = 'age', hue= 'Experiment', size=9, palette=palette)
plt.title('Age by Responder Status and Experiment')
plt.ylim([df['age'].min()-3, df['age'].max()+20])
plt.show()


################# SEX differences ##################### -fix!

sns.barplot(data = df, x = None, y = 'responder', hue= 'sex', palette='Greens', ci=95)
plt.title('FSIQ by Responder Status and Experiment')
plt.show()
'''

