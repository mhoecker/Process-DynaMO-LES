set style data lines
set output outdir.abrev.termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
set multiplot title "Kinetic Energy Sources/Sinks"
# all share the same left/right margins
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
tkemax = 5e-3
tkemin = 0
dtkemin = -10e-6
dtkemax = +10e-6
Ftkemin = -10e-6
Ftkemax = +10e-6
nullcolor = "grey20"
cbform = "%+4.1te^{%+02T}"
set xrange[t0sim:tfsim]
#
# Plot tke
#set ylabel "tke"
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
#set format x ""
#set xlabel ""
#set format cb cbform
#set cblabel "J/kg"
#set cbrange [tkemin:tkemax]
#set cbtics tkemin,(tkemax-tkemin)/2,tkemax;set cbtics add ("0" 0)
#load outdir."pospal.plt"
#field = "tke"
#plot datdir.abrev.field.".dat" binary matrix w image not
#unset colorbox
#
# Set common color bar for production/dissipation
set cbrange [dtkemin:dtkemax]
load outdir."sympal.plt"
set format cb "%3.s%cW/kg"
set cblabel ""
set cbtics dtkemin,(dtkemax-dtkemin),dtkemax;set cbtics add ("0" 0)
set colorbox user origin rloc(col)+cbgap,bloc(rows-1) size cbwid,(rows-1)*vskip+cbhig
#
# Plot total d/dt of tke
#set tmargin at screen vmargin
#vmargin = vmargin-vskip
#set bmargin at screen vmargin
#set colorbox user origin rloc(col)+.01,2*vskip/3.0 size .02,(rows)*vskip
#set cbrange [dtkemin:dtkemax]
#set format cb cbform."m^2s^{-3}"
#set cbtics dtkemin,(dtkemax-dtkemin),dtkemax;set cbtics add ("0" 0)
#set ylabel "^{d}/_{dt}(tke)"
#field = "dtkedt"
#plot datdir.abrev.field.".dat" binary matrix w image not
##outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#unset colorbox
#
# Plot Stokes Production
#row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set xlabel ""
set ylabel "St"
field = "uudSdz"
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot datdir.abrev.field.".dat" binary matrix w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Shear Production
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "SP"
field = "uudUdz"
set label 1 "b"
plot datdir.abrev.field.".dat" binary matrix w image not
#,\
##outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Buoyancy
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
field = "bw"
set label 1 "c"
plot datdir.abrev.field.".dat" binary matrix w image not
#,\
##outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset colorbox
#
# Plot Dissipation
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set ylabel "{/Symbol e}"
field = "diss"
set label 1 "d"
plot datdir.abrev.field.".dat" binary matrix w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset multiplot
#
set output outdir.abrev."flx".termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Kinetic Energy Density/Transport"
# all share the same left/right margins
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
# Truncated depth range
set yrange [-40:0]
#
# Plot tke
set ylabel "tke"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,+cbhig
set format x ""
set xlabel ""
set format cb cbform
set cblabel "J/kg"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/2,tkemax;set cbtics add ("0" 0)
load outdir."pospal.plt"
field = "tke"
set label 1 "a" at graph 0, graph 1 left front textcolor rgbcolor "grey30" nopoint offset character 0,character .3
plot datdir.abrev.field.".dat" binary matrix w image not
unset colorbox
#
# Set common color bar for Transport
set cbrange [Ftkemin:Ftkemax]
load outdir."sympal.plt"
set format cb "%3.s%cWm/kg"
set cbtics Ftkemin,(Ftkemax-Ftkemin),Ftkemax;set cbtics add ("0" 0)
set colorbox user origin rloc(col)+cbgap,bloc(rows-1) size cbwid,(rows-2)*vskip+cbhig
#
# Plot Advective transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set xlabel ""
set ylabel "w'tke"
field = "wtke"
set label 1 "b"
plot datdir.abrev.field.".dat" binary matrix w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'P'"
field = "wpi"
set label 1 "c"
plot datdir.abrev.field.".dat" binary matrix w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset colorbox
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "sgs"
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
field = "sgs"
set label 1 "d"
plot datdir.abrev.field.".dat" binary matrix w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
unset multiplot
#
#load datdir.abrev."profiles.plt"
#
