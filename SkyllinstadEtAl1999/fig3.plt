reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig3".termsfx
set palette maxcolors 8
set pm3d
set view map
unset colorbox
unset surface
set multiplot
set style data lines
set ytics
# Surface Observations
set format x ""
set ylabel "J_h (W/m^2)"
set lmargin at screen .15
set rmargin at screen .5
set tmargin at screen .9
set bmargin at screen .75
set xrange [t0sim:tfsim]
set x2range [t0sim:tfsim]
set x2tics t0sim+.25,.25,tfsim-.25
set xtics t0sim+.25,.25,tfsim-.25
set x2label "2011 year day"
set yrange [-1000:1000]
set ytics nomirror -800,400,800
plot datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:2 axis x2y1 title "J_h" ls 1
#, datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:3
#
unset ylabel
unset yrange
unset ytics
set format y ""
set x2label "2011 year day"
set y2range [-.1:.8]
set y2tics nomirror -0,.2,.6
set y2label "{/Symbol t} (Pa)"
set lmargin at screen .5
set rmargin at screen .85
set tmargin at screen .9
set bmargin at screen .75
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
set cbrange [26.5:30.5]
set cblabel "T (^oC)"
set cbtics 26.5,4.0/8.,30.5
set format cb "%4.2f"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen .15
set rmargin at screen .5
set tmargin at screen .75
set bmargin at screen .6
splot datdir."fig3c.dat" binary matrix title "T_{obs}"
# Simulated
unset ylabel
set colorbox user origin .85,.61 size .01,.14
set format y ""
set format x ""
set lmargin at screen .5
set rmargin at screen .85
set tmargin at screen .75
set bmargin at screen .6
splot datdir."fig3d.dat" binary matrix title "T_{sim}"
unset colorbox
# Salinity
set cbrange [35.2:35.7]
set cblabel "S (psu)"
set cbtics 35.2,.5/8.,35.7
set format cb "%4.2f"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen .15
set rmargin at screen .5
set tmargin at screen .6
set bmargin at screen .45
splot datdir."fig3e.dat" binary matrix title "S_{obs}"
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen .5
set rmargin at screen .85
set tmargin at screen .6
set bmargin at screen .45
set colorbox user origin .85,.45 size .01,.14
splot datdir."fig3f.dat" binary matrix title "S_{sim}"
unset colorbox
# U Velocity
set cbrange [-.2:1.2]
set cbtics -.2,1.4/8.,1.2
set format cb "%4.2f"
set cblabel "u,v (m/s)"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen .15
set rmargin at screen .5
set tmargin at screen .45
set bmargin at screen .3
splot datdir."fig3g.dat" binary matrix title "u_{obs}"
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen .5
set rmargin at screen .85
set tmargin at screen .45
set bmargin at screen .3
splot datdir."fig3h.dat" binary matrix title "u_{sim}"
# V velocity
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x "%g"
set lmargin at screen .15
set rmargin at screen .5
set tmargin at screen .3
set bmargin at screen .15
splot datdir."fig3i.dat" binary matrix title "v_{obs}"
# Simulated
unset ylabel
set format y ""
set format x "%g"
set lmargin at screen .5
set rmargin at screen .85
set tmargin at screen .3
set bmargin at screen .15
set colorbox user origin .85,.15 size .01,.28
splot datdir."fig3j.dat" binary matrix title "v_{sim}"
unset colorbox
unset multiplot
set term wxt
