set output outdir.abrev.termsfx
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
Nsqmax = 4e-4
Nsqmin = -Nsqmax
Rimax = 1.0
Rimin= -Rimax
cbform = "%+04.1te^{%+02T}"
rhotitle = "{/Symbol Dr}=0.05 kg/m^3"
rhocolor = "grey50"
Rictitle = "Ri =+1/4"
Riccolor = "black"
Ri0title = "Ri = 0  "
Ri0color = "grey30"
Rimtitle = "Ri =-1/4"
Rimcolor = "grey60"
set key l t
set format x ""
set format y "%gm"
#
# Common colorbar for Nsq and Ssq
load outdir."pospal.plt"
set format cb cbform
set cblabel "s^{-2}"
set cbrange [0:Nsqmax]
set cbtics 0,(Nsqmax)/2,Nsqmax; set cbtics add ("0" 0)
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
plot datdir.abrev."c.dat" binary matrix w image not, datdir.abrev."e.tab" lc rgbcolor rhocolor title rhotitle
unset colorbox
#
# Richardson Number
load outdir."sympal.plt"
set ylabel "Ri=N^2/S^2"
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set format cb cbform
set cblabel ""
set cbrange [-1:1]
set cbtics Rimin,(Rimax-Rimin)/2,Rimax
set cbtics add ("+1/4" .5, "-1/4" -.5, "0" 0, "+{/Symbol \245}" 1, "-{/Symbol \245}" -1, "-3/4" -.75, "+3/4" .75, "-1/12" -.25, "+1/12" .25)
set format cb ""
#set cblabel ""
#set cbrange [Rimin:Rimax]
#set cbtics Rimin,(Rimax-Rimin)/2,Rimax
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,1
set key l b
plot datdir.abrev."d.dat" binary matrix u 1:2:($3/(abs($3)+.25)) w image not
#,\
#datdir.abrev."d.tab" lc rgbcolor Riccolor title Rictitle,\
#datdir.abrev."d0.tab" lc rgbcolor Ri0color title Ri0title,\
#datdir.abrev."dm.tab" lc rgbcolor Rimcolor title Rimtitle
#
unset multiplot
