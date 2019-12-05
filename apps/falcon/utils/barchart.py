'''
# The height array needs to be sorted in decending order
# Module to draw a bar graph
'''
import numpy as np
import matplotlib.pyplot as plt

import logging
log = logging.getLogger('__main__.'+__name__)


#Bar graph
def draw_bar_graph(x,y):
  labels=x
  heights=y
  # Labels that can’t be used for plotting purpose. So we will generate an array of length of label and use it on X-axis
  x_pos_labels = np.arange(len(labels))
  # matplotlib.pyplot.bar(x, height, width=0.8, bottom=None, *, align='center', data=None, **kwargs)
  plt.bar(x_pos_labels, heights, align='center', alpha=0.7,width=0.35)
  # Scale limit on y axis i.e. 0-250000
  plt.ylim(0,250000)
  # Labels will be placed on each tick that is generated due to index sequence.
  plt.xticks(x_pos_labels, labels, rotation=80)
  plt.title('Instances per category')
  # Set the width and height
  plt.rcParams["figure.figsize"] = [22,5]
  # To print the height values on bars
  for a,b in zip(x_pos_labels, heights):
    c=b+20000
    plt.text(a, c, str(b),rotation='vertical',ha='center')
  plt.show()


#Line graph	
def draw_and_save_line_graph(x,y,legend_label,plot_title,scale,offset):
  labels=x['classname']
  heights=y
  x_pos_labels = np.arange(len(labels))
  plt.plot(x_pos_labels, heights, 's-' , alpha=0.7, label=legend_label)
  plt.ylim(0,scale)
  plt.xticks(x_pos_labels, labels, rotation=80, fontsize=10)
  plt.title(plot_title)
  plt.legend(loc='upper right', prop={'size': 18})
  plt.rcParams["figure.figsize"] = [22,15]  
  for a,b in zip(x_pos_labels, heights):
    c=b+offset
    plt.text(a, c, str(b),rotation='vertical',ha='center')
  plt.show()