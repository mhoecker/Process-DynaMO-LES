set style data lines
form = "%float%float%float%float%float%float%float%float%float%float"
set output outdir.abrev."flx".termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
dtke = 8e-6
dtketic  = 5e-6
set yrange [-dtke:dtke]
set ytics dtketic
#set autoscale y
#set ytics auto
set multiplot title "Spatial mean of tke flux divergences"
set xtics format ""
set key t l
set style line 1 lc -1 lw 1
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot outdir."tkebzavg.dat" binary format=form u 1:3 title "d<tke>/dt" ls 1
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot outdir."tkebzavg.dat" binary format=form u 1:4 title "<w'tke>" ls 1
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot outdir."tkebzavg.dat" binary format=form u 1:5 title "<sgs>" ls 1
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set xtics format "%g"
plot outdir."tkebzavg.dat" binary format=form u 1:6 title "<w'P'>" ls 1
unset multiplot
#
set output outdir.abrev."src".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
set multiplot title "Spatial mean of tke sources/sinks"
set yrange [-dtke:dtke]
set ytics dtketic
#set autoscale y
#set ytics auto
set xtics format ""
set xtics format "%g"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot outdir."tkebzavg.dat" binary format=form u 1:7 title "<St>" ls 1 ,\
 outdir."tkebzavg.dat" binary format=form u 1:8 title "<SP>" ls 2 ,\
 outdir."tkebzavg.dat" binary format=form u 1:9 title "<w'b'>" ls 3 ,\
 outdir."tkebzavg.dat" binary format=form u 1:10 title "<{/Symbol e}>" ls 4
#
unset multiplot
#
