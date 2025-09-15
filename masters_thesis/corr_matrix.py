import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats.stats import pearsonr
from scipy import stats

#read in the datafile and specify which columns you want to work with
df = pd.read_csv('AMME_for_python.csv', dtype = float, usecols = ['Age', 'FSIQ',
				'stimulation_dprime_diff', 'sure_stimulation_dprime_diff'])

#Filter out the dataframe with specific values
#df = df[df["Memory Delay"] == 1].reset_index()
#print(df)

#plotting binary Pearson correlations showing the scatterplots
sns.pairplot(df[['FSIQ', 'Age','stimulation_dprime_diff','sure_stimulation_dprime_diff']], 
				kind="reg")
plt.show()

#run the corr matrix
corr_matrix = df.corr()
print(corr_matrix)

c_matrix = np.ones(corr_matrix.shape)
p_matrix = np.ones(corr_matrix.shape)
#mark with a * the significant correlations at p < .05
for col in df.columns:
	for col2 in df.columns:
		if col == col2:
			continue
		tempdf = df[[col, col2]].dropna()
		p = stats.pearsonr(tempdf[col].values, tempdf[col2].values)
		row_idx = df.columns.to_list().index(col)
		col_idx = df.columns.to_list().index(col2)
		print(p[1], col, col2)
		p_matrix[row_idx,col_idx] = p[1]
		c_matrix[row_idx,col_idx] = p[0]

p_matrix = pd.DataFrame(p_matrix, index = df.columns, columns = df.columns)

#plot the corr matrix
plt.subplots(figsize=(12, 10)) #set's up matplotlib plot configuration
cmap = sns.diverging_palette(230, 20, as_cmap=True) #creates a color map
#creates a mask to erase the top right of the corr matrix
#mask = np.triu(np.ones_like(corr_matrix, dtype=bool))
sns.heatmap(corr_matrix, annot=True, vmin = -1, vmax = 1, cmap = cmap)
plt.title("correlation matrix")
plt.show()

#plotting the p-values
plt.subplots(figsize=(12, 10))
sns.heatmap(p_matrix, annot=True, cmap = cmap)
plt.title("p-values for corr_matrix")
plt.show()


input()