#
# Plots a stacked set of Forcing and S plots
#  Percipitation (P)
#  Observed Salinity
#  Modeled Sainity
#
Smin = 34.7
Smax = 35.5
load termfile
set output pngdir.abrev."S".termsfx
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
set label 1 "a"
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:3 title "P" lc rgbcolor "black"
#
#
# Profile Observations
#
set key l b opaque
set format y "%g"
set ylabel "Z (m)"
set ytics -70,20,10
set yrange [-dsim:0]
# Salinity
load pltdir."negpalnan.plt"
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
plot datdir.abrev."So.dat" binary matrix w image not, 0 lw 0 title "Observed",\
datdir.abrev."MLchm.dat" binary form="%float%float" u 1:2 ls -1 title MLtext
# Simulated
set format x "%g"
set xlabel "2011 UTC yearday"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
set label 1 "c"
plot datdir.abrev."Ss.dat" binary matrix w image not, 0 lw 0 title "Simulated",\
datdir.abrev."ML.dat" binary form="%float%float" u 1:2 ls -1 title MLtext
unset colorbox
unset multiplot
