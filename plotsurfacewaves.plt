set style data points
basename = '/home/mhoecker/work/Dynamo/plots/surfacewaves/wavespectra'

imax(day) = (day>328) ? 23 : 23

datform = '%f%f%f%f%f%f'
freqform = '%f%f%f'
highform = '%f%f%f%f'
set term png enhanced notruecolor size 1536,1024 font "UnDinaru,24" nocrop linewidth 2

set palette mode RGB
set palette function 1-.5*gray,(1-gray),.5-.5*gray
set palette maxcolors 7

set output basename."test.png"
test
set lmargin at screen .15
set rmargin at screen .85
pad2(i) = (i<10) ? "0".i :  "".i
midcolor = "gray40"
psmall = 1
psbig = 2
ptype = 5
liwid = 6
Jmax = 40

hour(j) = "".pad2(j)
number(i,j) = hour(j).pad2(i)
daynumber(i,j,day) = (j<0) ? "".(day-1).number(i,(24+j)) : ( (j>23) ? "".(day+1).number(i,j-24): "".day.number(i,j) )
freqnum(i,j,day)  = 'freq'.daynumber(i,j,day)
highnum(i,j,day)  = 'SSH'.daynumber(i,j,day)
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
 set ylabel "f (Hz)"
 set logscale y
 set ytics 2
 set logscale cb
 set cbrange [.05:500]
 set yrange [.03125:.5]
 set xlabel "2011 Yearday"
 set view map
 set xtics .05
 set format x "%g"
#
 do for [i=0:imax(day)]{
  set xrange [day+(i-2)/24.:day+(3+i)/24.]
  set output numberpng(i,day)
  set title "Periodogram ".day."-".hour(i)
  print freqfile(1,i,day)
  plot \
  for [j=1:Jmax] freqfile(j,i-2,day) binary format=freqform u 1:2:3 w lines lc pal lw liwid not,\
  for [j=1:Jmax] freqfile(j,i-1,day) binary format=freqform u 1:2:3 w lines lc pal lw liwid not,\
  for [j=1:Jmax] freqfile(j,i,day) binary format=freqform u 1:2:3 w lines lc pal lw liwid not,\
  for [j=1:Jmax] freqfile(j,i+1,day) binary format=freqform u 1:2:3 w lines lc pal lw liwid not,\
  for [j=1:Jmax] freqfile(j,i+2,day) binary format=freqform u 1:2:3 w lines lc pal lw liwid not

 }
 unset xlabel
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
 set yrange [0:1.4]
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
 set yrange [30:500]
 plot \
 for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 1:4 lc rgbcolor midcolor  pt ptype ps psbig not \
 ,for [i=0:imax(day)]  datfile(day).pad2(i).".dat" binary format=datform u 1:4:($6) lc pal  pt ptype ps psmall not\

 set logscale xy
 set autoscale xy
 set xtics 10
 unset mxtics
 set xrange [3:3000]
 set yrange [.05:3]
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
