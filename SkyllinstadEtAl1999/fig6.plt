reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig6".termsfx
palcolors = 8
set palette maxcolors palcolors
set view map
unset colorbox
unset surface
set pm3d
set multiplot
set lmargin .15
set rmargin .85
rows = 9
dvmargin = 1.0/(rows+1)
vmargin = 1.0-dvmargin/3
cblogmax = 1e-2
cblogmin = 1e-6
cbmax = .005
cbmin = -.005
set xtics t0sim,.25,tfsim
set mxtics 6
#
# Plot tke
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
set colorbox user origin .85,vmargin-dvmargin/4 size .02,1.25*dvmargin
set format x ""
set ylabel "Z(m)"
set yrange [-dsim:0]
set ytics -dsim*3.5/4,dsim/4.0,-.5*dsim/4
set format cb "10^{%L}m^2/s^2"
set cbtics offset -.5,0
set logscale cb
set cbrange [cblogmin:cblogmax]
splot datdir."fig6a.dat" binary matrix title "<tke>_{x,y}"
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
splot datdir."fig6b.dat" binary matrix title "<w'P'>_{x,y}/<tke>_{x,y}"
unset colorbox
#
# Plot Advective transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6c.dat" binary matrix title "<w'tke>_{x,y}/<tke>_{x,y}"
#
# Plot sub-gridscale transport
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6d.dat" binary matrix title "<w'_{sg}tke>_{x,y}/<tke>_{x,y}"
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6e.dat" binary matrix title "<b'w'>_{x,y}/<tke>_{x,y}"
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6f.dat" binary matrix title "<SP>_{x,y}/<tke>_{x,y}"
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6g.dat" binary matrix title "<St>_{x,y}/<tke>_{x,y}"
#
# Plot
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6h.dat" binary matrix title "<sgs B>_{x,y}/<tke>_{x,y}"
#
# Plot
set format x "%g"
set xtics offset 0,.5
set xlabel "2011 UTC yearday" offset 0,1
set tmargin at screen vmargin
vmargin = vmargin-dvmargin
set bmargin at screen vmargin
splot datdir."fig6i.dat" binary matrix title "<{/Symbol e}>_{x,y}/<tke>_{x,y}"
