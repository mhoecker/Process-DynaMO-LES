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

do for [day=328:329]{
 valnum   = 'vals'.day
 datfile  = basename.valnum
 pngfile = basename.valnum.'.png'
 freqnum(i,j)  = 'freq'.day.number(i,j)
 highnum(i,j)  = 'SSH'.day.number(i,j)
 freqfile(i,j) = basename.freqnum(i,j).'.dat'
 highfile(i,j) = basename.highnum(i,j).'.dat'

 set colorbox
 set cbrange [-2:1]
 set yrange [5e-2:2]
 set logscale y
 set xtics auto

 do for [j=0:imax(day)]{
  numberpng = basename.day.hour(j).'.png'
  set output numberpng
  set title "Periodogram hour ".hour(j)
  set xrange [0:1]
  plot \
  for [i=1:71] freqfile(i,j) binary format=freqform using ((i-.5)/71):1:(log($2*$1)/log(10)) lc pal  pt ptype ps psbig not\
# ,for [i=1:71] freqfile(i,j) binary format=freqform using ((i-.5)/71):1:(log($2*$1)/log(10)) lc rgbcolor midcolor pt ptype ps psbig not
 }
 unset logscale y
 set output pngfile
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
 for [i=0:imax(day)]  datfile.pad2(i).".dat" binary format=datform u 1:2:($6) lc rgbcolor midcolor pt ptype ps psbig not\
 ,for [i=0:imax(day)]  datfile.pad2(i).".dat" binary format=datform u 1:2:($6) lc pal pt ptype ps psmall not\

 unset colorbox

 set ylabel "{/Symbol l}"
 set format x "%g"
 set xlabel "2011 UTC yearday"
 set logscale y
 set ytics 10
 set yrange [10:300]
 plot \
 for [i=0:imax(day)]  datfile.pad2(i).".dat" binary format=datform u 1:4 lc rgbcolor midcolor  pt ptype ps psbig not \
 ,for [i=0:imax(day)]  datfile.pad2(i).".dat" binary format=datform u 1:4:($6) lc pal  pt ptype ps psmall not\

 set logscale xy
 set autoscale xy
 set xtics 10
 unset mxtics
 set xrange [1:1000]
 set yrange [.05:2]
 #set size ratio -1
 set xlabel "{/Symbol l}"
 set ylabel "A"
 plot \
 for [i=0:imax(day)]  datfile.pad2(i).".dat" binary format=datform u 4:2:($6) lc rgbcolor midcolor pt ptype ps psbig not\
 ,for [i=0:imax(day)]  datfile.pad2(i).".dat" binary format=datform u 4:2:($6) lc pal pt ptype ps psmall not

 unset multiplot
 unset logscale
 unset cblabel
 unset xlabel
 unset ylabel
 unset xtics
}
