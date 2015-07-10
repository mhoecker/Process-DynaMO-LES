set output pngdir.abrev.termsfx
# Setup vertical spacing
rows = 4
row = 0
cols = 1
col = 0
#
load scriptdir."tlocbloc.plt"
#
#
set multiplot title "Momentum Fluxes"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set label 1 "a"
set xtics format ""
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set autoscale cb
set cbtics auto
load pltdir."negpal.plt"
load pltdir.abrev."timedepth.plt"
set cbrange [0:7e-4]
unset cbtics
set cbtics ("0" 0, "-5" 5e-4)
set format cb ""
set cblabel "u'w'\n[(cm/s)^2]"
set ylabel "z [m]"
set key horizontal b l
plot datdir.abrev."uw.dat" binary matrix u 1:2:(-$3) w image not, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls 11 title "0.01kg/m^3", \
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not,\
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 ls 12 title "0.10kg/m^3"
unset colorbox
set size ratio 0
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
load pltdir."pospal.plt"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set cbrange [0:1.2]
set cbtics 0.6
set format cb "%g"
set cblabel "u (m/s)"
set xtics format ""
set label 1 "b"
set key b r
plot \
datdir.abrev."u_ave.dat" binary matrix u 1:2:3 w image not,\
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls 11 not, \
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not,\
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 ls 12 not
unset colorbox
#
#
row = nextrow(row)
row = nextrow(row)
set tmargin at screen tloc(row-1)
set bmargin at screen bloc(row)
load pltdir."sympalnan.plt"
set xtics format "%g"
set xlabel "2011 UTC yearday"
load pltdir."sympal.plt"
set label 1 "c"
set autoscale y
set ytics auto
set yrange [-5.5:0]
set ytics -5,5,5
set ylabel "u'w' [(cm/s)^2]"
set key b r
plot \
datdir.abrev."ustr.dat" binary format="%f%f" u 1:(-$2*10) w lines lw 2 lc rgbcolor "white"not, \
datdir.abrev."ustr.dat" binary format="%f%f" u 1:(-$2*10) w lines ls 13 title "Surface", \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:($3*1e4) lw 2 lc rgbcolor "white"not, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:($3*1e4) ls 11 not, \
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:($3*1e4)  lw 2 lc rgbcolor "white"not, \
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:($3*1e4) ls 12 not

#
#
