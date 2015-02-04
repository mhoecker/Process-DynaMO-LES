load termfile
load outdir."circle.plt"
set isosamples 128,128
set pm3d
unset surface
set size ratio -1
do for [i=1:1464]{
 padi = sprintf("%09i",i)
 set output outdir."angle".padi.".png"
 set multiplot
 set xtics format "%g"
 set mxtics 3
 set mx2tics 3
 set xtics 60 out
 set ytics 20 out nomirror
 set border 15
 set xrange [0:360]
 set yrange [-90:90]
 load outdir."pospal.plt"
 set colorbox
 set colorbox user
 set colorbox origin .87,.1
 set colorbox size .025,.4
 set cbtics 10
 set cbrange [0:35]
 set bmargin at screen .1
 set tmargin at screen .5
 set lmargin at screen .1
 set rmargin at screen .85
 plot "/home/mhoecker/work/Dynamo/plots/ncep/speed".padi.".dat" binary matrix w image not
 load outdir."circle.plt"
 unset colorbox
 unset xtics
 set xtics format ""
 set x2tics 60 out
 set x2tics format ""
 set cbrange [-pi:pi]
 set bmargin at screen .5
 set tmargin at screen .9
 set lmargin at screen .1
 set rmargin at screen .85
 plot "/home/mhoecker/work/Dynamo/plots/ncep/angle".padi.".dat" binary matrix w image not
 set parametric
 set urange [.5:1]
 set vrange [-pi:pi]
 set xrange [-1:1]
 set yrange [-1:1]
 set border 0
 unset tics
 set view map
 set bmargin at screen .5
 set tmargin at screen 1
 set lmargin at screen .85
 set rmargin at screen .99
 splot u*cos(v),u*sin(v),v not
 unset multiplot
}
