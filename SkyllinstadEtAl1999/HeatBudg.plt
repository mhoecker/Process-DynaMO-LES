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
hfxmax = 5e1
hfxmin = -hfxmax
#
Tdispmax = 50.0
Tdispmin = 0.5
#
set multiplot title "Heat Budget"
# Heat flux
load pltdir."sympal.plt"
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
rows = 2
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
hfxmax = 750
hfxmin = -hfxmax
#
Tdispmax = 50.0
Tdispmin = 0.5
#
set multiplot title "Surface and Mixed layer Heat flux"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key left bottom
unset y2tics
unset y2label
load pltdir."sympal.plt"
unset colorbox
unset logscale
unset cbtics
set cbtics auto
set autoscale cb
set cbrange [hfxmin:hfxmax]
unset cbtics
set cbtics ("-0.5" -500 ,"0" 0, "+0.5" 500)
set format cb ""
set cblabel "kW/m^2"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set ylabel "{/Symbol r}c_pw'T'"
set label 1 "a"
set format x ""
set xlabel ""
plot datdir.abrev."wt.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls -1 title "Mixed Layer"
unset colorbox
# Heat flux
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set yrange [-.7:.7]
set ytics -1,.5,1
set ylabel "kW/m^2"
set key horizontal
set key b r
set label 1 "b"
set xlabel "2011 UTC yearday" offset 0,xloff
plot \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(0.001*$2) ls 1 title "J_0", \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(0.001*$2/3) w filledcurves y1=0 ls 3 title " {/Symbol \261}J_0/3", \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(-0.001*$2/3) w filledcurves y1=0 ls 3 notitle, \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(0.001*$3) ls 2 title " J_{ML}"
#
unset multiplot
