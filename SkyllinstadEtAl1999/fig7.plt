reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
set table outdir."fig7a".".tab"
splot datdir."fig7a.dat" binary matrix
set table outdir."fig7b".".tab"
splot datdir."fig7b.dat" binary matrix
unset contour
unset table
#
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig7".termsfx
# Setup spacing
rows = 4
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
cbform = "%+4.1te^{%+02T}"
# heat flux
hfxmax = 1e-4
hfxmin = -hfxmax
#
cbpow = -12
#
Tmax = 30.0
Tmin = 28.6
#
set multiplot title "Heat Budget"
# Heat flux
set xtics t0sim,.25,tfsim
set mxtics 6
set xrange [t0sim:tfsim]
set cbrange [hfxmin:hfxmax]
set cbtics hfxmin,(hfxmax-hfxmin)/palcolors,hfxmax
set format cb cbform."W/m^3"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
unset colorbox
set format x ""
set ylabel "J_{sgs}"
plot datdir."fig7a.dat" binary matrix w image notitle, \
outdir."fig7a.tab" lc 0 notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(row)+.1*vskip size 0.1*(1.0-rloc),1.8*(vskip)
set ylabel "w'T'"
plot datdir."fig7b.dat" binary matrix w image notitle, \
outdir."fig7a.tab" lc 0 notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [2**(cbpow-palcolors):2**(cbpow)]
set logscale cb 2
set format cb "2^{%L}"
set cbtics 2**(cbpow-palcolors),2,2**(cbpow)
set colorbox user origin rloc,bloc(row)+.1*vskip size 0.1*(1.0-rloc),0.8*(vskip)
set ylabel "T^2/{/Symbol D}T^2"
plot datdir."fig7c.dat" binary matrix w image notitle
unset logscale
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [Tmin:Tmax]
set cbtics Tmin,(Tmax-Tmin)/palcolors,Tmax
set colorbox user origin rloc,bloc(row)+.1*vskip size 0.1*(1.0-rloc),0.8*(vskip)
set format x "%g"
set format cb "%2.2fC"
set ylabel "T"
plot datdir."fig7d.dat" binary matrix w image notitle
