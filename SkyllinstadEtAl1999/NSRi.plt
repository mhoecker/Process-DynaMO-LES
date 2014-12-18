load termfile
set output pngdir.abrev.termsfx
set style data lines
# Setup vertical spacing
rows = 2
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
#
set multiplot title "Instability Criterion"
#
Nsqmax = 1e-2
Nsqmin = -Nsqmax
Rimax = 1.0
Rimin= -Rimax
cbform = "%+04.1te^{%+02T}"
rhotitle = " {/Symbol Dr}=100 g/m^3"
rhocolor = "grey50"
Rictitle = "Ri =+1/4"
Riccolor = "black"
Ri0title = "Ri = 0  "
Ri0color = "grey30"
Rimtitle = "Ri =-1/4"
Rimcolor = "grey60"
set key l b opaque
set format x ""
set format y "%gm"
#
# Common colorbar for Nsq and Ssq
load pltdir."pospal.plt"
set format cb cbform
set cblabel "s^{-2}"
set logscale cb
set cbrange [1e-2*Nsqmax:Nsqmax]
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
#
# Nsq
#set ylabel "N^2"
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#row = nextrow(row)
#plot datdir.abrev."b.dat" binary matrix w image not, datdir.abrev."e.tab"  lc rgbcolor rhocolor title rhotitle
#unset colorbox
#
# Ssq
#row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "S^2"
set label 1 "a"
plot datdir.abrev."c.dat" binary matrix w image not, datdir.abrev."e.tab" lc rgbcolor rhocolor title rhotitle
unset colorbox
unset logscale cb
#
# Richardson Number
load pltdir."sympal.plt"
set ylabel "Ri=N^2/S^2"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set format cb cbform
set cblabel ""
set cbrange [-1:1]
set cbtics Rimin,(Rimax-Rimin)/2,Rimax
set cbtics add ("0" 0)
set cbtics add ("+1/4" +.5,"+{/Symbol \245}" +1, "+3/4" +.75, "+1/12" +.25)
set cbtics add ("-1/4" -.5,"-{/Symbol \245}" -1, "-3/4" -.75, "-1/12" -.25)
set format cb ""
#set cblabel ""
#set cbrange [Rimin:Rimax]
#set cbtics Rimin,(Rimax-Rimin)/2,Rimax
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,1
unset key
set label 1 "b"
plot datdir.abrev."d.dat" binary matrix u 1:2:($3/(abs($3)+.25)) w image not
#
unset multiplot
