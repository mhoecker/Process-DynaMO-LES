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
set x2tics nomirror scale .5 	offset 0,-xtoff
set yrange [-dsim:0]
#set ytics nomirror -70,20,-10 offset ytoff,0
set xlabel  "T [^oC]"
set x2label "S [g/kg]" offset  graph 0, char -2
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set ylabel "z [m]" offset yloff,0
set border 7
set key c c
set xrange [Tmin:Tmax]
set xtics in .5
set xtics rangelimited
set x2range [Smin:Smax]
set format x2 "%3.1f"
set x2tics .1 rangelimited rotate by -90 offset 0,-1
set key title "a"
plot \
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 2:1 w lines axes x1y1 title "T" ls 11,\
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 3:1 w lines axes x2y1 title "S" ls 12
unset label 35
unset x2label
#
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
unset ytics
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
set key title "b"
set key c c
plot \
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 4:1 w lines axes x1y1 title "U "   ls 11 ,\
datdir.abrev."TSUV.dat" binary format="%f%f%f%f%f" u 5:1 w lines axes x1y1 title "V "   ls 12 ,\

unset multiplot
