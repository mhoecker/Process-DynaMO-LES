load pltdir."sympal.plt"
i2pad(i) = (i<10) ? "0".i : "".i
set xrange [75:195]
set yrange [-350:10]
set cbrange [-.6:.6]
do for [i=1:12] {
 set output pngdir.prefix.i2pad(i).termsfx
 plot \
  datdir.i2pad(i).'.dat' binary matrix u 1:2:3 w points ps 5 pt 5 lc pal not,\
  datdir.i2pad(i).'.dat' binary matrix u 1:(0) w points lc -1 pt 7 not
}
