#
# Plots a stacked set of Forcing and S plots
#  Percipitation (P)
#  Observed Salinity
#  Modeled Sainity
#
Smin = 35.00
Smax = 35.5
set output outdir.abrev."S".termsfx
#
# Setup spacing
rows = 3
cols = 1
col = 0
row = 0
load scriptdir."tlocbloc.plt"
#
cbform = "%04.2f"
set multiplot title "Precipitation and S Profiles"
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
set ylabel "P (mm/hr)" offset yloff,0
set ytics mirror 0,30,90 offset ytoff,0
set label 1 "a" at graph 0, 1 left front textcolor rgbcolor "grey30" nopoint offset character 0, .3
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:3 title "P" lc rgbcolor "black"
#
#
# Profile Observations
#
load scriptdir."tlocbloc.plt"
set key l b opaque samplen -1 width -.5
set format y "%g"
set ylabel "Z (m)"
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
set label 1 "b"
plot datdir.abrev."So.dat" binary matrix w image title "Observed"
# Simulated
set format x "%g"
set xlabel "2011 UTC yearday"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
set label 1 "c"
plot datdir.abrev."Ss.dat" binary matrix w image title "Simulated"
unset colorbox
unset multiplot
