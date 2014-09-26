UVmin = -0.9
UVmax = +0.9
cbform = "%+04.2f"
set output outdir.abrev."UVwSurf".termsfx
#
# Setup spacing
rows = 3
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
load termfile
#
set multiplot title "U Profiles and Surface Forcings"
# Common plot properties
set lmargin at screen lloc(row)
set rmargin at screen rloc(col)
set style data lines
set xrange  [t0sim:tfsim]
# Surface Observations
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key t r
set yrange [-.1:.9]
set ytics mirror -0,.4,.8 offset ytoff,0
set ylabel "{/Symbol t} (Pa)" offset yloff,0
set label 1 "a" at graph 0, 1 left front textcolor rgbcolor "grey30" nopoint offset character 0, .3
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:4 axes x1y1 title "{/Symbol t}_x" lc rgbcolor "black"
#
# Profile Observations
#
set key b l opaque samplen -1 width -.5
set ylabel "Z (m)"
set format y "%g"
# U Velocity
set format cb cbform
set cblabel "u (m/s)" offset -yloff/2
cbmin = UVmin
cbmax = UVmax
load limfile
load outdir."pospalnan.plt"
set cbrange [0:cbmax]
set cbtics cbmin,cbmax/2,cbmax;set cbtics add ("0" 0)
# Observed
unset colorbox
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set label 1 "b"
plot datdir.abrev."Uo.dat" binary matrix w image title "Observed"
# Simulated
set format x "%g"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set xlabel "2011 UTC yearday"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,vskip+cbhig
set label 1 "c"
plot datdir.abrev."Us.dat" binary matrix w image title "Simulated"
unset multiplot
