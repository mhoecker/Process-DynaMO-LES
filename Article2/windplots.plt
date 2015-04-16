rows = 2
cols = 1
row = 0
load scriptdir."tlocbloc.plt"
load termfile
ymax = 15
load pltdir."sympalnan.plt"
set xtics 1 nomirror
set ytics nomirror
avgdatfile = datdir."windplotsLP.dat"
avgdatform = "%f%f%f%f%f"
do for [i=1:5000] {
 datfile = datdir.sprintf("windplots%04i.dat",i)
 datform = "%f%f%f"
#
# set output "/dev/null"
 set autoscale
 stats datfile binary format=datform using 1 nooutput
 set xrange [STATS_min:STATS_max]
 set yrange [-ymax:ymax]
 set output pngdir.sprintf("windplot%04i.png",i)
 set multiplot
#
 set tmargin at screen tloc(row)
 set bmargin at screen bloc(row)
 set ylabel "Wind Anomaly [m/s]"
 set format x ""
 set title "Zonal" offset 0,-1
 plot \
 datfile binary format=datform u 1:2 w lines ls 11 title "High Pass",\
 avgdatfile binary format=avgdatform u 1:(-$2) w lines ls 12 title "-Low Pass"
 row = nextrow(row)
#
 set tmargin at screen tloc(row)
 set bmargin at screen bloc(row)
 set ylabel "Wind Anomaly [m/s]"
 set format x "%g"
 set title "Meridional" offset 0,-1
 plot datfile binary format=datform u 1:3 w lines ls 11 title"High Pass",\
 avgdatfile binary format=avgdatform u 1:(-$4) w lines ls 12 title "-Low Pass"
 row = nextrow(row)
 unset multiplot
}
