load termfile
set output pngdir.abrev.termsfx
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
set xlabel  "T (^oC)"
set x2label "" offset  graph -.6, char -xloff
set label 35 "S (g/kg)" at graph 0, graph 1 right nopoint offset character 0, .5
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set ylabel "Z (m)" offset yloff,0
set autoscale x
set xrange [25.4:30.1]
set xtics 1.5
set x2range [35.2:35.8]
set x2tics 35.3,.2,35.7
set label 1 "a"
plot \
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 2:1 w lines axes x1y2 title "T" ls 11,\
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 3:1 w lines axes x2y2 title "S" ls 12
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
unset ytics
set key t l
set ylabel ""
set y2label "Z (m)" offset -yloff,0
set y2tics nomirror -70,20,-10
set xrange [-.55:.55]
set xlabel  "Vel. (m/s)" offset graph 0, char +xloff
unset label 35
set xtics -.6,.3,.6
unset x2tics
set mxtics 3
set yzeroaxis
set label 1 "b"
plot \
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 4:1 w lines axes x1y2 title "U "   ls 11 ,\
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 5:1 w lines axes x1y1 title "V "   ls 12 ,\

unset multiplot
