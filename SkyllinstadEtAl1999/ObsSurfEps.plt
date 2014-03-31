set output outdir.abrev.termsfx
#
# Setup spacing
rows = 3
cols = 1
col = 0
row = 0
#
#set object 1 rectangle from t0sim,graph 0 to tfsim,graph 1 fc rgb "gray90" fs pattern 3
#t0sim=t0sim-.25
#tfsim=tfsim+.25
load scriptdir."tlocbloc.plt"
#
set autoscale y
#
set multiplot title "Surface Forcing Observetions"
set style data lines
set ytics .2
set key left
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set format x ""
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol t} (Pa)"
plot datdir.abrev."JhPrecipTxTycpHs.dat" binary format="%f%f%f%f%f%f%f" u 1:4 lc -1 title "zonal",\
datdir.abrev."JhPrecipTxTycpHs.dat" binary format="%f%f%f%f%f%f%f" u 1:5 lc rgbcolor "grey50" title "meridional"
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ytics .3 nomirror offset ytoff,0
set ylabel "J_h (kW/m^2)"
set y2label "P (mm/h)" offset -yloff,0
set y2tics out 15
set y2tics nomirror offset -ytoff,0
plot \
datdir.abrev."JhPrecipTxTycpHs.dat" binary format="%f%f%f%f%f%f%f" u 1:($2*.001) title "J_h" ,\
datdir.abrev."JhPrecipTxTycpHs.dat" binary format="%f%f%f%f%f%f%f" u 1:3 axes x1y2 title "P"
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key b r
set ytics 1 nomirror offset ytoff,0
set ylabel "c_p (m/s)"
set y2label "H_s (m)" offset -yloff,0
set y2tics out .5
set y2tics nomirror offset -ytoff,0
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
plot \
datdir.abrev."JhPrecipTxTycpHs.dat" binary format="%f%f%f%f%f%f%f" u 1:6 title "c_p" ,\
datdir.abrev."JhPrecipTxTycpHs.dat" binary format="%f%f%f%f%f%f%f" u 1:7 axes x1y2 title "H_s"
unset y2tics
unset y2label
#
#
#load scriptdir."tlocbloc.plt"
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set format x "%g"
#set ylabel "Z (m)" offset yloff,0
#set xlabel "2011 UTC yearday" offset 0,xloff
#cbform = "%4.1te^{%+02T}"
#set format cb cbform
#set cblabel "{/Symbol e} (W/kg)" offset 1-yloff,0
#unset object 1
#load outdir."pospalnan.plt"
#epsmax = 5e-5
#epsmin = 5e-9
#set cbrange [epsmin:epsmax]
#set cbtics epsmin,(epsmax/epsmin)**(1.0/2),epsmax
#set cbtics offset -ytoff,0
#unset mcbtics
#set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
#unset surface
#set logscale cb
#plot datdir.abrev."d.dat" binary matrix w image not
unset multiplot
