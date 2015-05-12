load termfile
set output outdir.abrev."TSUVdsum".termsfx
set view map
unset colorbox
unset surface
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
load outdir."sympal.plt"
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
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
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
set cblabel "{/Symbol \362D}Tdz(m^oC)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
row = nextrow(row)
plot datdir.abrev."Tdsum.dat" binary matrix w image notitle
#
set format x ""
cbmin = DSmin
cbmax = DSmax
set cblabel "{/Symbol \362D}Sdz(m psu)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
row = nextrow(row)
plot datdir.abrev."Sdsum.dat" binary matrix w image notitle
#
set format x ""
cbmin = DUVmin
cbmax = DUVmax
unset colorbox
set cblabel "{/Symbol \362D}u(m^2/s)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
row = nextrow(row)
plot datdir.abrev."udsum.dat" binary matrix w image notitle
#
set format x "%g"
set xlabel "2011 UTC yearday"
set cblabel "{/Symbol \362D}v, {/Symbol D}u dz(m^2/s)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
row = nextrow(row)
plot datdir.abrev."vdsum.dat" binary matrix w image notitle
#
unset multiplot
