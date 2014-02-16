set output outdir.abrev.termsfx
#
# Setup spacing
rows = 4
cols = 1
col = 0
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set autoscale y
set xtics .5
#
set multiplot title "Surface Forcing and Dissipation Observetions"
set style data lines
set ytics .2
set key left
set xrange [t0sim-.25:tfsim+.25]
set x2range [t0sim-.25:tfsim+.25]
set object 1 rectangle from t0sim,graph 0 to tfsim,graph 1 fc rgb "gray90" fs pattern 3
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set ylabel "{/Symbol t} (Pa)"
plot datdir.abrev."JhPrecipTxTy.dat" binary format="%f%f%f%f%f" u 1:4 lc -1 title "zonal" axis x2y1,\
datdir.abrev."JhPrecipTxTy.dat" binary format="%f%f%f%f%f" u 1:5 lc 0 title "meridional" axis x2y1
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
unset ytics
set ylabel ""
#set y2label "Percipitation (mm/h)"
set y2label "P (mm/h)" offset -yloff,0
set y2tics 15
set y2tics mirror offset -ytoff,0
plot datdir.abrev."JhPrecipTxTy.dat" binary format="%f%f%f%f%f" u 1:3 lc -1 axes x1y2 not
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
unset y2tics
set ytics .3 mirror rangelimited offset ytoff,0
unset y2label
set ylabel "J_h (kW/m^2)"
plot datdir.abrev."JhPrecipTxTy.dat" binary format="%f%f%f%f%f" u 1:($2*.001) lc -1 not
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set mxtics 12
set ylabel "Z (m)" offset yloff,0
set xlabel "2011 UTC yearday" offset 0,xloff
cbform = "%4.1te^{%+02T}"
set format cb cbform
set cblabel "{/Symbol e} (W/kg)" offset 1-yloff,0
unset object 1
load outdir."pospal.plt"
epsmax = 2.5e-5
epsmin = 5e-9
set cbrange [epsmin:epsmax]
set cbtics epsmin,(epsmax/epsmin)**(1.0/2),epsmax
set cbtics offset -ytoff,0
unset mcbtics
set yrange [-dsim:0]
set ytics mirror -70,20,-10 offset ytoff,0
set colorbox user origin rloc(col),bloc(row)+0.075*vskip size .1*(1-rloc(col)),1.85*vskip
unset surface
set logscale cb
plot datdir.abrev."d.dat" binary matrix w image not
row = nextrow(row)
unset multiplot
