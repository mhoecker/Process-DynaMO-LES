load termfile
set style data lines
form = "%float%float%float%float%float%float%float%float%float%float%float"
set output pngdir.abrev."flx".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
dtke = 1e-6
dtketic  = 1e-6
set yrange [-1.1*dtketic:1.5*dtketic]
set ytics dtketic
#set autoscale y
set y2label "W/kg"
set ytics format "%1.0g"
set ytics add ("0" 0)
set multiplot title "Spatial mean of tke flux divergences"
set xtics format ""
set key horiz t c
load pltdir."sympalnan.plt"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

set xtics format "%g"
plot datdir."tkebzavg.dat" binary format=form u 1:3 title "<^{d}/_{dt}tke>" ls 6,\
 datdir."tkebzavg.dat" binary format=form u 1:4 title "<w'tke>" ls 7,\
 datdir."tkebzavg.dat" binary format=form u 1:5 title "<sgs>" ls 8,\
 datdir."tkebzavg.dat" binary format=form u 1:6 title "<w'P'>" ls 9
unset multiplot
unset y2label
#
set output pngdir.abrev."src".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
set multiplot title "Spatial mean of tke sources/sinks"
dtkescale = 1e-6;
dtkepfx = "{/Symbol m}"
set ylabel dtkepfx."W/kg"
set ytics dtketic/dtkescale
set yrange [-2.2*dtketic/dtkescale:2.2*dtketic/dtkescale]
set xtics format ""
set xtics format "%g"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot datdir."tkebzavg.dat" binary format=form u 1:($7/dtkescale) title "<St>" ls 1 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($8/dtkescale) title "<SP>" ls 2 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($9/dtkescale) title "<w'b'>" ls 3 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($10/dtkescale) title "<{/Symbol e}>" ls 4 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($11/dtkescale) title "<{/Symbol a\321}^{12}>" ls 5

#
unset multiplot
#
set output pngdir.abrev."scaledsrc".termsfx
# Setup spacing
rows = 1
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
set multiplot title "Spatial mean of tke sources/sinks"
set yrange [-1.2:1.9]
set ytics 1
unset y2label
set ylabel "Energy flux fraction"
set xtics format ""
set xtics format "%g"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)

plot datdir."scaledtkebzavg.dat" binary format=form u 1:7 title "<St>" ls 1 ,\
 datdir."scaledtkebzavg.dat" binary format=form u 1:8 title "<SP>" ls 2 ,\
 datdir."scaledtkebzavg.dat" binary format=form u 1:9 title "<w'b'>" ls 3 ,\
 datdir."scaledtkebzavg.dat" binary format=form u 1:10 title "<{/Symbol e}>" ls 4 ,\
 datdir."scaledtkebzavg.dat" binary format=form u 1:11 title "<{/Symbol a\321}^{12}>" ls 5
#
unset multiplot
#
#
set output pngdir.abrev."tkescalesrc".termsfx
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

plot datdir."tkescaletkebzavg.dat" binary format=form u 1:7 title "<St>" ls 1 ,\
 datdir."tkescaletkebzavg.dat" binary format=form u 1:8 title "<SP>" ls 2 ,\
 datdir."tkescaletkebzavg.dat" binary format=form u 1:9 title "<w'b'>" ls 3 ,\
 datdir."tkescaletkebzavg.dat" binary format=form u 1:10 title "<{/Symbol e}>" ls 4 ,\
 datdir."tkescaletkebzavg.dat" binary format=form u 1:11 title "<{/Symbol a\321}^{12}>" ls 5
#
unset multiplot
#
