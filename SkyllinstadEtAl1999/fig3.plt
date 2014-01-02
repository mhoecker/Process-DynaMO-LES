reset
Tmin = 26.75
Tmax = 30.25
Smin = 34.75
Smax = 35.75
UVmin = -0.25
UVmax = +1.0
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig3".termsfx
set view map
unset colorbox
unset surface
set pm3d
#
# Setup vertical spacing
rows = 5
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
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
set ytics nomirror 300 rangelimited offset ytoff,0
plot datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:2 axis x2y1 notitle ls 1
#, datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:3
#
unset ylabel
unset yrange
unset ytics
set format y ""
set y2range [-.1:.8]
set y2tics nomirror -0,.2,.6 offset -ytoff,0
set y2label "{/Symbol t} (Pa)" offset -yloff,0
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
plot datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:4 axes x2y2 title "{/Symbol t}_x" ls 2,\
datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:5 axes x2y2 title "{/Symbol t}_y" ls 3
unset x2tics
unset y2tics
unset y2range
unset y2label
unset x2label
#
# Profile Observations
#
set xtics mirror
set ytics mirror -70,20,-10
set yrange[-dsim:0]
# Temperature
set cblabel "T (^oC)"
cbmin = 26.5#Tmin
cbmax = 30.5#Tmax
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set format cb "%4.1f"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir."fig3c.dat" binary matrix w image notitle
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir."fig3d.dat" binary matrix w image notitle
unset colorbox
# Salinity
set cbrange [35.0:35.8]
set cblabel "S (psu)"
cbmin = 35.0#Smin
cbmax = 35.8#Smax
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set format cb "%4.1f"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir."fig3e.dat" binary matrix w image notitle
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir."fig3f.dat" binary matrix w image notitle
unset colorbox
# U Velocity
set cbrange [-.2:1.2]
set format cb "%4.2f"
set cblabel "u,v (m/s)"
cbmin = -0.2#umin
cbmax = 1.2#umax
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "u"
plot datdir."fig3g.dat" binary matrix w image notitle
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
plot datdir."fig3h.dat" binary matrix w image notitle
# V velocity
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x "%g"
set lmargin at screen lloc
set rmargin at screen mloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "v"
set xlabel "Observed Fields"
plot datdir."fig3i.dat" binary matrix w image notitle
# Simulated
unset ylabel
set format y ""
set format x "%g"
set lmargin at screen mloc
set rmargin at screen rloc
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),1.9*vskip
row = nextrow(row)
set xlabel "Simulated Fields"
plot datdir."fig3j.dat" binary matrix w image notitle
unset colorbox
unset multiplot
