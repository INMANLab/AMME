import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle



# SCATTERPLOT - Participant avg for dprime difference over time - group means

df = pd.read_csv('avg_all_amyg_stim.csv')

# print(df.columns)

# Get the mean by grouping by the following two columns
avgs = df.groupby(['stimulation_dprime_diff', 'Patient']).mean()
# This removes the index and places them as columns (Identity/Participant)
avgs = avgs.reset_index()

print(avgs) 

# Create a new figure
plt.figure()
# Plot stuff
ax = sns.scatterplot(x="Memory Delay", y="stimulation_dprime_diff",
                   data=avgs, s=100)
# Set Title
#plt.figure(figsize = (10,10))
plt.title("Omnibus d' difference between stim and no stim over time")
#ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), title = "Patient")
#fig, ax = plt.subplots(constrained_layout = False)
ax.set_xlabel("Memory delay (days)")
ax.set_ylabel("Difference in d' between stim and no stim")
plt.ylim([-.5,.5])
plt.xlim([0,13])
plt.tight_layout()
# Show the figure (need this otherwise you will plot something else it will plot on top)
plt.show()
#plt.savefig()


'''

# SWARMPLOT WITH JITTER Imm and Delay Stim dprime diff - visualize each dot

df = pd.read_csv('for_figures_avg_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] == 1].reset_index() #filtering df to show no imm test

#your input data
#stim_dprime_diff = df['avg_stim_dprime_diff'] #for averaged
stim_dprime_diff = df['avg_stim_dprime_diff']

#print boxplot values for all AMME 1-day delay data (avgeraged)
median = df["avg_stim_dprime_diff"].median() #0.076761805
minimum = df["avg_stim_dprime_diff"].min() #-0.292187753
maximum = df["avg_stim_dprime_diff"].max() #0.84
lower_quartile = np.percentile(df["avg_stim_dprime_diff"], 25) #-0.0191445330
upper_quartile = np.percentile(df["avg_stim_dprime_diff"], 75) #0.19

print(median, lower_quartile, upper_quartile)


# color palette as dictionary
palette = {"Original":"tab:cyan",
           "Duration":"tab:orange", 
           "Timing":"tab:purple"}


#scatter plots
#plt.figure()
#sns.catplot(x="Memory Delay", y="avg_stim_dprime_diff", data=df, s=50, kind='swarm')
sns.catplot(x="Memory Delay", y="avg_stim_dprime_diff", hue='study', palette=palette, data=df, s=10, kind='swarm', legend=None)

#draw horitzontal line
plt.axhline(0, ls='-', color='k')
plt.axhline(median, ls=':', color='gray')
plt.axhline(upper_quartile, ls=':', color='blue')
plt.axhline(lower_quartile, ls=':', color='green')



#format figure look
plt.legend(loc='upper right')
#plt.xticks(0.5, 'One-day Memory Delay', fontsize=15)
plt.ylabel("Avg difference in d' between stim and no stim", fontsize=12)
#plt.title("1s after d' difference between stim and no stim over time", fontsize=15)
#plt.ylim([-.5,.5])
#plt.yticks(np.arange(-.5,.5, step=.1))
plt.tight_layout()
plt.xlim([-.15,.25])
plt.xlabel(None)
plt.show()



# CONNECTED DOT PLOT - aka parallel axis dor plot for paired samples

df = pd.read_csv('for_figures_avg_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] == 1].reset_index() #filtering and overwriting df

# print(df.columns)

# your input data:
stim = df["avg_stim"]
nostim = df["nostim"]

# plotting the points
plt.scatter(np.zeros(len(nostim)), nostim, marker='o', c='blue') #plotting the dots
plt.scatter(np.ones(len(stim)), stim, marker='o', c='red')

# plotting the lines
for i in range(len(stim)):
    if df["Memory Delay"].values[i] > 1: #.values compare it to the values in the col 
        plt.plot( [0,1], [nostim[i], stim[i]], c='k', alpha = .3) #x is [0,1] and y is [nostim and stim], c = color
        plt.annotate(int(df["Memory Delay"].values[i]),[1.05, stim[i]], fontsize=8) #format annotate(text,xy) where xy are coordinates                                                                              
    else:
        plt.plot( [0,1], [nostim[i], stim[i]], c='k', ls='-') #alpha=.3 changes transparency

#removes the graph frame's top and right side
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

plt.xticks([0,1], ['NoStim', 'Stim'], fontsize=15)
plt.xlim([-0.5,1.5])
plt.ylabel("d'", fontsize = 20)
plt.title("1-day", fontsize=15)
plt.yticks(np.arange(0,5.2, step=1), fontsize=20) #stepsize helps to get more yticks
plt.ylim([0,5.2])
#plt.tight_layout()
plt.show()



# OVERLAPPING HISTOGRAMS plots of averaged stim and no stim at delay

cmap = plt.get_cmap('jet')
stimcolor=cmap(0.20)
nostimcolor=cmap(0.85)

df = pd.read_csv('for_figures_avg_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] == 1].reset_index() #filter df to get only 1-day delay

# your input data:
stim = df["avg_stim"]
nostim = df["nostim"]

#need to control the bin size!
sns.histplot(data=df, x="avg_stim", color = stimcolor, alpha = 0.5)
sns.histplot(data=df, x="nostim", color = nostimcolor, alpha = 0.5)
labels=["stim", "nostim"]
handles=[Rectangle((0,0),1,1,color=c, alpha = 0.5) for c in [stimcolor, nostimcolor]]
plt.legend(handles,labels)
plt.title("Historgam of Averaged Stim and NoStim d'scores at 1-day delay")
plt.xlabel("D' score")
plt.xlim([0,3])

plt.show()



# OVERLAPPING HISTOGRAMS plots of 1s after stim and no stim at delay

cmap = plt.get_cmap('jet')
stimcolor=cmap(0.20)
nostimcolor=cmap(0.85)

df = pd.read_csv('for_figures_avg_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] == 1].reset_index() #filter df to get only 1-day delay 
# your input data:
stim = df["1safterstim"]
nostim = df["nostim"]

sns.histplot(data=df, x="1safterstim", color = stimcolor, alpha = 0.5)
sns.histplot(data=df, x="nostim", color = nostimcolor, alpha = 0.5)
labels=["stim", "nostim"]
handles=[Rectangle((0,0),1,1,color=c, alpha = 0.5) for c in [stimcolor, nostimcolor]]
plt.legend(handles,labels)
plt.title("Historgam of 1s after Stim and NoStim d'scores at 1-day delay")
plt.xlabel("D' score")
plt.xlim([0,3.2])

plt.show()



# BOXPLOT of averaged stim 1day delay

#read in data
df = pd.read_csv('for_figures_avg_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] == 1].reset_index() #filter df to get only 1-day delay 
#df = df[df["study"] == "Original"].reset_index() #filter out study type

#plotting
sns.boxplot(x=df["study"], y=df["avg_stim_dprime_diff"], width = .5, palette="Blues")
sns.stripplot(x=df["study"], y=df["avg_stim_dprime_diff"], alpha=.7, color="black")
plt.ylabel("Averaged stimulation d' difference at imm test",fontsize = 14)
#plt.yticks(np.arange(-.3,.5, step=.1))
#plt.title("Averaged stimulation d' diff at delay", fontsize=16)

#removes the graph frame's top and right side
for pos in ['right', 'top']:
   plt.gca().spines[pos].set_visible(False)

plt.show()

#print boxplot values for all AMME 1-day delay data (avgeraged)
median = df["avg_stim_dprime_diff"].median() #0.076761805
minimum = df["avg_stim_dprime_diff"].min() #-0.292187753
maximum = df["avg_stim_dprime_diff"].max() #0.84
lower_quartile = np.percentile(df["avg_stim_dprime_diff"], 25) #-0.0191445330
upper_quartile = np.percentile(df["avg_stim_dprime_diff"], 75) #0.19

print(median, lower_quartile, upper_quartile)
#[item.get_ydata() for item in B['upper quartile']]
#print(item)





# BOXPLOT of 1s after stim 1day delay

#read in data
df = pd.read_csv('for_figures_avg_imm_and_delay_stim_diff.csv')
df = df[df["Memory Delay"] != 0].reset_index() #filter df to get only 1-day delay 

#plotting
bp = sns.boxplot(y=df["1safter_stim_dprime_diff"], width = .3, color="skyblue")
sns.stripplot(y=df["1safter_stim_dprime_diff"], c="black", alpha=.7)
plt.ylabel("1s after stimulation d' difference",fontsize = 14)
plt.yticks(np.arange(-.4,1, step=.1))
plt.title("1s after stimulation d' diff at delay", fontsize = 16)
plt.show()

median = df["1safter_stim_dprime_diff"].median() #0.07394905
minimum = df["1safter_stim_dprime_diff"].min() #-0.29218778
maximum = df["1safter_stim_dprime_diff"].max() #0.84

print(median, minimum, maximum)




# Removing outliers and rerunning the scatter plots

#df2 = pd.read_csv('data.csv').dropna()
#print(df2['RT'].describe())

#Get the mean by grouping by the following two columns
#avgs = df2.groupby(['Identity', 'Participant']).mean()
# This removes the index and places them as columns (Identity/Participant)
#avgs = avgs.reset_index()

#print(avgs) 

# Create a new figure
#plt.figure()
# Plot stuff
#ax = sns.pointplot(x="Identity", y="RT", hue="Participant",
 #                  data=avgs, ci=None)
# Set Title
# plt.title("Title")
# plt.ylim([df2['RT'].min(), df2['RT'].max()])
# Show the figure (need this otherwise you will plot something else it will plot on top)
# plt.show()
# plt.savefig('Fig_RT_no_outliers.png')

 #Get the mean by grouping by the following two columns
#avgs = df.groupby(['Identity', 'Participant + Set']).mean()
# This removes the index and places them as columns (Identity/Participant)
#avgs = avgs.reset_index()

 #print(avgs) 

# Create a new figure
# plt.figure()
 # Plot stuff
#ax = sns.pointplot(x="Identity", y="RT", hue="Participant + Set",
    #                data=avgs, ci=None)
 # Set Title
#plt.title("Title")
 #plt.ylim([df['RT'].min(), df['RT'].max()])
#ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), title = "Participants and Sessions")
#plt.tight_layout()
# Show the figure (need this otherwise you will plot something else it will plot on top)
#plt.show()
# plt.savefig('Fig_RT_no_outliers2.png')


