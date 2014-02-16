reset
load "/home/mhoecker/tmp/limits.plt"
set style data lines
abrev = "tkeBudg"
set output outdir.abrev."logabs".termsfx
# Setup spacing
rows = 9
row = 0
cols = 1
col = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Vertical Energy Budget (Horizontal Averages)"
set lmargin at screen lloc
set rmargin at screen rloc
load outdir."pospal.plt"
tkemax = 5e-3
tkemin = 1e-6
dtkemin = 5e-9
dtkemax = 2.5e-5
dxtic = .25
nullcolor = "grey20"
cbform = "%4.1te^{%+02T}"
set logscale cb
unset mcbtics
#
# Plot tke
set ylabel "tke"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row+2)+0.075*vskip size 0.1*(1.0-rloc),2.85*vskip
set format x ""
set format cb cbform
set cblabel "J/kg"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax/tkemin)**(1.0/palcolors),tkemax
plot datdir.abrev."a.dat" binary matrix w image
unset colorbox
#
# Plot total d/dt of tke
#set tmargin at screen vmargin
#vmargin = vmargin-dvmargin
#set bmargin at screen vmargin
#set colorbox user origin rplot+.01,2*dvmargin/3.0 size .02,(rows)*dvmargin
#set cbrange [dtkemin:dtkemax]
#set format cb cbform."m^2s^{-3}"
#set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
#set ylabel "^{d}/_{dt}(tke)"
#plot datdir.abrev."adt.dat" binary matrix u 1:2:(abs($3)) w image not, \
#outdir.abrev."adt.tab" lc rgbcolor nullcolor  lt 4 notitle
#unset colorbox
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(rows-1)+0.075*vskip size 0.1*(1.0-rloc),5.85*vskip
set cbrange [dtkemin:dtkemax]
set format cb cbform
set cblabel "W/kg"
set cbtics dtkemin,(dtkemax/dtkemin)**(1.0/palcolors),dtkemax
set ylabel "w'P'"
plot \
datdir.abrev."b.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."b.tab" lc rgbcolor nullcolor  lt 4 notitle
unset colorbox
#
# Plot Advective transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'tke"
plot datdir.abrev."c.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."c.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'_{sg}tke"
plot datdir.abrev."d.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."d.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
plot datdir.abrev."e.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."e.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "SP"
plot datdir.abrev."f.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."f.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "St"
plot datdir.abrev."g.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."g.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "sgs B"
plot datdir.abrev."h.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."h.tab" lc rgbcolor nullcolor  lt 4 notitle
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
plot datdir.abrev."j.dat" binary matrix u 1:2:(abs($3)) w image not, \
outdir.abrev."j.tab" lc rgbcolor nullcolor  lt 4 notitle
unset multiplot
