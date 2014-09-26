#
# Plots a stacked set of Forcing and T,S plots
#  Surface Heat (J) and percipitation (P)
#  Observed Temperature
#  Model Temperature
#  Observed Salinity
#  Modeled Sainity
#
Tmin = 28.2
Tmax = 30.20
Smin = 35.00
Smax = 35.5
set output outdir.abrev."TSwSurf".termsfx
load termfile
#
# Setup spacing
rows = 5
cols = 1
col = 0
row = 0
load scriptdir."tlocbloc.plt"
#
cbform = "%04.2f"
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
set ylabel "J_h (W/m^2)" offset yloff,0
set ytics nomirror -900,300,900 offset ytoff,0
set y2label "P (mm/hr)" offset -yloff,0
set y2tics nomirror 0,20,90 offset -ytoff,0
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:2 axis x1y1 title "J_h" lc rgbcolor "red",\
datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:3 axis x1y2 title "P" lc rgbcolor "blue"
unset y2tics
unset y2label
#
#
# Profile Observations
#
load scriptdir."tlocbloc.plt"
set key opaque inside top left
set format y "%g"
set ylabel "Z (m)"
# Temperature
set cblabel "T (^oC)" offset -yloff/2
cbmin = Tmin
cbmax = Tmax
load outdir."pospalnan.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax
set format cb cbform
# Observed
set format x ""
unset colorbox
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."To.dat" binary matrix w image title "Observed"
# Simulated
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
plot datdir.abrev."Ts.dat" binary matrix w image title "Simulated"
unset colorbox
# Salinity
load outdir."negpalnan.plt"
set cblabel "S (psu)"
cbmin = Smin
cbmax = Smax
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax
set format cb cbform
# Observed
unset colorbox
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."So.dat" binary matrix w image title "Observed"
# Simulated
set format x "%g"
set xlabel "2011 UTC yearday"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
plot datdir.abrev."Ss.dat" binary matrix w image title "Simulated"
unset colorbox
unset multiplot
