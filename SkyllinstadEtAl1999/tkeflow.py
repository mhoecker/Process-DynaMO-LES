""" tke Flow diagram using the sankey object
"""
import numpy as np
import matplotlib.pyplot as plt

from matplotlib.sankey import Sankey

fig = plt.figure(figsize=(8, 9))
ax = fig.add_subplot(1, 1, 1, xticks=[], yticks=[])
#
tkedatfile =  '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone6/d1024_1_dagtkeAVG.dat'
print(tkedatfile)
# Read values from data file
tkeflows = 1e6*np.loadtxt(tkedatfile)
# Hard coded values
#tkeflows = [1.25,.335,-.169,-1.7]
#tkeflows = Stokes, Shear, Buoyancy, Dissipation
print(tkeflows)
#tkelabs = [r"$\left<u'w'\right>\partial_zu_s$",r"$\left<u'w'\right>\partial_z\bar{u}$",r"$\left<b'w'\right>$",r"$\epsilon$"]
tkelabs = ["Stokes\nProduction\n"+r"$\left<u'w'\right>\partial_zu_s$"]
tkelabs.append("Shear\nProduction\n"+r"$\left<u'w'\right>\partial_z\bar{u}$")
tkelabs.append("Buoyancy\nProduction\n"+r"$\left<b'w'\right>$")
tkelabs.append("Dissipation\n"+r"$\epsilon$")
tkelen = [1,1,1,1]
tkeori = [-1,0,1,0]
tketrun=2*sum(tkelen)/len(tkelen)
# Energy input into Stokes drift
Stflows = [tkeflows[0],-tkeflows[0]]
# Acceleration
#Stflows.append(-sum(Stflows))
Stori = [0,1]
Stlen = [1,2]
Stlabs = ["Stokes\nProduction\n"+r"$\left<u'w'\right>\partial_zu_s$",""]
Sttrun = 2
# Shear flows
Shflows = [tkeflows[1],-tkeflows[1]]
# Acceleration
#Shflows.append(-sum(Shflows))
Shlabs = ["Shear\nProduction\n"+r"$\left<u'w'\right>\partial_z\bar{u}$",""]
Shlen = [1,1]
Shori = [0,0]
Shtrun = Sttrun-1
#
Buflows = [tkeflows[2],0,0,0]
Bulabs = ["Buoyancy\nProduction\n"+r"$\left<b'w'\right>$","","Potential\nEnergy\n"+r"$\Delta\rho g z$","Precipitation\nHeating"]
Bulen = [Stlen[1],Stlen[1],Stlen[1],Sttrun+1]
Buori = [1,-1,0,0]
Butrun = 1
ubflows = [tkeflows[2],-tkeflows[2]]
ublabs = ["Evaporation\nCooling",""]
ublen = [Bulen[-1],Bulen[0]]
ubori = [0,-1]
ubtrun = Butrun
#
meanflows = [-tkeflows[1],0,0,0]
#meanflows.append(-sum(meanflows))
meanlabs = ["","Mean\nDissipation\n"+r"$\bar{\epsilon}$","Mean\nKinetic\nEnergy\n"+r"$\Delta\frac{1}{2}\bar{u}^2$","Wind\nStress\n"+r"$\vec{u}\cdot\vec{\tau}$"]
meanlen = [2,1,1,2]
meanori = [0,1,-1,0]
meantrun = Sttrun+1
meancon = (0,0)
meanpre = 2
# Common Snake properties
rot=-90
tlen=1
fcol="#DDDDDD"
#snakey = Sankey(ax=ax,format='%3.1f',unit=r'J/m$^2$',gap=0.5,scale=abs(1.0/diss),head_angle=120)
snakey = Sankey(ax=ax,format='%4.2f',unit=r'$\mu\mathrm{W/kg}$',margin=2,offset=1,gap=.5,scale=abs(1.0/tkeflows[3]),head_angle=90)
snakey.add(flows=tkeflows,orientations=tkeori,pathlengths=tkelen,labels=tkelabs,rotation=rot,trunklength=tketrun,facecolor=fcol,label="Stratified Turbulence")
# Stokes 1
#snakey.add(flows=Stflows,orientations=Stori,pathlengths=Stlen,labels=Stlabs,trunklength=Sttrun,prior=0,connect=(0,1),rotation=rot,facecolor=fcol,label="Langmuir Turbulence")
# Shear 2
#snakey.add(flows=Shflows,orientations=Shori,pathlengths=Shlen,labels=Shlabs,trunklength=Shtrun,prior=0,connect=(1,1),rotation=rot,facecolor=fcol,label="Mean Flow")
# Buoyancy 3
#snakey.add(flows=Buflows,orientations=Buori,pathlengths=Bulen,labels=Bulabs,trunklength=Butrun,prior=0,connect=(2,1),rotation=rot,facecolor=fcol,label="Stratification")
# Buoyancy 4
#snakey.add(flows=ubflows,orientations=ubori,pathlengths=ublen,labels=ublabs,trunklength=ubtrun,prior=3,connect=(0,1),rotation=-rot,facecolor=fcol)
# Mean Flow 5
#snakey.add(flows=meanflows,orientations=meanori,pathlengths=meanlen,labels=meanlabs,trunklength=meantrun,prior=meanpre,connect=meancon,rotation=rot,facecolor=fcol)
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
tkecol = '#e0e0e0'
#diagrams[0].patch.set_color(tkecol)
Stcol = '#c8c8c8'
#diagrams[1].patch.set_color(Stcol)
Shcol = '#b0b0b0'
#diagrams[2].patch.set_color(Shcol)
#diagrams[5].patch.set_color(Shcol)
Buoycol = '#989898'
#diagrams[3].patch.set_color(Buoycol)
#diagrams[4].patch.set_color(Buoycol)

plt.legend(loc='upper right')
suffixes = ['eps','ps','eps','pdf']
rootname = "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Article/figs/tkeflow"
smallfig = 2*[9/2.2,6/2.2]
for suffix in suffixes:
 fig.savefig(rootname+"."+suffix,bbox=smallfig,pad_inches=0.0,format=suffix)
plt.show()
