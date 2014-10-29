load termfile
set output outdir.abrev.termsfx
set style data lines
# Setup vertical spacing
rows = 3
row = 0
cols = 1
col = 0
#
load scriptdir."tlocbloc.plt"
load outdir."sympal.plt"
#
unset key
set xtics format ""
set cbrange [-0.00005:0.00005]
set cbtics 0.00005
set yrange [-40:0]
#
set multiplot title "Momentum Sources"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row+2) size cbwid,2*vskip+cbhig
set ylabel "{/Symbol \266}_tu"
plot datdir.abrev."dudt.dat" binary matrix w image
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "-{/Symbol \266}_zu'w'"
plot datdir.abrev."duwdz.dat" binary matrix w image
#
set xtics format "%g"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol \266}_z{/Symbol n}_t{/Symbol \266}_zu"
plot datdir.abrev."ddzkmddzu.dat" binary matrix w image
