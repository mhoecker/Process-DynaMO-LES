from pylab import rand
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rc
import matplotlib
from matplotlib.collections import PatchCollection
import matplotlib.path as mpath
import matplotlib.patches as mpatches
import matplotlib.lines as mlines
rc('font',**{'family':'sans-serif','sans-serif':['Arial']})
rc('text',usetex=True)
font = "arial"
fontsize = 10
matplotlib.rcParams['ps.usedistiller']='xpdf'
rootname = "tkeschema"
smallfig = 2*[9/2.2,6/2.2]
fig = plt.figure(1,figsize=(smallfig[0],smallfig[1]))
colwid = 1
cols = 4
depth = -6*cols*colwid/9.0
rows = 4
rowdep = depth/rows
topshade = '#e0e0e0'
Midshade = '#d0d0d0'
Pycshade = '#c0c0c0'
deepshade = '#b0b0b0'
#
#extra = 1.15
#myblue = '#c0c0c0'
#rad = 1
#cmtheta = np.pi*1.9
#ray_theta = cmtheta-np.pi/2
#taur = rad*.8
#Force = rad*.75
#cmr = .75*rad
#ray = [rad*np.cos(ray_theta),rad*np.sin(ray_theta)]
#cm = [cmr*np.cos(cmtheta),cmr*np.sin(cmtheta)]
#grav = [cm[0],cm[1]-Force]
#bouy = [0,Force]

ax = fig.add_subplot(111, aspect='equal',xlim=(0*colwid,(cols)*colwid),ylim=(rowdep*(rows),.5*rowdep))
ax.set_xticks([])
ax.set_yticks([])

# Surface block
#Surface = mpatches.Rectangle(xy=[1*colwid,0*rowdep], width=colwid,height=rowdep)
#ax.add_artist(Surface)
#Surface.set_clip_box(ax.bbox)
#Surface.set_alpha(1)
#Surface.set_facecolor(topshade)
#


# Forcings

#Wind forcing
#ax.annotate('',xytext=[1.5*colwid,-rowdep*.5],xy=[1.5*colwid,0*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black"))
#plt.text(1.5*colwid,-0.5*rowdep,r'$\vec{u}\vec{\tau}$',ha="center",va="bottom",family=font, size=fontsize)

