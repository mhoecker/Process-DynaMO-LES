set output outdir.abrev.termsfx
set style data lines
# Setup vertical spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
load outdir."sympal.plt"
#
set multiplot title "Surface Flux Comparison"
#
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
Jmax = 900
Jmin = -900
set yrange [Jmin:Jmax]
set ytics nomirror
set ytics -800,400,800
set y2tics nomirror
set y2tics 0,25,100
set autoscale y2
set ylabel "W/m^2"
set y2label "mm/hr"
cbform = "%+03.0f"
set autoscale cb
set format x ""
set key horizontal
set key left top
set key samplen 1
plot \
datdir.abrev."surf.dat" binary format="%float%float%float" u 1:2 t "Heat Flux",\
datdir.abrev."surf.dat" binary format="%float%float%float" u 1:3 axes x1y2 t "Rain Rate"
#
unset y2tics
unset y2label
load scriptdir."tlocbloc.plt"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set y2label "Buoyancy\n Flux (m^2/s^2/s)"
set format x ""
#phi(x) = x/(1+abs(x))
phi(x) = x
set format y "%+4.1te^{%+02T}"
set ytics -6e-6,3e-6,6e-6 mirror
set ytics add ("0" 0)
set yrange [-7e-6:5e-6]
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($3)) t "Thermal (g{/Symbol a}J_h/{/Symbol r}C_P)", \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($4)) t "Saline (g{/Symbol b}S(E-P))"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set format y "%+4.1te^{%+02T}"
set ytics 4e-4,4e-4,1.2e-3 mirror
set ytics add ("0" 0)
set yrange [0:1.5e-3]
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($2)) t "Langmuir buoyancy flux scale (Uk{/Symbol t}/{/Symbol r})"
#
set key top center
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set y2label "Hoenikker\n Number"
set yrange [-.12:.09]
set ytics .05
set ytics add ("0" 0)
unset colorbox
#phi(x) = x/(1+abs(x))
phi(x) = x
plot \
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($4)) ls 3 lw 2 t " Ho",\
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($2)) ls 1 t " Ho_T",\
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($3)) ls 2 t " Ho_S"
unset multiplot
