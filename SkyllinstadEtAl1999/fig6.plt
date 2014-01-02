reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set style data lines
set output outdir."fig6".termsfx
set multiplot title "Vertical Energy Budget (Horizontal Averages)"
# setup the spacing between plots
# All share the same left and right margins
rplot = .8
lplot = .1
set lmargin at screen lplot
set rmargin at screen rplot
# Vertical margins depend n the total number of plots
rows = 9
# dvmargin is the vertical size of a plot
dvmargin = 1.0/(rows+1)
# vmargin is the top of the next plot
vmargin = 1.0-dvmargin/3
# Note: the upper margin is 1/3 of a plot
# and the lower margin is 2/3 of a plot.
# This gives space for a comon x-axis label
#
tkemax = 5e-3
tkemin = 0
dtkemin = -2.5e-5
dtkemax = +2.5e-5
dxtic = .25
unset xtics
set ylabel rotate by 90 offset 0,0
nullcolor = "grey20"
cbform = "%4.2te^{%+03T}"
set yrange [-dsim/2:0]
set xrange[t0sim:tfsim]
set ytics -dsim*3.5/8,dsim/8.0,-.5*dsim/8
set cbtics offset 0,0
#
# Plot tke
set ylabel "tke"
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set colorbox user origin rplot+.01,vmargin-4*dvmargin/3.0 size .02,7*dvmargin/3.0
set format x ""
set format cb cbform."m^2s^{-2}"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/palcolors,tkemax
plot datdir."fig6a.dat" binary matrix w image
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
#plot datdir."fig6adt.dat" binary matrix u 1:2:3 w image, \
#outdir."fig6adt.tab" lc rgbcolor nullcolor  lt 4 notitle
#unset colorbox
#
# Plot Pressure transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
unset colorbox
set colorbox user origin rplot+.01,2*dvmargin/3.0 size .02,(rows-8/3.0)*dvmargin
set cbrange [dtkemin:dtkemax]
set format cb cbform."m^2s^{-3}"
set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
set ylabel "w'P'"
plot datdir."fig6b.dat" binary matrix u 1:2:3 w image, \
outdir."fig6b.tab" lc rgbcolor nullcolor  lt 4 notitle
unset colorbox
#
# Plot Advective transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
#set ylabel "w'tke/<tke"
set ylabel "w'tke"
plot datdir."fig6c.dat" binary matrix u 1:2:3 w image, \
outdir."fig6c.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot sub-gridscale transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
#set ylabel "w'_{sg}tke/<tke"
set ylabel "w'_{sg}tke"
plot datdir."fig6d.dat" binary matrix u 1:2:3 w image, \
outdir."fig6d.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
#set ylabel "b'w'/<tke"
set ylabel "b'w'"
plot datdir."fig6e.dat" binary matrix u 1:2:3 w image, \
outdir."fig6e.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "SP/<tke"
set ylabel "SP"
plot datdir."fig6f.dat" binary matrix u 1:2:3 w image, \
outdir."fig6f.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
#set ylabel "St/<tke"
set ylabel "St"
plot datdir."fig6g.dat" binary matrix u 1:2:3 w image, \
outdir."fig6g.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
#set ylabel "sgs B/<tke"
set ylabel "sgs B"
plot datdir."fig6h.dat" binary matrix u 1:2:3 w image, \
outdir."fig6h.tab" lc rgbcolor nullcolor  lt 4 notitle
#
# Plot
set format x "%g"
set xtics offset 0,.5
set xlabel "2011 UTC yearday" offset 0,1
set xtics t0sim,dxtic,tfsim
set mxtics 6
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
#set ylabel "{/Symbol e}/<tke"
set ylabel "{/Symbol e}"
set bmargin at screen vmargin
plot datdir."fig6j.dat" binary matrix u 1:2:3 w image, \
outdir."fig6j.tab" lc rgbcolor nullcolor  lt 4 notitle
unset multiplot
