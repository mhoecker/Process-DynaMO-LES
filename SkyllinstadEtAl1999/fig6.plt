reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
#set table outdir."fig6a".".tab"
#splot datdir."fig6a.dat" binary matrix
set table outdir."fig6b".".tab"
splot datdir."fig6b.dat" binary matrix
set table outdir."fig6c".".tab"
splot datdir."fig6c.dat" binary matrix
set table outdir."fig6d".".tab"
splot datdir."fig6d.dat" binary matrix
set table outdir."fig6e".".tab"
splot datdir."fig6e.dat" binary matrix
set table outdir."fig6f".".tab"
splot datdir."fig6f.dat" binary matrix
set table outdir."fig6g".".tab"
splot datdir."fig6g.dat" binary matrix
set table outdir."fig6h".".tab"
splot datdir."fig6h.dat" binary matrix
set table outdir."fig6i".".tab"
splot datdir."fig6i.dat" binary matrix
set table outdir."fig6j".".tab"
splot datdir."fig6j.dat" binary matrix
unset contour
unset table
#
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig6".termsfx
palcolors = 8
set palette maxcolors palcolors
unset colorbox
set pm3d
set multiplot
set lmargin at screen .25
set rmargin at screen .85
rows = 9
dvmargin = 1.0/(rows+1)
vmargin = 1.0-dvmargin/3
cblogmax = 1e-2
cblogmin = 1e-6
cbmax = .01
cbmin = -.01
set xtics t0sim,.25,tfsim
set mxtics 6
set ylabel rotate by 30 offset -4,0
#
# Plot tke
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set colorbox user origin .85,vmargin-dvmargin/4 size .02,1.25*dvmargin
set format x ""
set yrange [-dsim/2:0]
set ytics -dsim*3.5/8,dsim/8.0,-.5*dsim/8
set format cb "10^{%L}m^2/s^2"
set cbtics offset -.5,0
set logscale cb
set cbrange [cblogmin:cblogmax]
set ylabel "<tke>_{x,y}"
plot datdir."fig6a.dat" binary matrix w image
unset logscale cb
#
# Plot Pressure transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set format cb "%3.1lx10^{%L}s^{-1}"
set colorbox user origin .85,dvmargin size .02,(rows-2)*dvmargin
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set ylabel "<w'P'>_{x,y}/<tke>_{x,y}"
plot datdir."fig6b.dat" binary matrix  w image
# , \
#outdir."fig6b.tab" lc 0 notitle
unset colorbox
#
# Plot Advective transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "<w'tke>_{x,y}/<tke>_{x,y}"
plot datdir."fig6c.dat" binary matrix w image
#, \
#outdir."fig6c.tab" lc 0 notitle
#
# Plot sub-gridscale transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "<w'_{sg}tke>_{x,y}/<tke>_{x,y}"
plot datdir."fig6d.dat" binary matrix w image
#, \
#outdir."fig6d.tab" lc 0 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "<b'w'>_{x,y}/<tke>_{x,y}"
plot datdir."fig6e.dat" binary matrix w image
#, \
#outdir."fig6e.tab" lc 0 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "<SP>_{x,y}/<tke>_{x,y}"
plot datdir."fig6f.dat" binary matrix w image
#, \
#outdir."fig6f.tab" lc 0 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "<St>_{x,y}/<tke>_{x,y}"
plot datdir."fig6g.dat" binary matrix w image
# , \
#outdir."fig6g.tab" lc 0 notitle
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set ylabel "<sgs B>_{x,y}/<tke>_{x,y}"
plot datdir."fig6h.dat" binary matrix w image
#, \
#outdir."fig6h.tab" lc 0 notitle
#
# Plot
set format x "%g"
set xtics offset 0,.5
set xlabel "2011 UTC yearday" offset 0,1
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set ylabel "<{/Symbol e}>_{x,y}/<tke>_{x,y}"
set bmargin at screen vmargin
plot datdir."fig6j.dat" binary matrix w image
#, \
#outdir."fig6i.tab" lc 0 notitle
