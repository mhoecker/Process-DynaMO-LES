reset
abrev = "ObsSimSideTSUVwSurf"
Tmin = 26.5
Tmax = 30.20
Smin = 35.00
Smax = 35.54
UVmin = -0.9
UVmax = +0.9
load "/home/mhoecker/tmp/limits.plt"
set output outdir.abrev.termsfx
#
# Setup spacing
rows = 5
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
cbform = "%+04.2f"
set multiplot title "Profiles and Surface Forcings"
set style data lines
# Surface Observations
set format x ""
set format x2 ""
set ylabel "J_h (W/m^2)" offset yloff,0
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set autoscale y
set key l t
set xrange  [t0sim:tfsim]
set xtics t0sim+.25,.25,tfsim-.25 mirror
set ytics nomirror -900,300,900 offset ytoff,0
plot datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:2 axis x2y1 notitle ls 1
#, datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:3
#
set ylabel ""
unset yrange
unset ytics
set format y ""
set format x ""
set format x2 ""
set y2range [-.1:.8]
set y2tics nomirror -0,.2,.6 offset -ytoff,0
set y2label "{/Symbol t} (Pa)" offset -yloff,0
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
plot datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:4 axes x1y2 title "{/Symbol t}_x" ls 2,\
datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:5 axes x1y1 title "{/Symbol t}_y" ls 3
unset x2tics
unset y2tics
unset y2range
unset y2label
unset x2label
#
# Profile Observations
#
set xtics mirror
set ytics mirror -70,20,-10 offset ytoff,0
set yrange[-dsim:0]
# Temperature
set cblabel "T (^oC)"
cbmin = Tmin
cbmax = Tmax
load outdir."pospal.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set format cb cbform
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
unset colorbox
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."c.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x ""
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
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
unset colorbox
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."e.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x ""
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir.abrev."f.dat" binary matrix w image notitle
unset colorbox
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
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "u"
plot datdir.abrev."g.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x ""
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
plot datdir.abrev."h.dat" binary matrix w image notitle
# V velocity
# Observed
unset colorbox
set ylabel "Z (m)"
set format y "%g"
set format x "%g"
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "v"
set xlabel "Observed Fields"
plot datdir.abrev."i.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x "%g"
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),1.9*vskip
row = nextrow(row)
set xlabel "Simulated Fields"
plot datdir.abrev."j.dat" binary matrix w image notitle
unset colorbox
unset multiplot
