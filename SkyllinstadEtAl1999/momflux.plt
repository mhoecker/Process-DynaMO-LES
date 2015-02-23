set output pngdir.abrev.termsfx
# Setup vertical spacing
rows = 2
row = 0
cols = 1
col = 0
#
load scriptdir."tlocbloc.plt"
#
#
set multiplot title "Surface and Mixed Layer Momentum Flux"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set label 1 "a"
set xtics format ""
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set autoscale cb
set cbtics auto
load pltdir."negpal.plt"
set cbrange [0:7e-4]
unset cbtics
set cbtics ("0" 0, "-5" 5e-4)
set format cb ""
set cblabel "u'w'\n[(cm/s)^2]"
set ylabel "Z [m]"
set key b l
plot datdir.abrev."uw.dat" binary matrix u 1:2:(-$3) w image not,\
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls -1 title "Mixed Layer"
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set xtics format "%g"
set xlabel "2011 UTC yearday"
load pltdir."sympal.plt"
set label 1 "b"
set autoscale y
set ytics auto
set yrange [-7:0]
set ytics -5,5,5
set ylabel "u'w' [(cm/s)^2]"
set key b r
plot datdir.abrev."ustr.dat" binary format="%f%f" u 1:(-$2*10)w lines ls 1 title "Surface Flux",\
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:($3*1e4) ls 2 title "Mixed Layer Flux"#
#
