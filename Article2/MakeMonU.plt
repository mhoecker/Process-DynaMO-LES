load pltdir."sympalnan.plt"
load pltdir.prefix."lontics.plt"
i2pad(i) = (i<10) ? "0".i : "".i
i2mon(i) = (i==1) ? "Jan" :\
 (i==2)  ? "Feb" :\
 (i==3)  ? "Mar" :\
 (i==4)  ? "Apr" :\
 (i==5)  ? "May" :\
 (i==6)  ? "Jun" :\
 (i==7)  ? "Jul" :\
 (i==8)  ? "Aug" :\
 (i==9)  ? "Sep" :\
 (i==10) ? "Oct" :\
 (i==11) ? "Nov" :\
 "Dec"
set label 10 "Indian"   front offset 0,-.5 at  80,graph 0
set label 11 "Pacific"  front offset 0,-.5 at 150,graph 0
set label 12 "Atlantic" front offset 0,-.5 at 310,graph 0
set xrange [75:195]
set yrange [-350:10]
set cbrange [-.6:.6]
set colorbox
set cblabel "Zonal Current (m/s)"
set ylabel "Depth (m)"
set xlabel "Longitude (deg)"
do for [i=1:12] {
 set output pngdir.prefix.i2pad(i).termsfx
 set title "Equatorial Current ".i2mon(i)
 plot \
  datdir.i2pad(i).'i.dat' binary matrix u 1:2:3 w image not,\
  datdir.i2pad(i).'.dat' binary matrix u 1:2 w points ps 2 pt 4 lc -1 not,\
  datdir.i2pad(i).'.dat' binary matrix u 1:2:3 w points ps 1 pt 5 lc pal not,\
  datdir.i2pad(i).'.dat' binary matrix u 1:(0) w points lc -1 pt 7 not
}
