reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig7".termsfx
unset surface
set view map
set pm3d
set multiplot
set rmargin at screen .85
set lmargin at screen .15
set tmargin at screen .9
set bmargin at screen .7
splot datdir."fig7a.dat" binary matrix not
#
set tmargin at screen .7
set bmargin at screen .5
splot datdir."fig7b.dat" binary matrix not
#
set tmargin at screen .5
set bmargin at screen .3
splot datdir."fig7c.dat" binary matrix not
#
set tmargin at screen .3
set bmargin at screen .1
splot datdir."fig7d.dat" binary matrix not
