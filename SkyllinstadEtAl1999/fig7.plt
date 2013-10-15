reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig7".termsfx
unset surface
set view map
set pm3d
set multiplot
set ytics
set cbrange [-.00003:0.000005]
set format cb "%1.1e"
unset colorbox
set key at graph 1,1
set format x ""
set ytics -55,10,-5
set rmargin at screen .85
set lmargin at screen .15
set tmargin at screen .9
set bmargin at screen .7
set ylabel "<J_{sgs}>_{x,y}"
splot datdir."fig7a.dat" binary matrix notitle
#
set tmargin at screen .7
set bmargin at screen .5
set colorbox user origin  screen .875,.525 size .025,.375
set ylabel "<w'T'>_{x,y}"
splot datdir."fig7b.dat" binary matrix notitle
#
set tmargin at screen .5
set bmargin at screen .3
set cbrange [2**(-40):2**(-5)]
set logscale cb 2
set format cb "2^{%L}"
set colorbox user origin  screen .875,.325 size .025,.175
set ylabel "<T^2>_{x,y}"
splot datdir."fig7c.dat" binary matrix notitle
unset logscale
#
set autoscale cb
set colorbox origin screen .875,.1 size .025,.2
set tmargin at screen .3
set bmargin at screen .1
set format x "%g"
set format cb "%3.1f"
set ylabel "<T>_{x,y}"
splot datdir."fig7d.dat" binary matrix notitle
