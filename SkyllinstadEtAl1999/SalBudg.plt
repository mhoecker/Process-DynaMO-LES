load termfile
set output pngdir.abrev.termsfx
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
sfxmax = 5e-5
sfxmin = -sfxmax
#
Tdispmax = 50.0
Tdispmin = 0.5
#
set multiplot title "Salinity Budget"
# Heat flux
load pltdir."sympal.plt"
set cbrange [sfxmin:sfxmax]
set cbtics sfxmin,(sfxmax-sfxmin)/2,sfxmax; set cbtics add ("0" 0)
set format cb cbform
set cblabel "psu/s"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set ylabel "-{/Symbol \266}_zJ_{sgs}"
set colorbox user origin rloc(col)+cbgap,bloc(row+2)+0.075*vskip size cbwid,2*vskip+cbhig
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot datdir.abrev."dsfdz.dat" binary matrix w image notitle
#, \
#datdir.abrev."a.tab" lc 0 notitle
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "-{/Symbol \266}_zw'S'"
set label 1 "b"
plot datdir.abrev."dwsdz.dat" binary matrix w image notitle
#, \
#datdir.abrev."a.tab" lc 0 notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol \266}_tS"
set label 1 "c"
plot datdir.abrev."dSdt.dat" binary matrix w image notitle
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
set ylabel "S'_{rms}/|{/Symbol \266}_zS|"
set format x "%g"
set xlabel "2011 UTC yearday"
set label 1 "d"
plot datdir.abrev."S_dSdz.dat" binary matrix w image notitle
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
#
Tdispmax = 50.0
Tdispmin = 0.5
#
sfxmin = -1e-3
sfxmax = +1e-3
set autoscale cb
#
set multiplot title "Surface and Mixed Layer Salt Flux"
# Heat flux
load pltdir."sympal.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set yrange [0:1]
set ytics -1,.5,1
set ylabel "psu mm/s"
unset xlabel
set key horizontal
set key top left
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot \
datdir.abrev."SFC_ML_flx.dat" binary format="%f%f%f" u 1:($2*1e3) ls 1 title "Surface", \
datdir.abrev."SFC_ML_flx.dat" binary form="%f%f%f" u 1:($3*1e3) ls 2 title "<w's'>_{x,y} @ {ML}"

unset y2tics
unset y2label
load limfile
load pltdir."sympal.plt"
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set key left bottom
set cbrange [sfxmin:sfxmax]
#unset cbtics
#set cbtics ("-0.5" -500 ,"0" 0, "+0.5" 500)
#set format cb ""
set cblabel "psu m/s"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set ylabel "psu m/s"
set label 1 "b"
set format x "%g"
set xlabel "2011 UTC yearday"
plot datdir.abrev."ws.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls -1 title "Mixed Layer"
#
unset multiplot
