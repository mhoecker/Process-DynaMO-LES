reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig2".termsfx
set multiplot
set tmargin at screen .9
set bmargin at screen .1
set xtics nomirror rotate by -30 rangelimited
set x2tics nomirror rotate by 30 rangelimited
set yrange [-dsim:0]
set y2range [-dsim:0]
set xlabel "T (^oC)"
set x2label "S (psu)"
set lmargin at screen .15
set rmargin at screen .5
set ylabel "Z (m)"
#set xrange [20:30]
#set x2range [35.2:35.7]
plot \
datdir."fig2a.dat" binary format="%f%f%f" u 2:1 w lines axes x1y2 title "T" ls 1,\
datdir."fig2a.dat" binary format="%f%f%f" u 3:1 w lines axes x2y2 title "S" ls 2
set lmargin at screen .5
set rmargin at screen .85
unset ytics
unset ylabel
set y2label "Z (m)"
set y2tics mirror
#set autoscale x
#set autoscale x2
set xrange [-.6:.6]
set x2range [-.6:.6]
set xlabel "U (m/s)"
set x2label "V (m/s)"
set yzeroaxis
plot \
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 2:(-$1) w lines axes x1y2 title "U "   ls 1 ,\
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 3:(-$1) w lines axes x2y2 title "V "   ls 2 ,\
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 4:(-$1) w lines axes x1y2 title "U_{L5}" ls 3,\
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 5:(-$1) w lines axes x2y2 title "V_{L5}" ls 5
unset multiplot
