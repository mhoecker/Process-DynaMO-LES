reset
datdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/'
load datdir."limits.plt"
#set term png enhanced size 1536,1024 truecolor nocrop linewidth 2
#set output "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/fig1.png"
set term pdf enhanced monochrome dashed size 9in,6in font "Helvetica,12" linewidth 2
set output "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/fig2.pdf"
set multiplot
set tmargin at screen .9
set bmargin at screen .1
set xtics nomirror rangelimited
set x2tics nomirror rangelimited
set yrange [-dsim:0]
set y2range [-dsim:0]
set xlabel "T (^oC)"
set x2label "S (psu)"
set lmargin at screen .1
set rmargin at screen .5
set ylabel "Z (m)"
#set xrange [20:30]
#set x2range [35.2:35.7]
plot \
datdir."fig2a.dat" binary format="%f%f%f" u 2:1 w lines axes x1y2 title "T" ls 1 lc -1,\
datdir."fig2a.dat" binary format="%f%f%f" u 3:1 w lines axes x2y2 title "S" ls 2 lc -1
set lmargin at screen .5
set rmargin at screen .9
unset ytics
unset ylabel
set y2label "Z (m)"
set y2tics mirror
set xrange [-.4:.4]
set x2range [-.2:.2]
set xlabel "U (m/s)"
set x2label "V (m/s)"
set yzeroaxis
plot \
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 2:1 w lines axes x1y2 title "U "   ls 1 lc -1,\
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 3:1 w lines axes x2y2 title "V "   ls 2 lc -1,\
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 4:1 w lines axes x1y2 title "U_{L5}" ls 4 lc -1,\
datdir."fig2b.dat" binary format="%f%f%f%f%f" u 5:1 w lines axes x2y2 title "V_{L5}" ls 5 lc -1
unset multiplot
