#
# Plots a stacked set of Forcing and T,S plots
#  Surface Heat (J) and percipitation (P)
#  Observed Temperature
#  Model Temperature
#  Observed Salinity
#  Modeled Sainity
#
load termfile
Tmin = 27.70
Tmax = 30.10
set output pngdir.abrev."T".termsfx
#
# Setup spacing
rows = 3
cols = 1
col = 0
row = 0
load scriptdir."tlocbloc.plt"
#
cbform = "%04.2f"
set multiplot title "Surface Heat Flux & Temperature Profiles"
set style data lines
# Surface Observations
set format x ""
set format x2 ""
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set autoscale y
set key l t
set ylabel "J_h (kW/m^2)" offset yloff,0
set ytics mirror -1,.5,1 offset ytoff,0
set label 1 "a"
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:(0.001*$2) title "J_h" lc rgbcolor "black"
#
# Profile Observations
#
#load limfile
#load scriptdir."tlocbloc.plt"
set key inside b l opaque
set format y "%g"
set ylabel "Z (m)"
set ytics -70,20,10
set yrange [-dsim:0]
# Temperature
set cblabel "T (^oC)" offset -yloff/2
cbmin = Tmin
cbmax = Tmax
load pltdir."pospalnan.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax
set format cb cbform
# Observed
set format x ""
unset colorbox
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set label 1 "b"
plot datdir.abrev."To.dat" binary matrix w image title "Observed",\
datdir.abrev."MLchm.dat" binary form="%float%float" u 1:2 ls -1 title MLtext
# Simulated
set format x "%g"
set xlabel "2011 UTC yearday"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
set label 1 "c"
plot datdir.abrev."Ts.dat" binary matrix w image title "Simulated",\
datdir.abrev."ML.dat" binary form="%float%float" u 1:2 ls -1 title MLtext
unset colorbox
unset multiplot
