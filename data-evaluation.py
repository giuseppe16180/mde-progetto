# %%

from os import error
import seaborn as sn
from numpy.core.fromnumeric import size
from statsmodels.stats.multicomp import (pairwise_tukeyhsd, MultiComparison)
from statsmodels.formula.api import ols
import statsmodels.api as sm
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import glob

import numpy as np
import scipy.stats


def mean_confidence_interval(data, confidence=0.95):
    a = 1.0 * np.array(data)
    n = len(a)
    m, se = np.mean(a), scipy.stats.sem(a)
    h = se * scipy.stats.t.ppf((1 + confidence) / 2., n-1)
    return m, m-h, m+h

# %% caricamento dataset


files = glob.glob("results/*.csv")

df = pd.DataFrame()
for i, f in enumerate(files):
    csv = pd.read_csv(f, names=['sonification', 'time', 'color_dist',
                                'target_color', 'clicked_color',
                                'target_size', 'clicked_size'], header=None)
    csv['subject'] = f
    df = df.append(csv)

# %%

df
# %%
df = df[df['time'] >= 1.0]

df
# %% definizione stili plot
plt.style.use('fivethirtyeight')

meanprops = {'marker': 'o',

             'markerfacecolor': 'orange',
             'markeredgecolor': 'black',
             'markersize': 5.0,
             'linewidth': 2.5}

boxprops = {'color': 'black', 'facecolor': 'white',
            'linewidth': 1}

whiskerprops = {'linewidth': 1}

medianprops = {'linestyle': '-',
               'linewidth': 1,
               'color': 'black'}

flierprops = {'marker': 'o',
              'markerfacecolor': 'white',
              'markersize': 4,
              'markeredgecolor': 'black'}

capprops = {'linewidth': 1}

position = [2, 0, 1]




# %% tempo di esecuzione in base al colore
my_cmap = plt.get_cmap("viridis", 27)

time_color = df[df["color_dist"] == 0].groupby(
    "target_color").mean().reset_index()[['target_color', 'time']]

plt.figure(figsize=(8, 6))
plt.bar(np.round(time_color['target_color']), time_color['time'], align='center', width=0.9,
        color=my_cmap(time_color['target_color']))


# %% calcolo medie per partecipanti di tempo e distanza
mean_sub = df.groupby(['subject', 'sonification']).mean()[
    ['time', 'color_dist']].reset_index().copy()




# %% medie per il tempo
print('media tempo')
print('n: ', mean_confidence_interval(
    mean_sub[mean_sub['sonification'] == 'n']['time']))
print('s: ', mean_confidence_interval(
    mean_sub[mean_sub['sonification'] == 's']['time']))
print('b: ', mean_confidence_interval(
    mean_sub[mean_sub['sonification'] == 'b']['time']))

# %% medie per l'accuratezza
print('media colore')
print('n: ', mean_confidence_interval(
    mean_sub[mean_sub['sonification'] == 'n']['color_dist']))
print('s: ', mean_confidence_interval(
    mean_sub[mean_sub['sonification'] == 's']['color_dist']))
print('b: ', mean_confidence_interval(
    mean_sub[mean_sub['sonification'] == 'b']['color_dist']))




# %% plot tempo medio dai partecipanti

fig, axes = plt.subplots(ncols=2)

fig.set_size_inches(8, 6)

mean_sub.boxplot(ax=axes[0], by='sonification', column=['time'],
                 patch_artist=True,
                 showmeans=True,
                 showfliers=True,
                 meanprops=meanprops,
                 boxprops=boxprops,
                 whiskerprops=whiskerprops,
                 medianprops=medianprops,
                 flierprops=flierprops,
                 capprops=capprops,
                 positions=position)

# plot distanza colore medio dai partecipanti
mean_sub.boxplot(ax=axes[1], by='sonification', column=['color_dist'],
                 patch_artist=True,
                 showmeans=True,
                 showfliers=True,
                 meanprops=meanprops,
                 boxprops=boxprops,
                 whiskerprops=whiskerprops,
                 medianprops=medianprops,
                 flierprops=flierprops,
                 capprops=capprops,
                 positions=position)

plt.suptitle('')
plt.show()


# %% riarrangiamento colonne e righe
mean_sonif = mean_sub.pivot(index=['subject'], columns=[
                            'sonification']).reset_index().copy()

# %% plot istogramma dei tempi
df.hist(figsize=(12, 8), by='sonification', column='time',
        legend=False, bins=30, color='c', edgecolor='k', alpha=0.65)

# %% test ANOVA per il tempo
time_mean = mean_sonif['time']
fvalue, pvalue = stats.f_oneway(time_mean['n'], time_mean['s'], time_mean['b'])
print(fvalue, pvalue)

# %% test a coppie per il tempo
MultiComp = MultiComparison(mean_sub['time'], mean_sub['sonification'])
# print(MultiComp.tukeyhsd().summary())
comp = MultiComp.allpairtest(stats.ttest_rel, method='Bonferroni')
print(comp[0])


# %% plot istogramma errori
mean_sonif['color_dist'].hist(
    figsize=(12, 8), bins=10, color='c', edgecolor='k', alpha=0.65)
# %% test ANOVA per gli errori
dist_mean = mean_sonif['color_dist']
fvalue, pvalue = stats.f_oneway(dist_mean['n'], dist_mean['s'], dist_mean['b'])
print(fvalue, pvalue)

