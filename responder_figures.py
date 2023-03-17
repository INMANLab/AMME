import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

#This script explores different category methods to describe responder to stimulation status based on d'


## Plot with Quartile values

df = pd.read_csv('for_figures_sessions_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] == 1].reset_index() #filtering df 
#mem_delay = df["Memory Delay"]
#df.replace(to_replace = mem_delay, value = 0.2)
print(df["Memory Delay"])

#your input data
#stim_dprime_diff = df['1safter_stim_dprime_diff'] #for 1s after stim averaged
stim_dprime_diff = df['avg_stim_dprime_diff']

'''
#print boxplot values
median = stim_dprime_diff.median() #0.076761805
minimum = stim_dprime_diff.min() #-0.292187753
maximum = stim_dprime_diff.max() #0.84
lower_quartile = np.percentile(stim_dprime_diff, 25) #-0.0191445330
upper_quartile = np.percentile(stim_dprime_diff, 75) #0.19

print(median, lower_quartile, upper_quartile)


# color palette as dictionary
palette = {"L":"tab:cyan",
           "R":"tab:orange", 
           "bilateral":"tab:purple"}


#scatter plots
ax1 = sns.catplot(x="Memory Delay", y=stim_dprime_diff, hue='hemisphere', palette=palette,
					 data=df, s=80, kind='swarm', height=6)

#draw horitzontal line
plt.axhline(0, ls='-', color='k')
plt.axhline(median, ls=':', color='gray')
plt.axhline(upper_quartile, ls='--', color='gray')
plt.axhline(lower_quartile, ls='--', color='gray')


#format figure look
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

#ax1.set(xticklabels = [])
#ax1.set(xlabel = None)
sns.move_legend(ax1,'upper right')
plt.ylabel("Sessions stimulation d' difference", fontsize=15)
plt.title("Quartiles", fontsize=15)
#lt.xlim([-0.1,0.4])
plt.tight_layout()
plt.show()
'''

# Plot with Tercile values

#The lowest third of the data values are defined as the lowest tercile,
#the middle third of the values are the middle tercile and the upper third of the values are the upper tercile.
#For example, if you had 100 data values, the lowest tercile would contain the 1st–33rd data values, 
#the middle tercile the 34th–67th values and the upper tercile the 68th–100th values.


#print terciles
#minimum = df["avg_stim_dprime_diff"].min()
#maximum = df["avg_stim_dprime_diff"].max()

lower_quartile = np.percentile(stim_dprime_diff, 33) 
middle_quartile = np.percentile(stim_dprime_diff, 67) 
upper_quartile = np.percentile(stim_dprime_diff, 100) 
minimum = stim_dprime_diff.min() 
maximum = stim_dprime_diff.max()

print(minimum, lower_quartile, middle_quartile, upper_quartile, maximum)


# color palette as dictionary
palette = {"Duration":"tab:cyan",
           "Timing":"tab:orange", 
           "Original":"tab:purple"}


#scatter plots
#sns.catplot(x="Memory Delay", y="avg_stim_dprime_diff", data=df, s=50, kind='swarm')
ax2 = sns.catplot(x="Memory Delay", y=stim_dprime_diff, hue='study', palette=palette, 
						data=df, s=100, kind='swarm',height=6)

#draw horitzontal line
plt.axhline(0, ls='-', color='k')
plt.axhline(lower_quartile, ls='--', color='gray')
plt.axhline(middle_quartile, ls=':', color='gray')
plt.axhline(upper_quartile, ls='--', color='gray')

#format figure look
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

#ax2.set(xticklabels = [])
#ax2.set(xlabel = None)
sns.move_legend(ax2,'upper right')
plt.ylabel("Sessions stimulation d' difference", fontsize=12)
plt.title("Terciles", fontsize=15)
#plt.xlim([-0.1,0.4])
plt.tight_layout()
plt.show()

'''
# Plot with Min and Max values

stim_dprime_diff = df['avg_stim_dprime_diff']

#print boxplot values for all AMME 1-day delay data (avgeraged)
#median = df["avg_stim_dprime_diff"].median()
mean = stim_dprime_diff.mean() #0.10254631203225806
minimum = stim_dprime_diff.min() #-0.292187753
maximum = stim_dprime_diff.max() #0.84

print(minimum, maximum, mean)


# color palette as dictionary
palette = {"L":"tab:cyan",
           "R":"tab:orange", 
           "bilateral":"tab:purple"}


#scatter plots
ax3 = sns.catplot(x="Memory Delay", y=stim_dprime_diff, hue='hemisphere', palette=palette,
				 data=df, s=80, kind='swarm',height=6)

#draw horitzontal line
plt.axhline(0, ls='-', color='k')
plt.axhline(mean, ls=':', color='gray')
plt.axhline(minimum, ls='--', color='gray')
plt.axhline(maximum, ls='--', color='gray')



#format figure look
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

#ax3.set(xticklabels = [])
#ax3.set(xlabel = None)
#plt.xlim([-0.1,0.4])
sns.move_legend(ax3,'upper right')
plt.ylabel("Sessions stimulation d' difference", fontsize=12)
plt.title("Min, Mean, and Max values", fontsize=15)
plt.tight_layout()
plt.show()
'''
