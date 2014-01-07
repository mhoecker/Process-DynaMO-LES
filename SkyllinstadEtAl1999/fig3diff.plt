reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig3diff".termsfx
set view map
unset colorbox
unset surface
# Setup spacing
rows = 4
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
load outdir."sympal.plt"
#
DTmin = -0.35
DTmax = +0.35
#
DSmin = -0.24
DSmax = +0.24
#
DUVmin = -0.75
DUVmax = +0.75
#
set multiplot title "Observeation - Model"
set lmargin at screen lloc
set rmargin at screen rloc
set style data lines
set ylabel "Z (m)"
set format y "%g"
set yrange [-80:-05]
set ytics -70,20,-10
set format cb "%+4.2f"
#
set format x ""
cbmin = DTmin
cbmax = DTmax
set cblabel "{/Symbol D}T (^oC)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir."fig3Tdiff.dat" binary matrix w image notitle
#
set format x ""
cbmin = DSmin
cbmax = DSmax
set cblabel "{/Symbol D}S (psu)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir."fig3Sdiff.dat" binary matrix w image notitle
#
set format x ""
cbmin = DUVmin
cbmax = DUVmax
unset colorbox
set cblabel "{/Symbol D}u (m/s)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
row = nextrow(row)
plot datdir."fig3udiff.dat" binary matrix w image notitle
#
set format x "%g"
set xlabel "2011 UTC yearday"
set cblabel "{/Symbol D}v, {/Symbol D}u (m/s)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),1.9*vskip
row = nextrow(row)
plot datdir."fig3vdiff.dat" binary matrix w image notitle
#
unset multiplot
