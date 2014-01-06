reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set style data lines
set output outdir."fig6linR".termsfx
# Setup spacing
rows = 9
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Vertical Energy Budget (Scaled Horizontal Averages)"
# setup the spacing between plots
# All share the same left and right margins
set lmargin at screen lloc
set rmargin at screen rloc
cbform = "%+4.1te^{%+02T}"
tkemax = 5e-3
tkemin = 0
dtkemin = -1e-2
dtkemax = +1e-2
dxtic = .25
unset xtics
nullcolor = "grey20"
#
# Plot tke
set ylabel "tke"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row+2)+.1*vskip size 0.1*(1.0-rloc),2.8*(vskip)
set format x ""
set format cb cbform."m^2s^{-2}"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/palcolors,tkemax
plot datdir."fig6a.dat" binary matrix w image
unset colorbox
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [dtkemin:dtkemax]
set format cb cbform."s^{-1}"
set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
set colorbox user origin rloc,bloc(rows-1)+.1*vskip size 0.1*(1.0-rloc),5.8*(vskip)
set ylabel "w'P'"
plot datdir."fig6bR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6bR.tab" lc rgbcolor nullcolor  lt 4 notitle
unset colorbox
#
# Plot Advective transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'tke"
plot datdir."fig6cR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6cR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'_{sg}tke"
plot datdir."fig6dR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6dR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
plot datdir."fig6eR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6eR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "SP"
plot datdir."fig6fR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6fR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "St"
plot datdir."fig6gR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6gR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "sgs B"
plot datdir."fig6hR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6hR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xtics offset 0,.5
set xlabel "2011 UTC yearday" offset 0,1
set xtics t0sim,dxtic,tfsim
set mxtics 6
set ylabel "{/Symbol e}"
plot datdir."fig6jR.dat" binary matrix u 1:2:3 w image, \
outdir."fig6jR.tab" lc rgbcolor nullcolor  lt 4 notitle
unset multiplot
