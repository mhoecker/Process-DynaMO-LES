reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
set table outdir."fig7a".".tab"
splot datdir."fig7a.dat" binary matrix
set table outdir."fig7b".".tab"
splot datdir."fig7b.dat" binary matrix
unset contour
unset table
#
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig7".termsfx
unset surface
set view map
set pm3d
set multiplot
set ytics
# set dates
set xtics t0sim,.25,tfsim
set mxtics 6
set xrange [t0sim:tfsim]
# heat flux
set cbrange [-.0003:0.00005]
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
plot datdir."fig7a.dat" binary matrix w image notitle, \
outdir."fig7a.tab" lc 0 notitle
#
set tmargin at screen .7
set bmargin at screen .5
set colorbox user origin  screen .875,.525 size .025,.375
set ylabel "<w'T'>_{x,y}"
plot datdir."fig7b.dat" binary matrix w image notitle, \
outdir."fig7a.tab" lc 0 notitle
#
set tmargin at screen .5
set bmargin at screen .3
set cbrange [2**(-18):2**(-8)]
set logscale cb 2
set format cb "2^{%L}"
set colorbox user origin  screen .875,.325 size .025,.175
set ylabel "<T^2>_{x,y}/{/Symbol D}T^2"
plot datdir."fig7c.dat" binary matrix w image notitle
unset logscale
#
set autoscale cb
set colorbox origin screen .875,.1 size .025,.2
set tmargin at screen .3
set bmargin at screen .1
set format x "%g"
set format cb "%3.1f"
set ylabel "<T>_{x,y}"
plot datdir."fig7d.dat" binary matrix w image notitle
