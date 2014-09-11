set style data lines
form = "%float%float%float%float%float%float%float%float%float%float%float"
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
load outdir."sympalnan.plt"
set cbrange [0:1]
unset colorbox
set style line 1 lc pal cb 0 lw 1
set style line 2 lc pal cb .25 lw 1
set style line 3 lc pal cb .5 lw 1
set style line 4 lc pal cb .75 lw 1
set style line 5 lc pal cb 1 lw 1
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
 outdir."tkebzavg.dat" binary format=form u 1:($10+$11) title "<{/Symbol e}>+<{/Symbol a\321}^{12}>" ls 4
#
unset multiplot
#
set output outdir.abrev."scaledsrc".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
set multiplot title "Spatial mean of tke sources/sinks"
set yrange [-1.7:1.7]
set ytics 1
set key t rm
#set autoscale y
#set ytics auto
set ylabel "Energy flux fraction"
set xtics format ""
set xtics format "%g"
#
set style fill  transparent solid 0.125 border
#set style data filledcurves y1=0
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot outdir."scaledtkebzavg.dat" binary format=form u 1:7 title "<St>" ls 1 ,\
 outdir."scaledtkebzavg.dat" binary format=form u 1:8 title "<SP>" ls 2 ,\
 outdir."scaledtkebzavg.dat" binary format=form u 1:9 title "<w'b'>" ls 3 ,\
 outdir."scaledtkebzavg.dat" binary format=form u 1:10 title "<{/Symbol e}>" ls 4 ,\
 outdir."scaledtkebzavg.dat" binary format=form u 1:11 title "<{/Symbol a\321}^{12}>" ls 5
#
unset multiplot
#
