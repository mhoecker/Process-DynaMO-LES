reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set style data lines
set output outdir."fig6".termsfx
# Setup spacing
rows = 9
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Vertical Energy Budget (Horizontal Averages)"
# all share the same left/right margins
set lmargin at screen lloc
set rmargin at screen rloc
tkemax = 5e-3
tkemin = 0
dtkemin = -2.5e-5
dtkemax = +2.5e-5
dxtic = .25
unset xtics
set ylabel rotate by 90 offset 0,0
nullcolor = "grey20"
cbform = "%+4.1te^{%+02T}"
set yrange [-dsim/2:0]
set xrange[t0sim:tfsim]
set ytics -dsim*3.5/8,dsim/8.0,-.5*dsim/8
set cbtics offset 0,0
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
row = nextrow(row)
#
# Plot total d/dt of tke
#set tmargin at screen vmargin
#vmargin = vmargin-vskip
#set bmargin at screen vmargin
#set colorbox user origin rloc+.01,2*vskip/3.0 size .02,(rows)*vskip
#set cbrange [dtkemin:dtkemax]
#set format cb cbform."m^2s^{-3}"
#set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
#set ylabel "^{d}/_{dt}(tke)"
#plot datdir."fig6adt.dat" binary matrix u 1:2:3 w image, \
#outdir."fig6adt.tab" lc rgbcolor nullcolor  lt 4 notitle
#unset colorbox
#
# Plot Pressure transport
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
unset colorbox
set cbrange [dtkemin:dtkemax]
set format cb cbform."m^2s^{-3}"
set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
set ylabel "w'P'"
plot datdir."fig6b.dat" binary matrix u 1:2:3 w image, \
outdir."fig6b.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot Advective transport
unset colorbox
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'tke"
plot datdir."fig6c.dat" binary matrix u 1:2:3 w image, \
outdir."fig6c.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot sub-gridscale transport
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'_{sg}tke"
plot datdir."fig6d.dat" binary matrix u 1:2:3 w image, \
outdir."fig6d.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
plot datdir."fig6e.dat" binary matrix u 1:2:3 w image, \
outdir."fig6e.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
	set ylabel "SP"
plot datdir."fig6f.dat" binary matrix u 1:2:3 w image, \
outdir."fig6f.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "St"
plot datdir."fig6g.dat" binary matrix u 1:2:3 w image, \
outdir."fig6g.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
#set ylabel "sgs B/<tke"
set ylabel "sgs B"
plot datdir."fig6h.dat" binary matrix u 1:2:3 w image, \
outdir."fig6h.tab" lc rgbcolor nullcolor  lt 4 notitle
row = nextrow(row)
#
# Plot
set format x "%g"
set xtics offset 0,.5
set xlabel "2011 UTC yearday" offset 0,1
set xtics t0sim,dxtic,tfsim
set mxtics 6
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.1*vskip size 0.1*(1.0-rloc),5.8*(vskip)
#set ylabel "{/Symbol e}/<tke"
set ylabel "{/Symbol e}"
plot datdir."fig6j.dat" binary matrix u 1:2:3 w image, \
outdir."fig6j.tab" lc rgbcolor nullcolor  lt 4 notitle
unset multiplot
