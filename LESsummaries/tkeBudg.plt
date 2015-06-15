# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
load pltdir.abrev."timedepth.plt"
#
set output pngdir.abrev.termsfx
#
set multiplot
# all share the same left/right margins
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
tkemax = 5e-3
tkemin = 0
dtkemax = 0
Ftkemax = 0
nullcolor = "grey20"
cbform = "%3.0se%S"
set yrange [-dplt:0]
#
# Set common color bar for production/dissipation
field = "uudSdz"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
dtkemax = (STATS_up_quartile>dtkemax)? STATS_up_quartile : dtkemax
dtkemax = (abs(STATS_lo_quartile)>dtkemax)? abs(STATS_lo_quartile) : dtkemax
#
field = "uudUdz"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
dtkemax = (STATS_up_quartile>dtkemax)? STATS_up_quartile : dtkemax
dtkemax = (abs(STATS_lo_quartile)>dtkemax)? abs(STATS_lo_quartile) : dtkemax
#
field = "bw"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
dtkemax = (STATS_up_quartile>dtkemax)? STATS_up_quartile : dtkemax
dtkemax = (abs(STATS_lo_quartile)>dtkemax)? abs(STATS_lo_quartile) : dtkemax
#
field = "diss"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
dtkemax = (STATS_up_quartile>dtkemax)? STATS_up_quartile : dtkemax
dtkemax = (abs(STATS_lo_quartile)>dtkemax)? abs(STATS_lo_quartile) : dtkemax
#
dtkemax = 2*dtkemax
dtkemin = -dtkemax
#
field = "wtke"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
Ftkemax = (STATS_up_quartile>Ftkemax)? STATS_up_quartile : Ftkemax
Ftkemax = (abs(STATS_lo_quartile)>Ftkemax)? abs(STATS_lo_quartile) : Ftkemax
field = "wpi"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
Ftkemax = (STATS_up_quartile>Ftkemax)? STATS_up_quartile : Ftkemax
Ftkemax = (abs(STATS_lo_quartile)>Ftkemax)? abs(STATS_lo_quartile) : Ftkemax
field = "sgs"
stats datdir.abrev.field.".dat" binary matrix u 3 nooutput
Ftkemax = (STATS_up_quartile>Ftkemax)? STATS_up_quartile : Ftkemax
Ftkemax = (abs(STATS_lo_quartile)>Ftkemax)? abs(STATS_lo_quartile) : Ftkemax
#
Ftkemax = 2*Ftkemax
Ftkemin = -Ftkemax
#
set cbrange [dtkemin:dtkemax]
load pltdir."sympal.plt"
set format cb cbform
set cblabel "W/kg"
set cbtics auto
set colorbox user origin rloc(col)+cbgap,bloc(rows-1) size cbwid,(rows-1)*vskip+cbhig
# Plot Stokes Production
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set xlabel ""
field = "uudSdz"
set ylabel "z [m]"
set label 1 "a: StP"
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
unset colorbox
#
# Plot Shear Production
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
field = "uudUdz"
set label 1 "b: SP"
if(exists("SPcontour")){
set key b l
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not,\
SPcontour w lines lc -1 lw .5 title "".SPpc."%";\
}
else{
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
}
#
# Plot Buoyancy
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
field = "bw"
set label 1 "c: b'w'"
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
#
# Plot Dissipation
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
field = "diss"
set label 1 "d: {/Symbol e}"
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
unset multiplot
#
set output pngdir.abrev."flx".termsfx
# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot
# all share the same left/right margins
#set lmargin at screen lloc(col)
#set rmargin at screen rloc(col)
#
# Plot tke
#set ylabel "z [m]"
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,+cbhig
#set format x ""
#set xlabel ""
#set format cb cbform
#set cblabel "J/kg"
#set cbrange [tkemin:tkemax]
#set cbtics tkemin,(tkemax-tkemin)/2,tkemax;set cbtics add ("0" 0)
#load pltdir."pospal.plt"
#field = "tke"
#set label 1 "a: Turbulent Kinetic Energy"
#plot datdir.abrev.field.".dat" binary matrix w image not
#unset colorbox
#
# Set common color bar for Transport
set cbrange [Ftkemin:Ftkemax]
load pltdir."sympal.plt"
load pltdir.abrev."timetics.plt"
set format cb cbform
set palette maxcolors 13
set cblabel "Transport Wm/kg"
set colorbox user origin rloc(col)+cbgap,bloc(rows-2) size cbwid,(rows-2)*vskip+cbhig
#set autoscale cb
#set cbtics auto
#
# Plot Advective transport
#row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set xlabel ""
field = "wtke"
set label 1 "a: w'tke"
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
field = "wpi"
set label 1 "b: w'p'"
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset colorbox
#
# Plot sub-gridscale transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
field = "sgs"
set label 1 "c: sgs"
plot datdir.abrev.field.".dat" binary matrix u 1:2:3 w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
unset multiplot
#
#load datdir.abrev."profiles.plt"
#
