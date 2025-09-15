import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

#This script explores different category methods to describe responder to stimulation status based on d'


#df = pd.read_csv('for_figures_sessions_imm_and_delay_stim_diff.csv') #this has only avgeraged or 1s after stim values
df = pd.read_csv('AMMEBLAES_all_firstsession.csv') #this has all the Duration and Timing specific stim values
#df = df[df["Memory_delay"] == 1].reset_index() #filtering df 
#df = df[df["study"] == "Duration"].reset_index()
#df = df[df["study"] == "Timing"].reset_index()

#df.replace(to_replace = mem_delay, value = 0.2) # for immediate delay to show up nicely on the figures
print(df.columns)
print(df)


#select stimulation parameters
#stim_dprime_diff = df['1safter_stim_dprime_diff']
stim_dprime_diff = df['avg_stim_dprime_diff']
#before_stim_diff = df['before_stimulation_dprime_diff']
#during_stim_diff = df['during_stimulation_dprime_diff']
#after_stim_diff = df['after_stimulation_dprime_diff']
#1s_stim_diff = df['1s_stimulation_dprime_diff']
#3s_stim_diff = df['3s_stimulation_dprime_diff']


#### Plot with Quartile values


#print boxplot values
median = stim_dprime_diff.median()
minimum = stim_dprime_diff.min() 
maximum = stim_dprime_diff.max() 
lower_quartile = np.percentile(stim_dprime_diff, 25) 
upper_quartile = np.percentile(stim_dprime_diff, 75) 

print("median=", median, "lowerQ=", lower_quartile, "upperQ=", upper_quartile)


# color palette as dictionary
#palette = {"female":"tab:pink",
#           "male":"tab:blue"}


#scatter plots
ax1 = sns.catplot(x="Memory_delay", y='avg_stim_dprime_diff', color = 'black', 
					 data=df, s=100, kind='swarm', height=6)

#draw horitzontal line
plt.axhline(0, ls='--', color='k')
#plt.axhline(median, ls=':', color='gray')
#plt.axhline(upper_quartile, ls='--', color='gray')
#plt.axhline(lower_quartile, ls='--', color='gray')
#plt.axhline(minimum,ls='-', color='k')
#plt.axhline(maximum,ls='-', color='k')


#format figure look
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

#ax1.set(xticklabels = [])
#ax1.set(xlabel = None)
#sns.move_legend(ax1,'upper right')
plt.ylabel("Avg stim d' difference", fontsize=15)
plt.title("AMME and BLAES first session N = 63", fontsize=15)
#lt.xlim([-0.1,0.4])
plt.tight_layout()
plt.show()
'''

#### Plot with Tercile values

#The lowest third of the data values are defined as the lowest tercile,
#the middle third of the values are the middle tercile and the upper third of the values are the upper tercile.
#For example, if you had 100 data values, the lowest tercile would contain the 1st–33rd data values, 
#the middle tercile the 34th–67th values and the upper tercile the 68th–100th values.


#print terciles
#minimum = df["avg_stim_dprime_diff"].min()
#maximum = df["avg_stim_dprime_diff"].max()

lower_tercile = np.percentile(stim_dprime_diff, 33) 
middle_tercile = np.percentile(stim_dprime_diff, 67) 
upper_tercile = np.percentile(stim_dprime_diff, 100) 
minimum = stim_dprime_diff.min() 
maximum = stim_dprime_diff.max()

print(minimum, lower_tercile, middle_tercile, upper_tercile, maximum)


# color palette as dictionary
palette = {"Original":"tab:cyan",
           "Duration":"tab:orange",
           "Timing":"tab:purple"}


#scatter plots
#sns.catplot(x="Memory Delay", y="avg_stim_dprime_diff", data=df, s=50, kind='swarm')
ax2 = sns.catplot(x="Memory_delay", y='avg_stim_dprime_diff', hue='study', palette=palette, 
						data=df, s=10, kind='swarm',height=6)

#draw horitzontal line
plt.axhline(0, ls='-', color='k')
plt.axhline(lower_tercile, ls='--', color='gray')
plt.axhline(middle_tercile, ls=':', color='gray')
plt.axhline(upper_tercile, ls='--', color='gray')
plt.axhline(minimum, ls='--', color='gray')

#format figure look
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

#ax2.set(xticklabels = [])
#ax2.set(xlabel = None)
#sns.move_legend(ax2,'upper right')
plt.ylabel("Sessions stimulation d' difference", fontsize=12)
plt.title("Terciles", fontsize=15)
#plt.xlim([-0.1,0.4])
plt.tight_layout()
plt.show()


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
ax3 = sns.catplot(x="Memory_delay", y=stim_dprime_diff, hue='hemisphere', palette=palette,
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
