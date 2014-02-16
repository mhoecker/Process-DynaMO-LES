set output outdir.abrev.termsfx
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
set xtics t0sim,.25,tfsim
set mxtics 6
set xrange [t0sim:tfsim]
load outdir."sympal.plt"
set cbrange [hfxmin:hfxmax]
set cbtics hfxmin,(hfxmax-hfxmin)/2,hfxmax; set cbtics add ("0" 0)
set format cb cbform
set cblabel "W/m^3"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set ylabel "-{/Symbol \266}_zJ_{sgs}"
set colorbox user origin rloc(col),bloc(row+2)+0.075*vskip size 0.1*(1.0-rloc(col)),2.85*vskip
plot datdir.abrev."dhfdz.dat" binary matrix w image notitle
#, \
#outdir.abrev."a.tab" lc 0 notitle
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "-{/Symbol r}c_p{/Symbol \266}_zw'T'"
plot datdir.abrev."dwtdz.dat" binary matrix w image notitle
#, \
#outdir.abrev."a.tab" lc 0 notitle
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol r}c_p{/Symbol \266}_tT"
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
set colorbox user origin rloc(col),bloc(row)+0.075*vskip size 0.1*(1.0-rloc(col)),0.85*vskip
set ylabel "T'_{rms}/|{/Symbol \266}_zT|"
set format x "%g"
set xlabel "2011 UTC yearday"
plot datdir.abrev."T_dTdz.dat" binary matrix w image notitle
unset logscale
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
hdimax = hfxmax
hdimin = -hfxmax
hfxmax = 8e2
hfxmin = -hfxmax
#
Tdispmax = 50.0
Tdispmin = 0.5
#
set multiplot title "Heat flux"
# Heat flux
set xtics t0sim,.25,tfsim
set mxtics 6
set xrange [t0sim:tfsim]
load outdir."sympal.plt"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set y2range [0:1.5]
set yrange [-900:900]
set ytics -800,400
set ylabel "W/m^s"
unset xlabel
set key horizontal
set key samplen 1
set key left top
plot \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:2 w lines lc -1 title "J_0", \
datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:3 w lines lc rgbcolor "grey" title " J_{ML}",\
#, \
#outdir.abrev."a.tab" lc 0 notitle
unset y2tics
unset y2label
load scriptdir."tlocbloc.plt"
unset colorbox
#
set key left bottom
set cbrange [hfxmin:hfxmax]
set cbtics hfxmin,(hfxmax-hfxmin)/2,hfxmax; set cbtics add ("0" 0)
set format cb cbform
set cblabel "W/m^2"
set xlabel ""
set colorbox user origin rloc(col),bloc(row+1)+0.075*vskip size 0.1*(1.0-rloc(col)),0.85*vskip
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "{/Symbol r}c_pw'T'"
plot datdir.abrev."wt.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 w lines lc -1 title "Mix Layer"
#outdir.abrev."a.tab" lc 0 notitle
unset colorbox
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set yrange [-1.4:1.4]
set ytics .5
set ylabel "J_{ML}/J_0"
plot datdir.abrev."Jh.dat" binary form="%float%float%float" u 1:($3/$2) w lines lc -1 not
unset colorbox
load scriptdir."tlocbloc.plt"
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
set colorbox user origin rloc(col),bloc(row)+0.075*vskip size 0.1*(1.0-rloc(col)),0.85*vskip
set ylabel "T'_{rms}/|{/Symbol \266}_zT|"
set format x "%g"
set xlabel "2011 UTC yearday"
plot datdir.abrev."T_dTdz.dat" binary matrix w image notitle, \
datdir.abrev."ML.dat" binary form="%float%float%float" u 1:2 w lines lc -1 title "Mix Layer"
unset logscale
#
unset multiplot
