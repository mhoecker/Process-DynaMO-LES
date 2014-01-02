reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig3diff".termsfx
palcolors = 8
Ntotplots = 4
Nplot = 0
cbmarks = palcolors/2
set palette maxcolors palcolors
set view map
unset colorbox
unset surface
set pm3d
set multiplot title "Observeation - Model"
set lmargin at screen .15
set rmargin at screen .85
set style data lines
# Common Ranges
set xrange[t0sim:tfsim]
set yrange [-dsim/2:0]
#
# Common label offsets
set ylabel offset 1.25,0
set xlabel offset 0,1
#
# Common tic offsets
set xtic offset 0,.5
set ytic offset .9,0
set cbtics offset -.5,0
#
# common tics
set ytics -dsim*3.5/8,dsim/8.0,-.5*dsim/8
dxtic = .25
set xtics t0sim,dxtic,tfsim
#
set ylabel "Z (m)"
set format y "%g"
#
set format x ""
set cblabel "{/Symbol D}T (^oC)"
set tmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
Nplot = Nplot+1
set bmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
set colorbox user origin .85,1.0-(Nplot+0.5)/(Ntotplots+1.0) size .01,0.8/(Ntotplots+1.0)
plot datdir."fig3Tdiff.dat" binary matrix w image notitle
#
set format x ""
set cblabel "{/Symbol D}S (psu)"
set tmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
Nplot = Nplot+1
set bmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
set colorbox user origin .85,1.0-(Nplot+0.5)/(Ntotplots+1.0) size .01,0.8/(Ntotplots+1.0)
plot datdir."fig3Sdiff.dat" binary matrix w image notitle
#
set format x ""
set cblabel "{/Symbol D}u (m/s)"
set tmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
Nplot = Nplot+1
set bmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
set colorbox user origin .85,1.0-(Nplot+0.5)/(Ntotplots+1.0) size .01,0.8/(Ntotplots+1.0)
plot datdir."fig3udiff.dat" binary matrix w image notitle
#
set format x "%g"
set xlabel "2011 UTC yearday"
set cblabel "{/Symbol D}v (m/s)"
set tmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
Nplot = Nplot+1
set bmargin at screen 1.0-(Nplot+0.5)/(Ntotplots+1.0)
set colorbox user origin .85,1.0-(Nplot+0.5)/(Ntotplots+1.0) size .01,0.8/(Ntotplots+1.0)
plot datdir."fig3vdiff.dat" binary matrix w image notitle
#
unset multiplot
