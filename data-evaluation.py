# %%
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import glob
# %%

files = glob.glob("dataset/*.csv")

df = pd.DataFrame()
for f in files:
    csv = pd.read_csv(f, names=['sonification', 'time', 'color_dist',
                                'target_color', 'clicked_color', 'target_size', 'clicked_size'], header=None)
    df = df.append(csv)

df.head()

# %%

corect = df[df['color_dist'] == 0]


corect.groupby(corect['sonification'])['time'].median().head()


# %%
df[['sonification', 'time']].groupby('sonification').describe()
# %%

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

# %%

df.boxplot(figsize=(8, 6), by='sonification', column=['color_dist'],
           showmeans=True,
           showfliers=True,
           meanprops=meanprops,
           boxprops=boxprops,
           whiskerprops=whiskerprops,
           medianprops=medianprops,
           flierprops=flierprops,
           capprops=capprops)

# %%
plot = df.boxplot(figsize=(8, 6), by='sonification', column=['time'],
                  showmeans=True,
                  showfliers=True,
                  meanprops=meanprops,
                  boxprops=boxprops,
                  whiskerprops=whiskerprops,
                  medianprops=medianprops,
                  flierprops=flierprops,
                  capprops=capprops)

# %%


my_cmap = plt.get_cmap("viridis")


time_color = df[df["color_dist"] == 0].groupby(
    "target_color").mean().reset_index()[['target_color', 'time']]

plt.figure(figsize=(8, 6))
plt.bar(time_color['target_color'], time_color['time'], align='center', width=8,
        color=my_cmap(time_color['target_color']))


# %%
errors = df[df["color_dist"] != 0].copy()
errors['pref_big'] = errors["target_size"] - errors['clicked_size']

#errors.groupby(errors['pref_big'] < 0)['color_dist'].count().plot.bar()
