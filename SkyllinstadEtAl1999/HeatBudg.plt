load termfile
set output outdir.abrev.termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
load termfile
load limfile
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
load outdir."sympal.plt"
set cbrange [hfxmin:hfxmax]
set cbtics hfxmin,(hfxmax-hfxmin)/2,hfxmax; set cbtics add ("0" 0)
set format cb cbform
set cblabel "W/m^3"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set ylabel "-{/Symbol \266}_zJ_{sgs}"
set colorbox user origin rloc(col)+cbgap,bloc(row+2)+0.075*vskip size cbwid,2*vskip+cbhig
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot datdir.abrev."dhfdz.dat" binary matrix w image notitle
#, \
#outdir.abrev."a.tab" lc 0 notitle
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "-{/Symbol r}c_p{/Symbol \266}_zw'T'"
set label 1 "b"
plot datdir.abrev."dwtdz.dat" binary matrix w image notitle
#, \
#outdir.abrev."a.tab" lc 0 notitle
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
load outdir."pospal.plt"
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
set output outdir.abrev."flx".termsfx
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
# Heat flux
load outdir."sympal.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set yrange [-.7:.7]
set ytics -1,.5,1
set ylabel "kW/m^2"
unset xlabel
set key horizontal
set key b r
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(0.001*$2) ls 1 title "J_0", \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(0.001*$2/3) w filledcurves y1=0 ls 7 title "{/Symbol \261}J_0/3", \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(-0.001*$2/3) w filledcurves y1=0 ls 7 notitle, \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:(0.001*$3) ls 2 title " J_{ML}"
unset y2tics
unset y2label
load limfile
load outdir."sympal.plt"
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key left bottom
set cbrange [hfxmin:hfxmax]
unset cbtics
set cbtics ("-0.5" -500 ,"0" 0, "+0.5" 500)
set format cb ""
set cblabel "kW/m^2"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set ylabel "{/Symbol r}c_pw'T'"
set label 1 "b"
set format x "%g"
set xlabel "2011 UTC yearday"
plot datdir.abrev."wt.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls -1 title "Mixed Layer"
#
unset multiplot
