reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig4".termsfx
set style data lines
set multiplot
set logscale y
set rmargin at screen .85
set lmargin at screen .15
set tmargin at screen .9
set bmargin at screen .7
set x2tics
unset xtics
plot 1 not axes x2y1 lc 0, datdir."fig4a.dat" binary format="%f%f%f%f" u 1:2 lc -1 not axes x2y1
#
unset logscale
set y2tics
unset ytics
unset x2tics
set tmargin at screen .7
set bmargin at screen .5
plot 0 lc 0 not axes x1y2, datdir."fig4a.dat" binary format="%f%f%f%f" u 1:3 lc -1 not axes x1y2
#
unset logscale
unset y2tics
set ytics
unset x2tics
set tmargin at screen .5
set bmargin at screen .3
plot datdir."fig4a.dat" binary format="%f%f%f%f" u 1:($4**2) lc -1 not axes x1y1
#
set y2tics
unset ytics
unset x2tics
set xtics nomirror
set logscale y2
set tmargin at screen .3
set bmargin at screen .1
plot 1 not axes x1y2 lc 0, datdir."fig4a.dat" binary format="%f%f%f%f" u 1:(-$2) lc -1 not axes x1y2
