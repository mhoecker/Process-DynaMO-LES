load termfile
set output outdir.abrev.termsfx
#
# Setup spacing
rows = 3
cols = 1
col = 0
row = 0
#
#set object 1 rectangle from t0sim,graph 0 to tfsim,graph 1 fc rgb "gray90" fs pattern 3
#t0sim=t0sim-.25
#tfsim=tfsim+.25
load scriptdir."tlocbloc.plt"
datfile = datdir.abrev."JhPrecipTxTyUk.dat"
datform = "%f%f%f%f%f%f%f"
#
set autoscale y
#
set multiplot title "Surface Forcing Observetions"
set style data lines
set ytics .5
set yrange [-.2:1.2]
set key t c horizontal
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol t} (Pa)"
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot \
datfile binary format=datform u 1:4 ls 1 title "zonal",\
datfile binary format=datform u 1:5 ls 2 title "meridional"
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key t l horizontal
set ytics .5 nomirror offset ytoff,0
set yrange [-1:1]
set ylabel "J_h (kW/m^2)"
set y2label "P (mm/h)" offset -yloff,0
set y2tics out 30
set y2tics nomirror offset -ytoff,0
set label 1 "b"
plot \
datfile binary format=datform u 1:($2*.001) ls 3 title "J_h" \
,\
datfile binary format=datform u 1:3 ls 4 axes x1y2 title "P"
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key t l opaque
set ytics 4 nomirror offset ytoff,0
set mytics 4
set yrange [0:10]
set ylabel "U_s (cm/s)"
set y2label "{/Symbol l} (m)" offset -yloff,0
set y2tics out 150
set my2tics 3
set y2tics nomirror offset -ytoff,0
set y2range [0:400]
set format x "%g"
#
#set autoscale y
#set autoscale y2
#
set xlabel "2011 UTC yearday" offset 0,xloff
set label 1 "c"
#w filledcurves y1=0 fs transparent solid .5 noborder
#w filledcurves y1=0 fs transparent solid .25 noborder
plot \
datfile binary format="%f%f%f%f%f%f%f" u 1:(100*$6) ls 5 axes x1y1 title "U_s"\
,\
datfile binary format="%f%f%f%f%f%f%f" u 1:7 ls 6 axes x1y2 title "{/Symbol l}"\
,\
#datfile binary format="%f%f%f%f%f%f%f" u 1:(100*$6):(.01) w circles lc pal fraction .75 fs transparent solid .0625 noborder axes x1y1 notitle\
#,\
#datfile binary format="%f%f%f%f%f%f%f" u 1:7:(.01) w circles lc pal fraction .125 fs transparent solid .0625 noborder axes x1y2 notitle\

unset y2tics
unset y2label
#
unset multiplot
