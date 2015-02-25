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
unset xzeroaxis
#
#
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set xtics nomirror offset 0,xtoff
set x2tics nomirror offset 0,-xtoff
set yrange [-dsim:0]
set ytics nomirror -70,20,-10 offset ytoff,0
set xlabel  "T [^oC]"
set x2label "" offset  graph -.6, char -xloff
set label 35 "S [g/kg]" at graph .5, graph 1 center nopoint offset character 0, 1.25
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set ylabel "Z [m]" offset yloff,0
set border 7
set key t l
set xrange [Tmin:Tmax]
set xtics 1
set xtics rangelimited
set x2range [Smin:Smax]
set x2tics .5 rangelimited
set x2tics add (35,36)
set label 1 "a"
plot \
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 2:1 w lines axes x1y1 title "T" ls 11,\
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 3:1 w lines axes x2y1 title "S" ls 12
unset label 35
#
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
unset ytics
set key b r
set ylabel ""
set y2label ""
unset y2tics
unset ytics
set border 1
set xrange [UVmin:UVmax]
set xlabel  "Vel. [m/s]" offset graph 0, char +xloff
set xtics .2
unset x2tics
set yzeroaxis
set label 1 "b"
plot \
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 4:1 w lines axes x1y1 title "U "   ls 11 ,\
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 5:1 w lines axes x1y1 title "V "   ls 12 ,\

unset multiplot
