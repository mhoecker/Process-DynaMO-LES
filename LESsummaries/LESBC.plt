load termfile
set output pngdir.abrev.termsfx
#
# Setup spacing
rows = 2
cols = 1
col = 0
row = 0
#
load scriptdir."tlocbloc.plt"
datfile = datdir.abrev.".dat"
datform = "%f%f%f%f%f%f%f"
#
set autoscale y
#
set multiplot title "Surface Forcing"
set style data lines
set ytics auto
set autoscale y
set key t c horizontal
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol t} [Pa]"
set label 1 "a"
plot \
datfile binary format=datform u 1:4 ls 11 title "zonal",\
datfile binary format=datform u 1:5 ls 12 title "meridional"
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key c r horizontal
#set ytics 500 nomirror offset ytoff,0
set ylabel "J_h [W/m^2]"
set y2label "P-E [mm/h]" offset -yloff,0
set y2tics out 20
unset xzeroaxis
set y2range [-22:62]
set yrange [-410:410]
set ytics 100
set y2tics nomirror offset -ytoff,0
set label 1 "b"
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
plot \
datfile binary format=datform u 1:2 ls 11 title "J_h" \
,\
datfile binary format=datform u 1:3 ls 12 axes x1y2 title "P-E"\
#
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set key b r opaque
#set ytics 10 nomirror offset ytoff,0
#set mytics 2
#set yrange [0:27]
#set ylabel "U_s [cm/s]"
#set y2label "{/Symbol l} [m]" offset -yloff,0
#set y2tics out 20
#set my2tics 4
#set y2tics nomirror offset -ytoff,0
#set y2range [0:50]
#set format x "%g"
#set xlabel "2011 UTC yearday" offset 0,xloff
#set label 1 "c"
#plot \
#datfile binary format="%f%f%f%f%f%f%f" u 1:(100*$6) ls 11 axes x1y1 title "U_s"\
#,\
#datfile binary format="%f%f%f%f%f%f%f" u 1:7 ls 12 axes x1y2 title "{/Symbol l}"\
#,\
#datfile binary format="%f%f%f%f%f%f%f" u 1:(100*$6):(.01) w circles lc pal fraction .75 fs transparent solid .0625 noborder axes x1y1 notitle\
#,\
#datfile binary format="%f%f%f%f%f%f%f" u 1:7:(.01) w circles lc pal fraction .125 fs transparent solid .0625 noborder axes x1y2 notitle\

unset y2tics
unset y2label
#
unset multiplot
