load termfile
set style data lines
form = "%float%float%float%float%float%float%float%float%float%float%float"
set output outdir.abrev."flx".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
dtke = 8e-6
dtketic  = 5e-6
set yrange [-1.2*dtketic:1.7*dtketic]
set ytics dtketic
#set autoscale y
set y2label "W/kg"
set ytics format "%1.0g"
set ytics add ("0" 0)
set multiplot title "Spatial mean of tke flux divergences"
set xtics format ""
set key horiz t c
load outdir."sympalnan.plt"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

set xtics format "%g"
plot outdir."tkebzavg.dat" binary format=form u 1:3 title "<^{d}/_{dt}tke>" ls 6,\
 outdir."tkebzavg.dat" binary format=form u 1:4 title "<w'tke>" ls 7,\
 outdir."tkebzavg.dat" binary format=form u 1:5 title "<sgs>" ls 8,\
 outdir."tkebzavg.dat" binary format=form u 1:6 title "<w'P'>" ls 9
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
set ytics dtketic
set yrange [-1.2*dtketic:1.7*dtketic]
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
 outdir."tkebzavg.dat" binary format=form u 1:10 title "<{/Symbol e}>" ls 4 ,\
 outdir."tkebzavg.dat" binary format=form u 1:11 title "<{/Symbol a\321}^{12}>" ls 5

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
set yrange [-1.2:1.9]
set ytics 1
#set autoscale y
#set ytics auto
unset y2label
set ylabel "Energy flux fraction"
set xtics format ""
set xtics format "%g"
#
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
#
set output outdir.abrev."tkescalesrc".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
set multiplot title "Spatial mean of tke sources/sinks"
tkefreq = 1e-2
set yrange [0*tkefreq:1.5*tkefreq]
set ytics tkefreq
unset ylabel
set y2label "Energy flux frequency (sec^{-1})"
set xtics format ""
set xtics format "%g"
#
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot outdir."tkescaletkebzavg.dat" binary format=form u 1:7 title "<St>" ls 1 ,\
 outdir."tkescaletkebzavg.dat" binary format=form u 1:8 title "<SP>" ls 2 ,\
 outdir."tkescaletkebzavg.dat" binary format=form u 1:9 title "<w'b'>" ls 3 ,\
 outdir."tkescaletkebzavg.dat" binary format=form u 1:10 title "<{/Symbol e}>" ls 4 ,\
 outdir."tkescaletkebzavg.dat" binary format=form u 1:11 title "<{/Symbol a\321}^{12}>" ls 5
#
unset multiplot
#
