#richistogram.plt
# Setup spacing
rows = 1
cols = 1
col = 0
row = 0
#
load scriptdir."tlocbloc.plt"
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
#
set xrange [0:1]
set xtics .1
set colorbox
set encoding iso_8859_1
unset key
#
#set output pngdir.'phirank.png'
#set palette maxcolors 12
#set title "Ri"
#set cbtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0, "+{\274}" .5, "+{/Symbol \245}" 1)
#set cbrange [-1:1]
#plot datdir.'phirank.dat' binary matrix w image
##
#load pltdir."pospal.plt"
#set output pngdir.'Riirank.png'
#set cbtics auto
#set autoscale cb
##set logscale cb
#set format cb "10^{%+T}"
#plot datdir.'Rirank.dat' binary matrix w image
##
#load pltdir."negpal.plt"
#set title "Shear Squared"
#set output pngdir.'Ssqrank.png'
#set cbtics auto
#set autoscale cb
##set logscale cb
#plot datdir.'Ssqrank.dat' binary matrix w image
##
#load pltdir."negpal.plt"
#set title "Buoyancy Frequency Squared"
#set output pngdir.'Nsqrank.png'
#set cbtics auto
#set autoscale cb
##set logscale cb
#plot datdir.'Nsqrank.dat' binary matrix w image
##
#load pltdir."pospal.plt"
#set palette maxcolors 11
#set title "Shear Production"
#set output pngdir.'SPrank.png'
#set cbtics auto
#set logscale cb
#set cbrange [1e-8:1e-4]
#plot datdir.'SPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
##
#load pltdir."pospal.plt"
#set palette maxcolors 11
#set title "Ri Ranked by Shear Production"
#set output pngdir.'RiSPrank.png'
#set cbtics auto
#set autoscale cb
#set logscale cb
##plot datdir.'RiSPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
##
#load pltdir."sympal.plt"
#set palette maxcolors 11
#set title "Ri Ranked by Shear Production"
#set output pngdir.'phiSPrank.png'
#unset logscale cb
#set format cb "%g"
#set cbtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
#set cbrange [-1:1]
#plot datdir.'phiSPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
#
#load pltdir."pospal.plt"
#set autoscale
#unset logscale
#set xtics auto out mirror
#set ytics auto out mirror
#set xrange [0:1]
#set xlabel "Ri"
#set ylabel "SP percentile"
#set yrange [0:1]
#set logscale cb
#set cbrange [10**(-3):1]
#set cbtics 10
#set format cb "10^{%T}"
#set format x "%g"
#set xtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
#set xtics out mirror
#set output pngdir.'Hphi.png'
#plot datdir."Hphi.dat" binary matrix w image
##
#load pltdir."pospal.plt"
#unset logscale x
#set xrange [-5:7]
#set xtics 2
#set xtics out mirror
#set xlabel "log_2(Ri)"
#set output pngdir.'HRi.png'
#plot datdir."HLRi.dat" binary matrix w image
##
#load pltdir."pospal.plt"
#set title "Shear Production with percentiles"
#set autoscale
#set xtics auto
#set ytics auto
#set ylabel "Z (m)"
#set xlabel "time (hr)"
#set cbrange [1e-12:1e-4]
#set xrange [328:329.25]
#set yrange [-80:0]
#set output pngdir.'SP.png'
#set key
#set key samplen 1
#set key spacing 1.05
#set key b l
#plot datdir."SP.dat" binary matrix w image not,\
#datdir."SPcntr075.dat" w lines lc rgbcolor "#FFFFFF" title "75%",\

#set title ""
#
# Setup spacing
#rows = 2
#cols = 1
#col = 0
#row = 0
#
#load scriptdir."tlocbloc.plt"
#set output pngdir.'phiSPflat.png'
#set xrange [0:1]
#unset logscale cb
#set autoscale y
#set multiplot title "Ri Ranked by Shear Production"
#set rmargin at screen rloc(col)
#set lmargin at screen lloc(col)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set logscale y
#set ytics auto
#set xlabel ""
#set format x ""
#set format cb "%g"
#set style data points
#plot datdir.'flat.dat' binary format="%f%f%f%f%f%f%f" u 1:6 lc -1
#
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#unset logscale y
#set xlabel "Percentile"
#set format x "%g"
#set yrange [0:1]
#set format y "%g"
#set ytics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
#plot datdir.'flat.dat' binary format="%f%f%f%f%f%f%f" u 1:7 lc -1
#unset multiplot
#
#
#set output pngdir."test.png"
#test
#
#set output pngdir.'HphiPM.png'
#set multiplot
# Setup spacing
#rows = 2
#cols = 1
#col = 0
#row = 0
#
#load scriptdir."tlocbloc.plt"
#load pltdir."sympalnan.plt"
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set key t l
#set ylabel "Abundance"
#set xlabel ""
#set format x "%g"
#set autoscale y
#set ytics auto
#set format y "%g"
#set xtics out nomirror
#set xtics ("" -1, "" -.5, "" 0, "" .5, "" 1)
#set xrange [0:1]
#unset colorbox
#plot datdir.'HphiPM.dat' binary format="%f%f%f" u 1:2 w lines ls 1 title ">".SPpc."%",\
#datdir.'HphiPM.dat' binary format="%f%f%f" u 1:3 w lines ls 2 title "<".SPpc."%"
#
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set ytics auto out nomirror
#set xlabel "Ri"
#set ylabel "SP percentile"
#set yrange [0:100]
#set logscale cb
#load pltdir."pospal.plt"
#set cbrange [10**(-3):1]
#set cbtics 10
#set format cb "10^{%T}"
#set format y "%g"
#set colorbox
#set xtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
#plot datdir."Hphi.dat" binary matrix u 1:(100*$2):3 w image
#unset multiplot
#unset logscale
#
#
set output pngdir.'HLRiPM.png'
set multiplot title "Richardson Number Distribution"
# Setup spacing
rows = 2
cols = 1
col = 0
row = 0
#
load scriptdir."tlocbloc.plt"
load pltdir."grey.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key t r
set ylabel "Fraction"
set xlabel ""
set format x "%g"
set yrange [0:.07]
set ytics 0,.03
set format y "%g"
set xtics out nomirror
set xtics ("" -1,  "" 0, "" 1)
set xrange [-2.5:3]
set format x ""
unset colorbox
set label 1 "a"
plot datdir.'HLRiPM.dat' binary format="%f%f%f" u ($1/2):2 w lines ls 11 title ">".SPpc."%",\
datdir.'HLRiPM.dat' binary format="%f%f%f" u ($1/2):3 w lines ls 12 title "<".SPpc."%"
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
load pltdir."grey.plt"
set ytics 0,100 out nomirror
set ylabel "SP percentile"
set yrange [0:100]
set cbrange [10**(-2):1]
set logscale cb 10
set cblabel "Fraction"
set format cb "10^{%T}"
set format y "%g"
set xtics ("1/4" -1,  "1" 0, "4" 1)
set xtics add ("1^{ }" 0)
set ytics add (SPpc)
set xlabel "Richardson Number"
set colorbox
set label 1 "b"
plot datdir."HLRi.dat" binary matrix u ($1/2):(100*$2):3 w image not,\
SPpc lc rgbcolor "white" lw 1 not,\
SPpc lt 0 lc 0 not
unset logscale cb
unset multiplot
unset logscale
