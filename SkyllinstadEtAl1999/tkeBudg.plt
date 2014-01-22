reset
load "/home/mhoecker/tmp/limits.plt"
set style data lines
abrev = "tkeBudg"
set output outdir.abrev.termsfx
# Setup spacing
rows = 5
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Kinetic Energy Sources/Sinks (Horizontal Averages)"
# all share the same left/right margins
set lmargin at screen lloc
set rmargin at screen rloc
tkemax = 5e-3
tkemin = 0
dtkemin = -2e-6
dtkemax = +2e-6
Ftkemin = -2e-6
Ftkemax = +2e-6
dxtic = .25
nullcolor = "grey20"
cbform = "%+4.1te^{%+02T}"
set xrange[t0sim:tfsim]
#
# Plot tke
set ylabel "tke"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(rows/2-1)+.1*vskip size 0.1*(1.0-rloc),(rows/2-.2)*(vskip)
set format x ""
set xlabel ""
set format cb cbform
set cblabel "J/kg"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/palcolors,tkemax
load outdir."pospal.plt"
field = "tke"
plot datdir.abrev.field.".dat" binary matrix w image not
unset colorbox
#
# Set common color bar for production/dissipation
set cbrange [dtkemin:dtkemax]
load outdir."sympal.plt"
set format cb cbform
set cblabel "W/kg"
set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
set colorbox user origin rloc,bloc(rows-1)+.1*vskip size 0.1*(1.0-rloc),(rows-rows/2-.2)*(vskip)
#
# Plot total d/dt of tke
#set tmargin at screen vmargin
#vmargin = vmargin-vskip
#set bmargin at screen vmargin
#set colorbox user origin rloc+.01,2*vskip/3.0 size .02,(rows)*vskip
#set cbrange [dtkemin:dtkemax]
#set format cb cbform."m^2s^{-3}"
#set cbtics dtkemin,(dtkemax-dtkemin)/palcolors,dtkemax
#set ylabel "^{d}/_{dt}(tke)"
#field = "dtkedt"
#plot datdir.abrev.field.".dat" binary matrix w image not,\
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#unset colorbox
#
# Plot Buoyancy
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "b'w'"
field = "bw"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset colorbox
#
# Plot Shear Production
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "SP"
field = "uudUdz"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Stokes Production
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "St"
field = "uudSdz"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Dissipation
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set xtics t0sim,dxtic,tfsim offset 0,xtoff
set mxtics 6
set ylabel "{/Symbol e}"
field = "diss"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset multiplot
#
set output outdir.abrev."flx".termsfx
# Setup spacing
rows = 4
row = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot title "Vertical Energy Transport (Horizontal Averages)"
# all share the same left/right margins
set lmargin at screen lloc
set rmargin at screen rloc
#
# Plot tke
set ylabel "tke"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc,bloc(rows/2-1)+.1*vskip size 0.1*(1.0-rloc),(rows/2-.2)*(vskip)
set format x ""
set xlabel ""
set format cb cbform
set cblabel "J/kg"
set cbrange [tkemin:tkemax]
set cbtics tkemin,(tkemax-tkemin)/palcolors,tkemax
load outdir."pospal.plt"
field = "tke"
plot datdir.abrev.field.".dat" binary matrix w image not
unset colorbox
#
# Set common color bar for Transport
set cbrange [Ftkemin:Ftkemax]
load outdir."sympal.plt"
set format cb cbform
set cblabel "Wm/kg"
set cbtics Ftkemin,(Ftkemax-Ftkemin)/palcolors,Ftkemax
set colorbox user origin rloc,bloc(rows-1)+.1*vskip size 0.1*(1.0-rloc),(rows-rows/2-.2)*(vskip)
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'P'"
field = "wpi"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset colorbox
#
# Plot Advective transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "w'tke"
field = "wtke"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "sgs"
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
set xtics t0sim,dxtic,tfsim offset 0,xtoff
set mxtics 6
field = "sgs"
plot datdir.abrev.field.".dat" binary matrix w image not,\
outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
unset multiplot
