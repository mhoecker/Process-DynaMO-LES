reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig4".termsfx
set style data lines
# Setup vertical spacing
rows = 3
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Instability Criterion"
#
Nsqmax = 4e-4
Nsqmin = -Nsqmax/(palcolors-1)
Rimax = 1.0
Rimin= -Rimax
cbform = "%+04.1te^{%+02T}"
rhotitle = "{/Symbol Dr}=0.05 kg/m^3"
rhocolor = "grey50"
Rictitle = "Ri =+1/4"
Riccolor = "grey20"
Ri0title = "Ri = 0  "
Ri0color = "grey60"
Rimtitle = "Ri =-1/4"
Rimcolor = "grey80"
set key l b
set format x ""
set format y "%gm"
#
# Nsq
set ylabel "N^2"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set format cb cbform."s^{-2}"
set cbrange [Nsqmin:Nsqmax]
set cbtics Nsqmin,(Nsqmax-Nsqmin)/palcolors,Nsqmax
set colorbox user origin rloc,bloc(row)+.05*vskip size 0.1*(1.0-rloc),1.9*vskip
plot datdir."fig4b.dat" binary matrix w image not, datdir."fig4e.tab"  lc rgbcolor rhocolor title rhotitle
#
# Ssq
set ylabel "S^2"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
unset colorbox
plot datdir."fig4c.dat" binary matrix w image not, datdir."fig4e.tab" lc rgbcolor rhocolor title rhotitle
#
# Richardson Number
set ylabel "Ri=N^2/S^2"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size 0.1*(1.0-rloc),.9*(vskip)
row = nextrow(row)
set format cb cbform
set cbrange [Rimin:Rimax]
set cbtics Rimin,(Rimax-Rimin)/palcolors,Rimax
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,1
plot datdir."fig4d.dat" binary matrix w image not,\
datdir."fig4d.tab" lc rgbcolor Riccolor title Rictitle,\
datdir."fig4d0.tab" lc rgbcolor Ri0color title Ri0title,\
datdir."fig4dm.tab" lc rgbcolor Rimcolor title Rimtitle
#
unset multiplot
