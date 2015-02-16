load termfile
set output pngdir.abrev.termsfx
# Setup vertical spacing
rows = 3
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
set multiplot title "Surface Flux Comparison"
#
#
load scriptdir."tlocbloc.plt"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set key b r horizontal
set y2label "Buoyancy Flux\n({/Symbol m}W/kg)"
set format x ""
#phi(x) = x/(1+abs(x))
phi(x) = x/1e-6
set format y "%+4.1te^{%+02T}"
set format y "%g"
set ytics -2,.5,2 nomirror
set ytics add ("0" 0)
set yrange [-.75:1.4]
set label 1 "a"
#"Heat g{/Symbol a}J_h/{/Symbol r}C_P"
#"Salt g{/Symbol b}S(E-P)"
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($3)) ls 11 t "Heat", \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($4)) ls 12 t "Salt"
#
set key horizontal b r
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
#set format y "%+4.1te^{%+02T}"
set ytics add ("0" 0)
set yrange [0:24]
set ytics -30,10,30 nomirror
set mytics 10
set ytics add ("0" 0)
set label 1 "b"
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($2)) ls 11 t "Langmuir"
unset y2tics
#
set key t r
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set y2label ""
set autoscale y
set yrange [2e-2:2e0]
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
