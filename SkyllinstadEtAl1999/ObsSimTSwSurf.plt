#
# Plots a stacked set of Forcing and T,S plots
#  Surface Heat (J) and percipitation (P)
#  Observed Temperature
#  Model Temperature
#  Observed Salinity
#  Modeled Sainity
#
reset
abrev = "ObsSimSideTSUVwSurf"
abrev1 = "ObsSimTSwSurf"
Tmin = 26.5
Tmax = 30.20
Smin = 35.00
Smax = 35.54
load "/home/mhoecker/tmp/limits.plt"
set output outdir.abrev1.termsfx
#
# Setup spacing
rows = 5
cols = 1
col = 0
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
cbform = "%+04.2f"
set multiplot title "T,S Profiles and Surface Forcings"
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
set xrange  [t0sim:tfsim]
set xtics t0sim,.25,tfsim mirror
set ylabel "J_h (W/m^2)" offset yloff,0
set ytics nomirror -900,300,900 offset ytoff,0
set y2label "P (mm/hr)" offset -yloff,0
set y2tics nomirror 0,20,90 offset -ytoff,0
plot datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:2 axis x1y1 title "J_h" lc rgbcolor "red",\
datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:3 axis x1y2 title "P" lc rgbcolor "blue"
unset y2tics
#
#
# Profile Observations
#
set xtics mirror
set ytics mirror -70,20,-10 offset ytoff,0
set yrange[-dsim:0]
set format y "%g"
# Temperature
set cblabel "T (^oC)"
cbmin = Tmin
cbmax = Tmax
load outdir."pospal.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set format cb cbform
# Observed
set ylabel "T_{obs},Z (m)"
set format x ""
unset colorbox
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."c.dat" binary matrix w image notitle
# Simulated
set ylabel "T_{sim},Z (m)"
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col),bloc(row)+.1*vskip size .1*(1-rloc(col)),1.8*vskip
plot datdir.abrev."d.dat" binary matrix w image notitle
unset colorbox
# Salinity
load outdir."negpal.plt"
set cblabel "S (psu)"
cbmin = Smin
cbmax = Smax
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set format cb cbform
# Observed
set ylabel "S_{obs},Z (m)"
unset colorbox
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."e.dat" binary matrix w image notitle
# Simulated
set ylabel "S_{sim},Z (m)"
set format x "%g"
set xlabel "2011 UTC yearday"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col),bloc(row)+.1*vskip size .1*(1-rloc(col)),1.8*vskip
plot datdir.abrev."f.dat" binary matrix w image notitle
unset colorbox
unset multiplot
