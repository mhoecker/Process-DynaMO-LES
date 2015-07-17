load termfile
set output pngdir.abrev.termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
cbform = "%+4.1te^{%+02T}"
#
set autoscale cb
set cbtics auto
# heat flux
hfxmax=0
#
stats datdir.abrev."dhfdz.dat" binary matrix u 3
hfxmax = (STATS_max>hfxmax)? STATS_max : hfxmax
hfxmax = (abs(STATS_min)>hfxmax)? abs(STATS_min) : hfxmax
#
stats datdir.abrev."dwtdz.dat" binary matrix u 3
hfxmax = (STATS_max>hfxmax)? STATS_max : hfxmax
hfxmax = (abs(STATS_min)>hfxmax)? abs(STATS_min) : hfxmax
#"dTdt.dat"
stats datdir.abrev."dTdt.dat"	 binary matrix u 3
hfxmax = (STATS_max>hfxmax)? STATS_max : hfxmax
hfxmax = (abs(STATS_min)>hfxmax)? abs(STATS_min) : hfxmax
#
hfxmax = (hfxmax>0) ? hfxmax*2 : 1
hfxmin = -hfxmax
#
Tdispmax = 50.0
Tdispmin = 0.5
#
set multiplot title "Heat Budget"
# Heat flux
load pltdir."sympal.plt"
#set autoscale cb
set cbrange [hfxmin:hfxmax]
set cbtics hfxmin,(hfxmax-hfxmin)/2,hfxmax; set cbtics add ("0" 0)
set format cb cbform
set cblabel "W/m^3"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set ylabel "-{/Symbol \266}_zJ_{sgs}"
set colorbox user origin rloc(col)+cbgap,bloc(row+2)+0.075*vskip size cbwid,2*vskip+cbhig
set label 1 "a"
plot datdir.abrev."dhfdz.dat" binary matrix w image notitle
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "-{/Symbol r}c_p{/Symbol \266}_zw'T'"
set label 1 "b"
plot datdir.abrev."dwtdz.dat" binary matrix w image notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol r}c_p{/Symbol \266}_tT"
set label 1 "c"
plot datdir.abrev."dTdt.dat" binary matrix w image notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set logscale cb
load pltdir."pospal.plt"
set cbrange [Tdispmin:Tdispmax]
unset mcbtics
set cbtics Tdispmin,(Tdispmax/Tdispmin)**(1.0/2),Tdispmax
# autoscale colors
#set cbtics auto;set autoscale cb;unset logscale cb
set format cb cbform
set cblabel "m"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set ylabel "T'_{rms}/|{/Symbol \266}_zT|"
set format x "%g"
set xlabel "2011 UTC yearday"
set label 1 "d"
plot datdir.abrev."T_dTdz.dat" binary matrix w image notitle
unset logscale
unset colorbox
#
unset multiplot
#
#
#
#
#
#
#
#
#
set output pngdir.abrev."flx".termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
cbform = "%+g"
#
set autoscale cb
set cbtics auto
# heat flux
hdimax = hfxmax
hdimin = -hfxmax
hfxmin = -hfxmax
#
Tdispmax = 50.0
Tdispmin = 0.5
#
set multiplot title "Heat fluxes"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key left bottom horizontal
unset y2tics
unset y2label
load pltdir."sympal.plt"
load pltdir.abrev."timedepth.plt"
unset colorbox
unset logscale
unset cbtics
set cbtics auto
set format cb "%3.0s%c"
set cblabel "{/Symbol r}c_pw'T'\n[W/m^2]"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set cbrange [hfxmin:hfxmax]
set ylabel "z [m]"
set label 1 "a"
set format x ""
set xlabel ""
plot datdir.abrev."wt.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not,\
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls 11 notitle,\
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not,\
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 ls 12 notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key left bottom horizontal
unset y2tics
unset y2label
load pltdir."pospal.plt"
load pltdir.abrev."timedepth.plt"
unset colorbox
unset logscale
unset cbtics
set cbtics auto
set format cb "%3.0s%c"
set cblabel "T [C]"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set autoscale cb
set ylabel "z [m]"
set label 1 "b"
set format x ""
set xlabel ""
plot datdir.abrev."d.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not,\
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls 11 not,\
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not,\
datdir.abrev."ML2.dat" binary form="%float%float%float" u 1:2 ls 12 not
#
unset colorbox
set size ratio 0
# Heat flux
row = nextrow(row)
row = nextrow(row)
set tmargin at screen tloc(row-1)
set bmargin at screen bloc(row)
set format x "%g"
set autoscale y
set yrange [-800:100]
set ytics auto
set ylabel "Heat flux [W/m^2]"
set key horizontal
#set key opaque
set key right top
set key vertical reverse Left at screen 1, screen tloc(row-1) samplen 1
set label 1 "c"
set xlabel "2011 UTC yearday" offset 0,xloff
plot \
datdir.abrev."Jh.dat" binary form="%float%float%float%float" u 1:2 lw 2 lc rgbcolor "white" not, \
datdir.abrev."Jh.dat" binary form="%float%float%float%float" u 1:2 ls 13 title "Surface", \
datdir.abrev."Jh.dat" binary form="%float%float%float%float" u 1:3 lw 2 lc rgbcolor "white" not, \
datdir.abrev."Jh.dat" binary form="%float%float%float%float" u 1:3 ls 11 title "0.01 kg/m^3", \
datdir.abrev."Jh.dat" binary form="%float%float%float%float" u 1:4 lw 2 lc rgbcolor "white" not, \
datdir.abrev."Jh.dat" binary form="%float%float%float%float" u 1:4 ls 12 title "0.10 kg/m^3"
#
unset multiplot
