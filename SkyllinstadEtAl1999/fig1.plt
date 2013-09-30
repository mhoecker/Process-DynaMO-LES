reset
datdir = '/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/'
load datdir."limits.plt"
#set term png enhanced size 1536,1024 truecolor nocrop linewidth 2
#set output "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/fig1.png"
set term pdf enhanced monochrome dashed size 9in,6in font "Helvetica,12" linewidth 2
set palette gray gamma 2
set palette maxcolors 8
set output "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/fig1.pdf"
set multiplot
set style data lines
set ytics
set xrange [t0sim-1:tfsim+1]
set x2range [t0sim-1:tfsim+1]
set object 1 rectangle from t0sim,graph 0 to t0sim+1,graph 1 fc rgb "gray90" fs pattern 3
set rmargin at screen .9
set lmargin at screen .1
set xtics .5
set format x ""
set tmargin at screen .975
set bmargin at screen .775
#set ylabel "Wind Stress (Pa)"
set ylabel "{/Symbol t} (Pa)"
set x2tics .5 offset 0,-.3
plot datdir."fig1abc.dat" binary format="%f%f%f%f" u 1:2 lc -1 not axis x2y1
unset x2tics
set tmargin at screen .775
set bmargin at screen .575
unset ytics
unset ylabel
#set y2label "Percipitation (mm/h)"
set y2label "P (mm/h)"
set y2tics mirror
plot datdir."fig1abc.dat" binary format="%f%f%f%f" u 1:3 lc -1 axes x1y2 not
set tmargin at screen .575
set bmargin at screen .375
unset y2tics
set ytics mirror rangelimited
unset y2label
#set ylabel "Surface Heat Flux J_h (W/m^2)"
set ylabel "J_h (W/m^2)"
plot datdir."fig1abc.dat" binary format="%f%f%f%f" u 1:4 lc -1 not
set tmargin at screen .375
set bmargin at screen .075
set format x "%g"
set mxtics 12
set xtics offset 0,.5
#set ylabel "Depth (m)"
set ylabel "Z (m)"
set xlabel "2011 Yearday UTC" offset 0,1
set format cb "10^{%L}"
#set cblabel "Dissipation (W/kg)" offset 1,0
set cblabel "{/Symbol e} (W/kg)" offset 1,0
set view map
set pm3d
unset object 1
set object 1 rectangle from 328,graph 0 to 329,graph 1
set cbrange [1e-10:1e-2]
set yrange [-dsim:-20]
set colorbox user
set colorbox origin .91,.075
set colorbox size .02,.3
unset surface
set logscale cb
set logscale z
splot datdir."fig1d.dat" binary matrix not
unset multiplot
#set term wxt
#replot