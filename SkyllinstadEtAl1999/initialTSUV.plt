set output outdir.abrev.termsfx
set multiplot
# Setup spacing
rows = 1
row = 0
cols = 2
col = 0
load scriptdir."tlocbloc.plt"
unset mxtics
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
set xlabel  "T (^oC)"  offset graph 0, char +xloff
set x2label "" offset  graph -.6, char -xloff
set label 35 "S (psu)" at graph 0, graph 1 right nopoint offset character 0, .5
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set ylabel "Z (m)" offset yloff,0
set autoscale x
set xtics 1.5
set x2range [35.1:35.8]
set x2tics 35.3,.2,35.7
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot \
datdir.abrev."a.dat" binary format="%f%f%f" u 2:1 w lines axes x1y2 title "T" ls 1,\
datdir.abrev."a.dat" binary format="%f%f%f" u 3:1 w lines axes x2y2 title "S" ls 2
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
unset ytics
set key t l
set ylabel ""
set y2label "Z (m)" offset -yloff,0
set y2tics mirror -70,20,-10
set xrange [-.6:.6]
set x2range [-.6:.6]
set xlabel  "U (m/s)" offset graph 0, char +xloff
set label 35 "V (m/s)" at graph 1,1 left offset char 0, char .5
set xtics -.2,.2,.4
set x2tics -.2,.2,.2
set yzeroaxis
set label 1 "b"
plot \
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 2:(-$1) w lines axes x1y2 title "U "   ls 1 ,\
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 3:(-$1) w lines axes x2y2 title "V "   ls 2 ,\
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 4:(-$1) w lines axes x1y2 title "U_{L5}" ls 3,\
datdir.abrev."b.dat" binary format="%f%f%f%f%f" u 5:(-$1) w lines axes x2y2 title "V_{L5}" ls 5
unset multiplot
