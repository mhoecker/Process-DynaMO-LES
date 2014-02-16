reset
load "/home/mhoecker/tmp/limits.plt"
set style data lines
abrev = "tkeBudg"
set output outdir.abrev."linR".termsfx
# Setup spacing
rows = 9
row = 0
cols = 1
col = 0
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
set colorbox user origin rloc,bloc(row+2)+0.075*vskip size 0.1*(1.0-rloc),2.85*vskip
set format x ""
set format cb cbform
set cblabel "J/kg"
load outdir."pospal.plt"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/palcolors,tkemax
plot datdir.abrev."a.dat" binary matrix w image
unset colorbox
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
load outdir."sympal.plt"
set cbrange [dtkemin:dtkemax]
set format cb cbform
set cblabel "s^{-1}"
set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
set colorbox user origin rloc,bloc(rows-1)+0.075*vskip size 0.1*(1.0-rloc),5.85*vskip
set ylabel "w'P'"
plot datdir.abrev."bR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."bR.tab" lc rgbcolor nullcolor  lt 4 notitle
unset colorbox
#
# Plot Advective transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'tke"
plot datdir.abrev."cR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."cR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'_{sg}tke"
plot datdir.abrev."dR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."dR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
plot datdir.abrev."eR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."eR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "SP"
plot datdir.abrev."fR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."fR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "St"
plot datdir.abrev."gR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."gR.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "sgs B"
plot datdir.abrev."hR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."hR.tab" lc rgbcolor nullcolor  lt 4 notitle
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
plot datdir.abrev."jR.dat" binary matrix u 1:2:3 w image, \
outdir.abrev."jR.tab" lc rgbcolor nullcolor  lt 4 notitle
unset multiplot
