load termfile
set output pngdir.abrev.termsfx
# Setup vertical spacing
rows = 3
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
set multiplot
#
#
load scriptdir."tlocbloc.plt"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set key b c horizontal
set format x ""
set ytics 10 nomirror offset ytoff,0
set mytics 2
set yrange [0:27]
set ylabel "U_s [cm/s]"
set y2label "{/Symbol l} [m]" offset -yloff,0
set y2tics out 20
set my2tics 4
set y2tics nomirror offset -ytoff,0
set y2range [0:50]
set label 1 "a: Waves"
altdatfile = datdir."ObsSurfEpsJhPrecipTxTyUk.dat"
plot \
altdatfile binary format="%f%f%f%f%f%f%f" u 1:(100*$6) ls 11 axes x1y1 title "U_s"\
,\
altdatfile binary format="%f%f%f%f%f%f%f" u 1:7 ls 12 axes x1y2 title "{/Symbol l}"\
#,\

set ylabel ""
unset y2tics
set y2label ""

#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set key b c horizontal
set ylabel "[{/Symbol m}W/kg]"
set format x ""
#phi(x) = x/(1+abs(x))
phi(x) = x/1e-6
set format y "%+4.1te^{%+02T}"
set format y "%g"
set ytics -1.2,.4,2 nomirror
set ytics add ("0" 0)
set yrange [-1.19:0.5]
set label 1 "b: Buoyancy Flux"
#"Heat g{/Symbol a}J_h/{/Symbol r}C_P"
#"Salt g{/Symbol b}S(E-P)"
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($3)) ls 11 t "Heat", \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($4)) ls 12 t "Salt"

set ylabel ""
#
#
set key t r
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set y2label ""
set autoscale y
set yrange [2e-3:8e0]
set ytics 1e-3,1e1,1e2
set mytics default
#set ytics add ("0" 0)
#phi(x) = x/(1+abs(x))
phi(x) = abs(x)
set logscale y
set label 1 "c"
plot \
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($4)) ls 11 t " Hoenikker \#",\
datdir.abrev."Lat.dat" binary form="%float%float" u 1:(phi($4)) ls 12 t " Turbulent Langmuir \#",\
#datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($2)) ls 2 t " Ho_T",\
#datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($3)) ls 1 t " Ho_S"

unset multiplot
