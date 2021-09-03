# %%
import csv
import matplotlib
import numpy as np
from matplotlib import cm

values = 27

viridis = cm.get_cmap('viridis', values)

with open('viridis.txt', 'w') as f:
    for value in viridis(np.linspace(0, 1, values)):
        value = matplotlib.colors.rgb2hex(value, keep_alpha=False)
        f.write("{}\n".format(value)[1:])
