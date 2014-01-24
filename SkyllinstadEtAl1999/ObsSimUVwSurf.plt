reset
abrev = "ObsSimSideTSUVwSurf"
abrev2 = "ObsSimUVwSurf"
UVmin = -0.9
UVmax = +0.9
cbform = "%+04.2f"
load "/home/mhoecker/tmp/limits.plt"
set output outdir.abrev2.termsfx
#
# Setup spacing
rows = 5
row = 0
cols = 1
col = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "U,V Profiles and Surface Forcings"
# Common plot properties
set lmargin at screen lloc(row)
set rmargin at screen rloc(col)
set style data lines
set xrange  [t0sim:tfsim]
set xtics t0sim+.25,.25,tfsim-.25 mirror
# Surface Observations
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key l t
set yrange [-.1:.8]
set ytics nomirror -0,.2,.6 offset ytoff,0
set ylabel "{/Symbol t} (Pa)" offset yloff,0
plot datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:4 axes x1y2 title "{/Symbol t}_x" lc rgbcolor "black",\
datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:5 axes x1y1 title "{/Symbol t}_y" lc rgbcolor "grey"
#
# Profile Observations
#
set xtics mirror
set ytics mirror -70,20,-10 offset ytoff,0
set yrange[-dsim:0]
# U Velocity
set format cb cbform
set cblabel "u,v (m/s)"
cbmin = UVmin
cbmax = UVmax
load outdir."sympal.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
# Observed
unset colorbox
set ylabel "U_{obs},Z (m)"
set format y "%g"
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."g.dat" binary matrix w image notitle
# Simulated
set ylabel "U_{sim},Z (m)"
set format x ""
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."h.dat" binary matrix w image notitle
# V velocity
# Observed
unset colorbox
set ylabel "V_{obs},Z (m)"
set format y "%g"
set format x "%g"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."i.dat" binary matrix w image notitle
# Simulated
set ylabel "V_{sim},Z (m)"
set format x "%g"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col),bloc(row)+.1*vskip size .1*(1-rloc(col)),3.8*vskip
set xlabel "2011 UTC yearday"
plot datdir.abrev."j.dat" binary matrix w image notitle
unset colorbox
unset multiplot