# Forcing Row
#
#Label
plt.text(0,1*rowdep,"Forcings",ha="left",va="bottom",family=font, size=fontsize)
# Waves
plt.text(1.5*colwid,1*rowdep,"Waves",ha="center",va="bottom",family=font, size=fontsize)
# Wind
plt.text(2.5*colwid,1*rowdep,"Wind",ha="center",va="bottom",family=font, size=fontsize)
# Buoyancy
plt.text(3.5*colwid,1*rowdep,"Buoyancy",ha="center",va="bottom",family=font, size=fontsize)
#
#Large Scale Energy Transfer
#
ax.annotate('',xytext=[1.5*colwid,1*rowdep],xy=[1.5*colwid,1.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=-135,angleB=135"))
ax.annotate('',xy=[1.5*colwid,1*rowdep],xytext=[1.5*colwid,1.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=45,angleB=-45"))
#plt.text(,r"",ha="right",va="center",family=font, size=fontsize)
#
ax.annotate('',xytext=[2.5*colwid,1*rowdep],xy=[2.5*colwid,1.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=-135,angleB=135"))
ax.annotate('',xy=[2.5*colwid,1*rowdep],xytext=[2.5*colwid,1.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=45,angleB=-45"))
#plt.text(,r"",ha="right",va="center",family=font, size=fontsize)
#
ax.annotate('',xytext=[3.5*colwid,1*rowdep],xy=[3.5*colwid,1.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=-135,angleB=135"))
ax.annotate('',xy=[3.5*colwid,1*rowdep],xytext=[3.5*colwid,1.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=45,angleB=-45"))
#plt.text(,r"",ha="right",va="center",family=font, size=fontsize)
#
#
# Resevoir row
#
#Label
plt.text(0,2*rowdep,"Resevouirs",ha="left",va="bottom",family=font, size=fontsize)
# Waves
plt.text(1.5*colwid,2*rowdep,"Stokes drift",ha="center",va="bottom",family=font, size=fontsize)
# Wind
plt.text(2.5*colwid,2*rowdep,"Mean flow",ha="center",va="bottom",family=font, size=fontsize)
# Buoyancy
plt.text(3.5*colwid,2*rowdep,"Stratification",ha="center",va="bottom",family=font, size=fontsize)
#
# Large to small scale energy transfer
#
# Stokes Production
ax.annotate('',xytext=[1.5*colwid,2*rowdep],xy=[2.5*colwid,2.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=0,angleB=135"))
ax.annotate('',xy=[1.5*colwid,2*rowdep],xytext=[2.5*colwid,2.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="grey",connectionstyle="angle3,angleA=180,angleB=-90"))
# Shear Production
ax.annotate('',xytext=[2.5*colwid,2*rowdep],xy=[2.5*colwid,2.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=-135,angleB=135"))
ax.annotate('',xy=[2.5*colwid,2*rowdep],xytext=[2.5*colwid,2.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="grey",connectionstyle="angle3,angleA=45,angleB=-45"))
# Buoyancy Production
ax.annotate('',xy=[3.5*colwid,2*rowdep],xytext=[2.5*colwid,2.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black",connectionstyle="angle3,angleA=0,angleB=-90"))
ax.annotate('',xytext=[3.5*colwid,2*rowdep],xy=[2.5*colwid,2.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="grey",connectionstyle="angle3,angleA=180,angleB=-135"))
#
#Label
#plt.text(0,3*rowdep,"Resevouirs",ha="left",va="bottom",family=font, size=fontsize)
# Turbulence
plt.text(2.5*colwid,3*rowdep,"Turbulent Kinetic Energy",ha="center",va="bottom",family=font, size=fontsize)
#
# Transfer to dissipation
# Shear Production
ax.annotate('',xytext=[2.5*colwid,3*rowdep],xy=[2.5*colwid,3.75*rowdep],family=font, size=fontsize,arrowprops=dict(arrowstyle="fancy",color="black"))
#
#Label
#plt.text(0,3*rowdep,"Resevouirs",ha="left",va="bottom",family=font, size=fontsize)
# Dissipation
plt.text(2.5*colwid,4*rowdep,"Dissipation",ha="center",va="bottom",family=font, size=fontsize)
#


# tau_nu
#ax.annotate(r'$\tau_\nu$',xy=[taur*np.cos(4*np.pi/4),taur*np.sin(4*np.pi/4)],xytext=[taur*np.cos(3*np.pi/4),taur*np.sin(3*np.pi/4)],family=font,size=fontsize,
#arrowprops=dict(arrowstyle="fancy",connectionstyle="angle3,angleA=-135,angleB=-90",color=myblue))
# tau_g
#ax.annotate(r'$\tau_g$',xy=[taur*np.cos(0*np.pi/4),taur*np.sin(0*np.pi/4)],xytext=[taur*np.cos(1*np.pi/4),taur*np.sin(1*np.pi/4)],family=font,size=fontsize
#,arrowprops=dict(arrowstyle="fancy",connectionstyle="angle3,angleA=-45,angleB=-90",color='#505050'))
# r
#ax.annotate('',xy=[0,0],xytext=ray,family=font,size=fontsize,
#arrowprops=dict(arrowstyle="<-",color="black"))
#plt.text(.75*ray[0]-.1*ray[1],.75*ray[1]+.1*ray[0], r'r',family=font, size=fontsize)

# Weight
#ax.annotate('',xytext=cm,xy=grav,family=font, size=fontsize,
# arrowprops=dict(arrowstyle="fancy",color="black"))
#plt.text(cm[0],cm[1]-Force,r' Weight',ha="center",va="top",family=font, size=fontsize)
# l
#ax.annotate('',ha="center",xytext=[0,0],xy=cm,family=font, size=fontsize,
# arrowprops=dict(arrowstyle="->",color="black"))
#plt.text(.5*cm[0]-.1*cm[1],.5*cm[1]+.1*cm[0], r'$\vec{l}$',ha="center",family=font, size=fontsize)
#Buoyancy
#ax.annotate('',ha="center",va="center",xytext=[0,0],xy=[0,Force],family=font, size=fontsize,
# arrowprops=dict(arrowstyle="fancy",color='#909090'))
#plt.text(0,Force,r'Buoyancy',ha="center",family=font, size=fontsize)



suffixes = ['eps','ps','eps','pdf']
for suffix in suffixes:
 fig.savefig(rootname+"."+suffix,bbox=smallfig,pad_inches=0.0,format=suffix)

#plt.show()
