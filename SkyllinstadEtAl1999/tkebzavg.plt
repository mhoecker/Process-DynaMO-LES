load termfile
set style data lines
form = "%float%float%float%float%float%float%float%float%float%float%float"
dtke = 1e-6
dtketic  = 1e-6
set output pngdir.abrev."src".termsfx
# Setup spacing
rows = 2
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
set multiplot
# Plot tke
tkemax = 5
tkemin = 0
set ylabel "z [m]"
load pltdir.abrev."timedepth.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,+cbhig
set yrange [-dsim:0]
set format x ""
set xlabel ""
set cblabel "mJ/kg"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/2,tkemax;set cbtics add ("0" 0)
load pltdir."pospal.plt"
field = "tke"
set label 1 "a: Turbulent Kinetic Energy"
plot datdir."tkeBudgtke.dat" binary matrix u 1:2:($3*1000) w image not
set size ratio 0
#
row = nextrow(row)
unset colorbox
set ylabel ""
set cblabel ""
set autoscale cb
# Plot integradted tke sources and sinks
dtkescale = 1e-6;
dtkepfx = "{/Symbol m}"
set ylabel dtkepfx."W/kg"
set ytics dtketic/dtkescale
set yrange [-2.2*dtketic/dtkescale:3.2*dtketic/dtkescale]
set xtics format ""
set xtics format "%g"
set xlabel "2011 UTC yearday"
load pltdir."sympalnan.plt"
set key horizontal t l
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set label 1 "b: Sources and Sinks"

plot datdir."tkebzavg.dat" binary format=form u 1:($7/dtkescale) title "<St>" ls 1 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($8/dtkescale) title "<SP>" ls 2 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($9/dtkescale) title "<w'b'>" ls 3 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($10/dtkescale) title "<{/Symbol e}>" ls 4 ,\
 datdir."tkebzavg.dat" binary format=form u 1:($11/dtkescale) title "<{/Symbol a\321}^{12}>" ls 5

	#
unset multiplot
