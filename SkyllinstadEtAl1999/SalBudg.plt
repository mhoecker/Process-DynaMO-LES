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
sfxmax = 4.0e-5
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
set label 1 "a"
plot datdir.abrev."dsfdz.dat" binary matrix w image notitle
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "-{/Symbol \266}_zw'S'"
set label 1 "b"
plot datdir.abrev."dwsdz.dat" binary matrix w image notitle
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
sfxmin = -1.0e-4
sfxmax = +1.0e-4
set autoscale cb
#
set multiplot title "Surface and Mixed Layer Salt Flux"
# Heat flux
load pltdir."sympal.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set xlabel ""
set key left bottom
set cbrange [sfxmin:sfxmax]
unset cbtics
set cbtics ("-0.1" -1e-4 ,"0" 0, "+0.1" 1e-4)
set format cb ""
set cblabel "w'S'\n(psu mm/s)"
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
set ylabel "Depth (m)"
set label 1 "a"
plot datdir.abrev."ws.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 ls -1 title "Mixed Layer"
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday"
set yrange [0:.19]
set ytics -1.2,.1,1.2
set ylabel "psu mm/s"
set key horizontal
set key top left
set label 1 "b"
plot \
datdir.abrev."SFC_ML_flx.dat" binary format="%f%f%f" u 1:($2*1e3) ls 1 title "Surface", \
datdir.abrev."SFC_ML_flx.dat" binary form="%f%f%f" u 1:($3*1e3) ls 2 title "w'S' at ML"
#
unset multiplot
