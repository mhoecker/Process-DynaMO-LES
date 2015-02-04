load termfile
set output pngdir.abrev.termsfx
set style data lines
# Setup vertical spacing
rows = 3
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
#
set multiplot title "Shear, Stratification, and L_o"
#
Nsqmax = 4e-4
Nsqmin = -Nsqmax
cbform = "%+04.1te^{%+02T}"
rhotitle = " {/Symbol Dr}=100 g/m^3"
rhocolor = "grey50"
set cbtics (Nsqmin, "0" 0, Nsqmax)
set key l b opaque
set format x ""
set format y "%3.0fm"
#
# Common colorbar for Nsq and Ssq
load pltdir."sympal.plt"
set format cb cbform
set cblabel "(rad/s)^{2}"
#set logscale cb
set cbrange [Nsqmin:Nsqmax]
set colorbox user origin rloc(col)+cbgap,bloc(row+1) size cbwid,2*cbhig+vgap
#
# Nsq
set ylabel "N^2"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
set label 1 "a"
plot \
datdir.abrev."b.dat" binary matrix w image not,\
datdir.abrev."e.tab" lc rgbcolor rhocolor title rhotitle
#datdir.abrev."b.tab" ls 1 title " N^2",\
#datdir.abrev."c.tab" ls 2 title " S^2/4"
unset colorbox
#
# Ssq
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "S^2/4"
set label 1 "b"
plot datdir.abrev."c.dat" binary matrix u 1:2:($3/4) w image not, datdir.abrev."e.tab" lc rgbcolor rhocolor title rhotitle
unset colorbox
unset logscale cb
row = nextrow(row)
#
# L_o
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set autoscale cb
#set cbtics .1,10
set logscale cb
set cblabel "L_o"
set cbtics ("  1" 1," 10" 10,"100" 100)
set cbrange [1:100]
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
load pltdir."pospalnan.plt"
set ylabel ""
set label 1 "c"
set format x "%g"
set xlabel "2011 UTC yearday"
plot datdir.abrev."LO.dat" binary matrix u 1:2:3 w image not
unset colorbox
unset logscale cb
#row = nextrow(row)
#
#
# Richardson Number
#load pltdir."sympal.plt"
#set ylabel "Ri=N^2/S^2"
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
#set format cb cbform
#set cblabel ""
#set cbrange [-1:1]
#set cbtics Rimin,(Rimax-Rimin)/2,Rimax
#set cbtics add ("0" 0)
#set cbtics add ("+1/4" +.5,"+{/Symbol \245}" +1, "+3/4" +.75, "+1/12" +.25)
#set cbtics add ("-1/4" -.5,"-{/Symbol \245}" -1, "-3/4" -.75, "-1/12" -.25)
#set format cb ""
#set cblabel ""
#set cbrange [Rimin:Rimax]
#set cbtics Rimin,(Rimax-Rimin)/2,Rimax
#set format x "%g"
#set xlabel "2011 UTC yearday" offset 0,1
#unset key
#set label 1 "b"
#plot datdir.abrev."d.dat" binary matrix u 1:2:($3/(abs($3)+.25)) w image not
#
unset multiplot
#
load termfile
set output pngdir.abrev."alt".termsfx
set style data lines
# Setup vertical spacing
rows = 1
row = 0
cols = 1
col = 0
#
load scriptdir."tlocbloc.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
load pltdir."sympal.plt"
set label 1 ""
plot \
datdir.abrev."b.tab" ls 1 title " N^2",\
datdir.abrev."c.tab" ls 2 title " S^2/4"
