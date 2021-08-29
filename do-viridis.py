# %%
import csv
import matplotlib
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.colors import ListedColormap, LinearSegmentedColormap

values = 256

viridis = cm.get_cmap('viridis', values)

# open the file in the write mode
with open('viridis.txt', 'w') as f:
    # create the csv writer

    for value in viridis(np.linspace(0, 1, values)):
        value = matplotlib.colors.rgb2hex(value, keep_alpha=False)
        f.write("{}\n".format(value))
