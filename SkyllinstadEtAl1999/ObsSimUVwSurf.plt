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
set key t l
set yrange [-.1:.9]
set ytics mirror -0,.4,.8 offset ytoff,0
set ylabel "{/Symbol t} (Pa)" offset yloff,0
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:4 axes x1y1 title "{/Symbol t}_x" lc rgbcolor "black"
#,\
#datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:5 axes x1y1 title "{/Symbol t}_y" lc rgbcolor "grey50"
#
# Profile Observations
#
load scriptdir."tlocbloc.plt"
set key opaque b l
set ylabel "Z (m)"
set format y "%g"
# U Velocity
set format cb cbform
set cblabel "u (m/s)" offset -yloff/2
cbmin = UVmin
cbmax = UVmax
load outdir."pospalnan.plt"
set cbrange [0:cbmax]
set cbtics cbmin,(cbmax-cbmin),cbmax;set cbtics add ("0" 0)
# Observed
unset colorbox
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."Uo.dat" binary matrix w image title "Observed"
# Simulated
set format x "%g"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set xlabel "2011 UTC yearday"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,vskip+cbhig
plot datdir.abrev."Us.dat" binary matrix w image title "Simulated"
# V velocity
# Observed
#unset colorbox
#set format x ""
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#plot datdir.abrev."Vo.dat" binary matrix w image notitle
# Simulated
#set format x "%g"
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,3*vskip+cbhig
#set xlabel "2011 UTC yearday"
#plot datdir.abrev."Vs.dat" binary matrix w image notitle
#unset colorbox
unset multiplot
