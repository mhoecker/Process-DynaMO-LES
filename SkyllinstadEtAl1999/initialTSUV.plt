set output outdir.abrev.termsfx
set multiplot
# Setup spacing
rows = 1
row = 0
cols = 2
col = 0
load scriptdir."tlocbloc.plt"
#
#
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set xtics nomirror offset 0,xtoff
set x2tics nomirror offset 0,-xtoff
set yrange [-dsim:0]
set ytics mirror -70,20,-10 offset ytoff,0
set y2range [-dsim:0]
set xlabel "T (^oC)" offset 0,xloff
set x2label "S (psu)" offset 0,-0.9*xloff
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set ylabel "Z (m)" offset yloff,0
set autoscale x
set xtics 1 rangelimited
set x2tics .1 rangelimited
plot \
datdir.abrev."a.dat" binary format="%f%f%f" u 2:1 w lines axes x1y2 title "T" ls 1,\
datdir.abrev."a.dat" binary format="%f%f%f" u 3:1 w lines axes x2y2 title "S" ls 2
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
unset ytics
set ylabel ""
set y2label "Z (m)" offset -yloff,0
set y2tics mirror -70,20,-10 offset -ytoff,0
set xrange [-.6:.6]
set x2range [-.6:.6]
set xlabel "U (m/s)"
set x2label "V (m/s)" offset 0,-.9*xloff
set xtics .2 rangelimited
set x2tics .2 rangelimited
set yzeroaxis
plot \
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 2:(-$1) w lines axes x1y2 title "U "   ls 1 ,\
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 3:(-$1) w lines axes x2y2 title "V "   ls 2 ,\
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 4:(-$1) w lines axes x1y2 title "U_{L5}" ls 3,\
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 5:(-$1) w lines axes x2y2 title "V_{L5}" ls 5
unset multiplot
