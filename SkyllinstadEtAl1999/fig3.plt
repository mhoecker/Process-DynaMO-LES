reset
datdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/'
#set term png enhanced size 1536,1024 truecolor nocrop linewidth 2
#set output "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/fig3.png"
set term pdf enhanced monochrome dashed size 9in,6in font "Helvetica,12" linewidth 2
set palette gray gamma 2
set palette maxcolors 8
set pm3d
set view map
unset colorbox
unset surface
set output "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/fig3.pdf"
set multiplot
set style data lines
set ytics
# Surface Observations
set format x ""
set ylabel "J_h (W/m^2)"
set x2tics mirror 328,.25,329.75
set lmargin at screen .1
set rmargin at screen .5
set tmargin at screen .9
set bmargin at screen .75
set xrange [328:330]
set x2range [328:330]
set x2label "2011 year day"
set yrange [-1000:1000]
set ytics nomirror -800,400,800
plot datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:2 axis x2y1 title "J_h"
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
set rmargin at screen .9
set tmargin at screen .9
set bmargin at screen .75
plot datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:4 axes x2y2 title "{/Symbol t}_x", datdir."fig3ab.dat" binary format="%f%f%f%f%f"u 1:5 axes x2y2 title "{/Symbol t}_y"
unset x2tics
unset y2tics
unset y2range
unset y2label
unset x2label
#
# Profile Observations
#
set xtics mirror 328,.25,329.75
set ytics mirror -70,20,-10
set yrange[-80:0]
# Temperature
set cbrange [26.5:30.5]
set cblabel "T (^oC)"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen .1
set rmargin at screen .5
set tmargin at screen .75
set bmargin at screen .6
splot datdir."fig3c.dat" binary matrix title "T_{obs}"
# Simulated
unset ylabel
set colorbox user origin .9,.61 size .01,.14
set format y ""
set format x ""
set lmargin at screen .5
set rmargin at screen .9
set tmargin at screen .75
set bmargin at screen .6
splot datdir."fig3d.dat" binary matrix title "T_{sim}"
unset colorbox
# Salinity
set cbrange [35.2:35.7]
set cblabel "S (psu)"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen .1
set rmargin at screen .5
set tmargin at screen .6
set bmargin at screen .45
splot datdir."fig3e.dat" binary matrix title "S_{obs}"
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen .5
set rmargin at screen .9
set tmargin at screen .6
set bmargin at screen .45
set colorbox user origin .9,.45 size .01,.14
splot datdir."fig3f.dat" binary matrix title "S_{sim}"
unset colorbox
# U Velocity
set cbrange [-.2:1.2]
set cblabel "u,v (m/s)"
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
set lmargin at screen .1
set rmargin at screen .5
set tmargin at screen .45
set bmargin at screen .3
splot datdir."fig3g.dat" binary matrix title "u_{obs}"
# Simulated
unset ylabel
set format y ""
set format x ""
set lmargin at screen .5
set rmargin at screen .9
set tmargin at screen .45
set bmargin at screen .3
splot datdir."fig3h.dat" binary matrix title "u_{sim}"
# V velocity
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x "%g"
set lmargin at screen .1
set rmargin at screen .5
set tmargin at screen .3
set bmargin at screen .15
splot datdir."fig3i.dat" binary matrix title "v_{obs}"
# Simulated
unset ylabel
set format y ""
set format x "%g"
set lmargin at screen .5
set rmargin at screen .9
set tmargin at screen .3
set bmargin at screen .15
set colorbox user origin .9,.15 size .01,.28
splot datdir."fig3j.dat" binary matrix title "v_{sim}"
unset colorbox
unset multiplot
set term wxt
