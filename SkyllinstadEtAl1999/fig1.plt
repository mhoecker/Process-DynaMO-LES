reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig1".termsfx
#
# Setup spacing
rows = 4
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set autoscale y
set ytics auto
set xtics .5
#
set multiplot title "Surface Forcing and Dissipation Observetions"
set style data lines
set ytics
set xrange [t0sim-1:tfsim+1]
set x2range [t0sim-1:tfsim+1]
set object 1 rectangle from t0sim,graph 0 to t0sim+1,graph 1 fc rgb "gray90" fs pattern 3
set rmargin at screen rloc
set lmargin at screen lloc
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set ylabel "{/Symbol t} (Pa)"
plot datdir."fig1abc.dat" binary format="%f%f%f%f" u 1:2 lc -1 not axis x2y1
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
unset ytics
unset ylabel
#set y2label "Percipitation (mm/h)"
set y2label "P (mm/h)" offset -yloff,0
set y2tics mirror offset -ytoff,0
plot datdir."fig1abc.dat" binary format="%f%f%f%f" u 1:3 lc -1 axes x1y2 not
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
unset y2tics
set ytics mirror rangelimited offset ytoff,0
unset y2label
set ylabel "J_h (kW/m^2)" offset yloff,0
plot datdir."fig1abc.dat" binary format="%f%f%f%f" u 1:($4*.001) lc -1 not
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set mxtics 12
set ylabel "Z (m)" offset yloff,0
set xlabel "2011 Yearday UTC" offset 0,xloff
set format cb "10^{%L}"
set cblabel "{/Symbol e} (W/kg)" offset -yloff,0
unset object 1
set object 1 rectangle from 328,graph 0 to 329,graph 1
set cbrange [1e-10:1e-1]
set yrange [-dsim:-20]
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),1.9*vskip
unset surface
set logscale cb
plot datdir."fig1d.dat" binary matrix w image not
row = nextrow(row)
unset multiplot
