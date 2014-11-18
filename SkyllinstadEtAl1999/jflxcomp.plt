load termfile
set output outdir.abrev.termsfx
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
set key horizontal t l
set y2label "Buoyancy Flux\n10^{-6} (m^2/s^2/s)"
set format x ""
#phi(x) = x/(1+abs(x))
phi(x) = x/1e-6
set format y "%+4.1te^{%+02T}"
set format y "%g"
set ytics -24,12,24 mirror
set ytics add ("0" 0)
set yrange [-15:15]
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($3)) ls 2 t "Thermal (g{/Symbol a}J_h/{/Symbol r}C_P)", \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($4)) ls 1 t "Saline (g{/Symbol b}S(E-P))"
#
set key horizontal t l
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
#set format y "%+4.1te^{%+02T}"
set ytics add ("0" 0)
set yrange [0:30]
set label 1 "b"
plot \
datdir.abrev."Bflx.dat" binary form="%float%float%float%float" u 1:(phi($2)) ls 3 t "Langmuir (Uk{/Symbol t}/{/Symbol r})"
#
set key top center
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set y2label "|Hoenikker\n Number|"
set yrange [5e-4:5e3]
set ytics 1e-3,1e3,1e3
#set ytics add ("0" 0)
#phi(x) = x/(1+abs(x))
phi(x) = abs(x)
set logscale y
set label 1 "c"
plot \
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($4)) ls 3 lw 2 t " Ho",\
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($2)) ls 2 t " Ho_T",\
datdir.abrev."HoTS.dat" binary form="%float%float%float%float" u 1:(phi($3)) ls 1 t " Ho_S"
unset multiplot
