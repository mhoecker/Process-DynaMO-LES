reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
set output outdir."fig3dsum".termsfx
set view map
unset colorbox
unset surface
# Setup spacing
rows = 4
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
DTmin = -10
DTmax = +10
#
DSmin = -6
DSmax = +6
#
DUVmin = -9
DUVmax = +9
#
set multiplot title "_0{/Symbol \362}^z Observeation - Model dz "
set lmargin at screen lloc
set rmargin at screen rloc
set style data lines
set ylabel "Z (m)"
set format y "%g"
set yrange [-80:-05]
set ytics -70,20,-10
set format cb "%+4.2f"
set cbtics auto
set autoscale cb
#
set format x ""
cbmin = DTmin
cbmax = DTmax
set cblabel "{/Symbol \362 D}T dz (m^oC)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir."fig3Tdsum.dat" binary matrix w image notitle
#
set format x ""
cbmin = DSmin
cbmax = DSmax
set cblabel "{/Symbol \362 D}S dz (m psu)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),0.9*vskip
row = nextrow(row)
plot datdir."fig3Sdsum.dat" binary matrix w image notitle
#
set format x ""
cbmin = DUVmin
cbmax = DUVmax
unset colorbox
set cblabel "{/Symbol \362 D}u (m^2/s)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
row = nextrow(row)
plot datdir."fig3udsum.dat" binary matrix w image notitle
#
set format x "%g"
set xlabel "2011 UTC yearday"
set cblabel "{/Symbol \362 D}v dz, {/Symbol \362 D}u dz (m^2/s)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/palcolors,cbmax
set colorbox user origin rloc,bloc(row)+.05*vskip size .1*(1-rloc),1.9*vskip
row = nextrow(row)
plot datdir."fig3vdsum.dat" binary matrix w image notitle
#
unset multiplot
