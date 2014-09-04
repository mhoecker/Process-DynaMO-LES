""" tke Flow diagram using the sankey object
"""
import sys, getopt
import numpy as np
import matplotlib.pyplot as plt

from matplotlib.sankey import Sankey

fig = plt.figure(figsize=(8, 9))
ax = fig.add_subplot(1, 1, 1, xticks=[], yticks=[])
#
if len(sys.argv) > 0 :
 tkedatfile = sys.argv[1]
 if len(sys.argv) > 1 :
  rootname = sys.argv[2]
 else:
  #rootname = "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Article/figs/tkeflow"
  rootname = '/media/mhoecker/work/Dynamo/Documents/plots/y6/'
else:
 tkedatfile =  '/media/mhoecker/work/Dynamo/output/yellowstone6/tkeflow.dat'
#print(tkedatfile)
# Read values from data file
tkein = 1e9*np.loadtxt(tkedatfile)
#tkeflows = [tkein[4],tkein[1],tkein[2],tkein[3],-tkein[4]-tkein[1]-tkein[2]-tkein[3]]
tkeflows = [tkein[4],tkein[1],tkein[2],tkein[3],tkein[6],tkein[7]]
# Give each Arrow a Title
tkelabs = ["Stokes "+r"$\left<u'w'\right>\partial_zU_s$"]
tkelabs.append("Shear "+r"$\left<u'w'\right>\partial_z\partial\bar{u}$")
tkelabs.append("Buoyancy "+r"$\left<b'w'\right>$")
tkelabs.append("Dissipation "+r"$\epsilon$")
tkelabs.append("Accumulation "+r"$\partial_t tke$")
tkelabs.append("Filter")
# Set the flow diagram Geometry
tkelen = [.5,.5,.5,.5,.5,.5]
tkeori = [0,0,0,0,-1,0]
tketrun= 3
# Common Snake properties
rot=0
fcol="#DFDFDF"
#
snakey = Sankey(ax=ax,format='%4.0f',unit=r'$\mathrm{nW/kg}$',margin=0 ,offset=-.75,radius=.125,gap=.125,scale=2e-3,head_angle=120)
snakey.add(flows=tkeflows,orientations=tkeori,pathlengths=tkelen,labels=tkelabs,rotation=rot,trunklength=tketrun,facecolor=fcol,label="Stratified Turbulence")
#
diagrams = snakey.finish()
for diagram in diagrams:
#    diagram.text.set_fontweight('bold')
#    diagram.text.set_fontsize('24')
    for text in diagram.texts:
        text.set_fontsize('14')
# Notice that the explicit connections are handled automatically, but the
# implicit ones currently are not.  The lengths of the paths and the trunks
# must be adjusted manually, and that is a bit tricky.

plt.legend(loc='upper right')
suffixes = ['png','pdf']
smallfig = 4.0*[9/2.2,6/2.2]
for suffix in suffixes:
 fig.savefig(rootname+"tkeflow."+suffix,bbox=smallfig,bbox_inches='tight',pad_inches=0.01,format=suffix)
#plt.show()