# %% test a coppie per gli errori
MultiComp = MultiComparison(mean_sub['color_dist'], mean_sub['sonification'])
# print(MultiComp.tukeyhsd().summary())
comp = MultiComp.allpairtest(stats.ttest_rel, method='Bonferroni')
print(comp[0])

# %% calcoloo della matrice di confusione
toppa = df.copy()

#toppa['target_color'] = np.round(toppa['target_color']).astype(int)
#toppa['clicked_color'] = np.round(toppa['clicked_color']).astype(int)

confusion_matrix = pd.crosstab(toppa['target_color'], toppa['clicked_color'], rownames=[
                               'obiettivo'], colnames=['cliccato'], normalize='columns')

# %%
plt.figure(figsize=(7.5, 6))
sn.heatmap(confusion_matrix, annot=False)
plt.show()



#%% confusione taglie

confusion_matrix = pd.crosstab(df['target_size'], df['clicked_size'], rownames=[
                               'obiettivo'], colnames=['cliccato'], normalize='columns')

plt.figure(figsize=(7.5, 6))
sn.heatmap(confusion_matrix, annot=False)
plt.show()




#########################################
#########################################
#########################################
#########################################
#########################################
#########################################
#########################################


#%% ricerca outliers
mean_for_subject = mean_sub.groupby(['subject', 'sonification']).mean()

mean_for_subject



# Altro

# %% time ~ C(sonification) alla R
model = ols('time ~ C(sonification)', data=mean_sub).fit()
anova_table = sm.stats.anova_lm(model, typ=2)
anova_table

# %% time ~ C(sonification) alla R
model = ols('color_dist ~ C(sonification)', data=mean_sub).fit()
anova_table = sm.stats.anova_lm(model, typ=2)
anova_table


# %% effetti della dimensione
print(df[df['color_dist'] != 0].count())

errors = df[df['target_size'] != df['clicked_size']].copy()


errors['size_big'] = np.where(errors['clicked_size'] > errors["target_size"] , 1, 0)
errors['size_sma'] = np.where(errors['clicked_size'] < errors["target_size"] , 1, 0)

errors.sum()[['size_big', 'size_sma']].plot.bar() #prendere size big, size small
errors.sum()
#%%

errors = errors.groupby('subject').mean()[['size_big', 'size_sma']].reset_index()


errors = errors.sort_values(by=['size_big'])
#%%
labels = np.arange(errors.count()[0])
big = errors['size_big']
small = errors['size_sma']
width = 0.8       # the width of the bars: can also be len(x) sequence

fig, ax = plt.subplots(figsize=(8, 6))

ax.bar(labels, big, width, label='Più piccoli')
ax.bar(labels, small, width, bottom=big,
       label='Più grandi')

ax.set_ylabel('Preferenza')
ax.set_title('Preferenza di dimensione in caso di errore')
ax.legend()

ax.plot([0.05, 0.95], [0, 0.95], transform=ax.transAxes, color='k', linestyle='--', linewidth=1)
plt.show()
# %%


taglia = df.copy()

def get_size(value):
    if (value >= 20 and value < 28):
        return 'small'
    elif (value >= 28 and value < 36):
        return 'medium'
    elif (value >= 36 and value < 45):
        return 'big'

taglia['size'] = taglia['target_size'].apply(get_size)

taglia = taglia.groupby(['subject', 'size']).mean()[
    ['time', 'color_dist']].reset_index().copy()

fig, axes = plt.subplots(ncols=2)

fig.set_size_inches(8, 6)

taglia.boxplot(ax=axes[0], by='size', column=['color_dist'],
                 showmeans=True,
                 patch_artist=True,
                 showfliers=True,
                 meanprops=meanprops,
                 boxprops=boxprops,
                 whiskerprops=whiskerprops,
                 medianprops=medianprops,
                 flierprops=flierprops,
                 capprops=capprops)

taglia.boxplot(ax=axes[1], by='size', column=['time'],
                 showmeans=True,
                 patch_artist=True,
                 showfliers=True,
                 meanprops=meanprops,
                 boxprops=boxprops,
                 whiskerprops=whiskerprops,
                 medianprops=medianprops,
                 flierprops=flierprops,
                 capprops=capprops)

plt.suptitle('')
plt.show()

print('media tempo')
print('small: ', mean_confidence_interval(
    taglia[taglia['size'] == 'small']['time']))
print('medium: ', mean_confidence_interval(
    taglia[taglia['size'] == 'medium']['time']))
print('big: ', mean_confidence_interval(
    taglia[taglia['size'] == 'big']['time']))

print('media colore')
print('big: ', mean_confidence_interval(
    taglia[taglia['size'] == 'small']['color_dist']))
print('medium: ', mean_confidence_interval(
    taglia[taglia['size'] == 'medium']['color_dist']))
print('small: ', mean_confidence_interval(
    taglia[taglia['size'] == 'big']['color_dist']))

taglia = taglia.pivot(index=['subject'], columns=['size']).reset_index().copy()

cd = taglia['color_dist']
fvalue, pvalue = stats.f_oneway(cd['small'], cd['medium'], cd['big'])
print('color_dist', fvalue, pvalue)

tm = taglia['time']
fvalue, pvalue = stats.f_oneway(tm['small'], tm['medium'], tm['big'])
print('time', fvalue, pvalue)
# %%
