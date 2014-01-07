reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
abrev = "HeatBudg"
set output outdir.abrev.termsfx
# Setup spacing
rows = 4
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
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
set cbtics hfxmin,(hfxmax-hfxmin)/palcolors,hfxmax
set format cb cbform."W/m^3"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set ylabel "-{/Symbol \266}_zJ_{sgs}"
set colorbox user origin rloc,bloc(row+2)+.1*vskip size 0.1*(1.0-rloc),2.8*(vskip)
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
set cbtics Tdispmin,(Tdispmax/Tdispmin)**(1.0/palcolors),Tdispmax
# autoscale colors
#set cbtics auto;set autoscale cb;unset logscale cb
set format cb cbform."m"
set colorbox user origin rloc,bloc(row)+.1*vskip size 0.1*(1.0-rloc),0.8*(vskip)
set ylabel "T'_{rms}/|{/Symbol \266}_zT|"
set format x "%g"
plot datdir.abrev."T_dTdz.dat" binary matrix w image notitle
unset logscale
#
unset multiplot
