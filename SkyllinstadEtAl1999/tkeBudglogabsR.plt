reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set style data lines
abrev = "tkeBudg"
set output outdir.abrev."logabsR".termsfx
# Setup spacing
rows = 9
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Vertical Energy Budget (Scaled Horizontal Averages)"
# All share the same left and right margins
set lmargin at screen lloc
set rmargin at screen rloc
#
load outdir."pospal.plt"
tkemax = 5e-3
tkemin = 1e-6
dtkemin = 2e-6
dtkemax = 1e-2
dxtic = .25
nullcolor = "grey20"
cbform = "%4.1te^{%+02T}"
set logscale cb
unset mcbtics
#
# Plot tke
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row+2)+.1*vskip size 0.1*(1.0-rloc),2.8*(vskip)
set format x ""
set format cb cbform
set cblabel "J/kg"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax/tkemin)**(1.0/palcolors),tkemax
set ylabel "tke"
plot datdir.abrev."a.dat" binary matrix w image
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(rows-1)+.1*vskip size 0.1*(1.0-rloc),5.8*(vskip)
set cbrange [dtkemin:dtkemax]
set format cb cbform
set cblabel "s^{-1}"
set cbtics dtkemin,(dtkemax/dtkemin)**(1.0/palcolors),dtkemax
set ylabel "w'P'"
plot datdir.abrev."bR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."bR.tab" lc rgbcolor nullcolor  lt 4 notitle
unset colorbox
#
# Plot Advective transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'tke"
plot datdir.abrev."cR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."cR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'_{sg}tke"
plot datdir.abrev."dR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."dR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot bouyancy transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
plot datdir.abrev."eR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."eR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot Shear Production
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "SP"
plot datdir.abrev."fR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."fR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot Stokes production
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "St"
plot datdir.abrev."gR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."gR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "sgs B"
plot datdir.abrev."hR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."hR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday"
set xtics t0sim,dxtic,tfsim
set mxtics 6
set ylabel "{/Symbol e}"
plot datdir.abrev."jR.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."jR.tab" lc rgbcolor nullcolor  lt 4 notitle
