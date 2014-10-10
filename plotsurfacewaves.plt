set style data points
basename = '/home/mhoecker/work/Dynamo/plots/surfacewaves/wavespectra'

imax(day) = (day>328) ? 23 : 23

datform = '%f%f%f%f%f%f'
freqform = '%f%f'
highform = '%f%f%f%f'
set term png enhanced notruecolor size 1536,1024 font "UnDinaru,24" nocrop linewidth 2

set palette mode RGB
set palette function 1-.5*gray,(1-gray),.5-.5*gray
set palette maxcolors 12

set output basename."test.png"
test
set lmargin at screen .15
set rmargin at screen .85
pad2(i) = (i<10) ? "0".i :  "".i
midcolor = "gray40"
psmall = 1
psbig = 2
ptype = 5


hour(j) = "".pad2(j)
number(i,j) = hour(j).pad2(i)
freqnum(i,j,day)  = 'freq'.day.number(i,j)
highnum(i,j,day)  = 'SSH'.day.number(i,j)
valnum(day)   = 'vals'.day
datfile(day)  = basename.valnum(day)
pngfile(day) = basename.valnum(day).'.png'
freqfile(i,j,day) = basename.freqnum(i,j,day).'.dat'
highfile(i,j,day) = basename.highnum(i,j,day).'.dat'
numberpng(j,day) = basename.day.hour(j).'.png'
#
do for [day=328:329]{
#
 set colorbox
 set autoscale cb
 unset logscale cb
 set format cb "10^{%+02.0f}"
 set cbtics 1
 set cbrange [-3:2]
 set yrange [1.9e-2:5]
 set ylabel "f (Hz)"
 set logscale y
 set xlabel "minutes"
 set xtics ("0 min" 0, "15 min" .25, "30 min" .5, "45 min" .75, "60 min" 1)
 set mxtics 3
 set xrange [0:1]
#
 do for [j=0:imax(day)]{
  print freqfile(0,j,day)
  set output numberpng(j,day)
  set title "Periodogram ".day."-".hour(j)
  plot \
  for [i=1:71] freqfile(i,j,day) binary format=freqform using ((i-.5)/71):1:(log($2)/log(10)) lc pal pt ptype ps psbig not\
# ,for [i=1:71] freqfile(i,j) binary format=freqform using ((i-.5)/71):1:(log($2*$1)/log(10)) lc rgbcolor midcolor pt ptype ps psbig not
 }
 unset logscale y
 set output pngfile(day)
 unset title
 set autoscale y
 set multiplot layout 3,1
 set xtics .25
 set ytics .5
 unset mytics
 set xtics out nomirror
 set mxtics 6
 set yrange [0:1.7]
 set xrange [day:day+1]
 set format x ""
 set colorbox user origin .875,.05 size .025,.9
 set cblabel "U_s"
 set logscale cb
 set cbrange [0.01:1]
 set ylabel "A"
 plot \
 for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 1:2:($6) lc rgbcolor midcolor pt ptype ps psbig not\
 ,for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 1:2:($6) lc pal pt ptype ps psmall not
#
 unset colorbox
#
 set ylabel "{/Symbol l}"
 set format x "%g"
 set xlabel "2011 UTC yearday"
 set logscale y
 set ytics 10
 set yrange [10:300]
 plot \
 for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 1:4 lc rgbcolor midcolor  pt ptype ps psbig not \
 ,for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 1:4:($6) lc pal  pt ptype ps psmall not\

 set logscale xy
 set autoscale xy
 set xtics 10
 unset mxtics
 set xrange [1:1000]
 set yrange [.05:2]
# set size ratio -1
 set xlabel "{/Symbol l}"
 set ylabel "A"
 plot \
 for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 4:2:($6) lc rgbcolor midcolor pt ptype ps psbig not\
 ,for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 4:2:($6) lc pal pt ptype ps psmall not
 unset multiplot
 unset logscale
 unset cblabel
 unset xlabel
 unset ylabel
 unset xtics
 unset logscale cb
}
