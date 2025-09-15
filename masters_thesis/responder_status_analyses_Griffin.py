import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import scipy as stats
from scipy import stats
from scipy.stats import f_oneway

#Define the dataframe and make a boxplot.
df = pd.read_csv('stim_anti-and-responder_tercile-based_avg-GRIFFIN.csv',
                 usecols = ['avg_responder_status', 'avg_stim_dprime_diff'])
sns.boxplot(data = df, x = 'avg_responder_status', y = 'avg_stim_dprime_diff')
plt.title('Average Stimulation Dprime by Responder Status')
plt.tight_layout()
plt.show()

#Defining each of the three groups for ANOVA analysis manually, reading in the dprime column of the spreadsheet
#and manually skipping the rows for the other groups.
responder = pd.read_csv('stim_anti-and-responder_tercile-based_avg-GRIFFIN.csv', usecols = ['avg_stim_dprime_diff'],
                        skiprows = range(11, 31))
nonresponder = pd.read_csv('stim_anti-and-responder_tercile-based_avg-GRIFFIN.csv',
                           usecols = ['avg_stim_dprime_diff'], skiprows = list(range(1, 10)) + list(range(24, 31)))
antiresponder = pd.read_csv('stim_anti-and-responder_tercile-based_avg-GRIFFIN.csv',
                            usecols = ['avg_stim_dprime_diff'], skiprows = range(1, 23))

#Run/print the ANOVA.
fvalue, pvalue = stats.f_oneway(responder, nonresponder, antiresponder)
print('ANOVA')
print(fvalue, pvalue)

#Run/print the post-hoc tests.
print('Post-Hoc tests, alpha = 0.017.')
RA = stats.ttest_ind(a = responder, b = antiresponder, equal_var = True)
print('Responder vs Antiresponder:')
print(RA)

RN = stats.ttest_ind(a = responder, b = nonresponder, equal_var = True)
print('Responder vs Nonresponder:')
print(RN)

AN = stats.ttest_ind(a = antiresponder, b = nonresponder, equal_var = True)
print('Antiresponder vs Nonresponder:')
print(AN)
