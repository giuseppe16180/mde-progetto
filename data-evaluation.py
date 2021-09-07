# %%

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
    csv['subject'] = i
    df = df.append(csv)

# %%

df
# %%
df = df[df['time'] >= 1.0]

df
# %% definizione stili plot
plt.style.use('fivethirtyeight')

meanprops = {'marker': 'o',
             'markerfacecolor': 'black',
             'markeredgecolor': 'black',
             'markersize': 5.0,
             'linewidth': 2.5}

boxprops = {'color': 'black',
            'linewidth': 1}

whiskerprops = {'linewidth': 1}

medianprops = {'linestyle': '-',
               'linewidth': 1,
               'color': 'black'}

flierprops = {'marker': 'o',
              'markerfacecolor': 'black',
              'markersize': 1,
              'markeredgecolor': 'black'}

capprops = {'linewidth': 1}

position = [2, 0, 1]


# %% tempo di esecuzione in base al colore
my_cmap = plt.get_cmap("viridis")

time_color = df[df["color_dist"] == 0].groupby(
    "target_color").mean().reset_index()[['target_color', 'time']]

plt.figure(figsize=(8, 6))
plt.bar(np.round(time_color['target_color']), time_color['time'], align='center', width=0.9,
        color=my_cmap(time_color['target_color'] / 25))


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
mean_sub.boxplot(figsize=(8, 6), by='sonification', column=['time'],
                 showmeans=True,
                 showfliers=False,
                 meanprops=meanprops,
                 boxprops=boxprops,
                 whiskerprops=whiskerprops,
                 medianprops=medianprops,
                 flierprops=flierprops,
                 capprops=capprops,
                 positions=position)
plt.title('')
plt.suptitle('')
plt.show()


# %% plot distanza colore medio dai partecipanti
mean_sub.boxplot(figsize=(8, 6), by='sonification', column=['color_dist'],
                 showmeans=True,
                 showfliers=False,
                 meanprops=meanprops,
                 boxprops=boxprops,
                 whiskerprops=whiskerprops,
                 medianprops=medianprops,
                 flierprops=flierprops,
                 capprops=capprops,
                 positions=position)
plt.title('')
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
    figsize=(12, 8), bins=30, color='c', edgecolor='k', alpha=0.65)
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

toppa['target_color'] = np.round(toppa['target_color']).astype(int)
toppa['clicked_color'] = np.round(toppa['clicked_color']).astype(int)

confusion_matrix = pd.crosstab(toppa['target_color'], toppa['clicked_color'], rownames=[
                               'obiettivo'], colnames=['cliccato'], normalize='columns')

# %%
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


# Altro

# %% time ~ C(sonification) alla R
model = ols('time ~ C(sonification)', data=mean_sub).fit()
anova_table = sm.stats.anova_lm(model, typ=2)
anova_table

# %% time ~ C(sonification) alla R
model = ols('color_dist ~ C(sonification)', data=mean_sub).fit()
anova_table = sm.stats.anova_lm(model, typ=2)
anova_table

# %%


# %%
# res.anova_std_residuals are standardized residuals obtained from ANOVA (check above) sm.qqplot(res.anova_std_residuals, line='45')
plt.xlabel("Theoretical Quantiles")
plt.ylabel("Standardized Residuals")
plt.show()
# histogram
plt.hist(res.anova_model_out.resid, bins='auto', histtype='bar', ec='k') plt.xlabel("Residuals")
plt.ylabel('Frequency')
plt.show()


# %%
corect = df[df['color_dist'] == 0]
corect.groupby(corect['sonification'])['time'].median().head()

# %%
df[['sonification', 'time']].groupby('sonification').describe()


# %% plot della distanza colore in base alla sonification

df.boxplot(figsize=(8, 6), by='sonification', column=['color_dist'],
           showmeans=True,
           showfliers=True,
           meanprops=meanprops,
           boxprops=boxprops,
           whiskerprops=whiskerprops,
           medianprops=medianprops,
           flierprops=flierprops,
           capprops=capprops,
           positions=position)

# %% plot del tempo in base alla sonification
plot = df.boxplot(figsize=(8, 6), by='sonification', column=['time'],
                  showmeans=True,
                  showfliers=True,
                  meanprops=meanprops,
                  boxprops=boxprops,
                  whiskerprops=whiskerprops,
                  medianprops=medianprops,
                  flierprops=flierprops,
                  capprops=capprops,
                  positions=position)


# %% effetti della dimensione
errors = df[df["color_dist"] != 0].copy()
errors['pref_big'] = errors["target_size"] - errors['clicked_size']

#errors.groupby(errors['pref_big'] < 0)['color_dist'].count().plot.bar()

errors.boxplot(figsize=(8, 6), by='sonification', column=['pref_big'],
               showmeans=True,
               showfliers=True,
               meanprops=meanprops,
               boxprops=boxprops,
               whiskerprops=whiskerprops,
               medianprops=medianprops,
               flierprops=flierprops,
               capprops=capprops, positions=[2, 0, 1])

# %%

# %%

# %%
