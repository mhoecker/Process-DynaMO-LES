# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
set output pngdir.abrev.termsfx
#
set multiplot
# all share the same left/right margins
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
tkemax = 5e-3
tkemin = 0
dtkemin = -3e0
dtkemax = +3e0
Ftkemin = -2
Ftkemax = +2
nullcolor = "grey20"
cbform = "%+4.1te^{%+02T}"
set xrange[t0sim:tfsim]
set yrange [-dplt:0]
#
# Set common color bar for production/dissipation
set cbrange [dtkemin:dtkemax]
load pltdir."sympal.plt"
set format cb "%+3.1f"
set cblabel "{/Symbol m}W/kg"
set cbtics dtkemin,(dtkemax-dtkemin),dtkemax;set cbtics add ("0" 0)
set colorbox user origin rloc(col)+cbgap,bloc(rows-1) size cbwid,(rows-1)*vskip+cbhig
# Plot Stokes Production
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x ""
set xlabel ""
field = "uudSdz"
set ylabel "z [m]"
set label 1 "a: StP"
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
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
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not,\
SPcontour w lines lc -1 lw .5 title "".SPpc."%";\
}
else{
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
}
#
# Plot Buoyancy
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
field = "bw"
set label 1 "c: b'w'"
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
#
# Plot Dissipation
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format x "%g"
set xlabel "2011 UTC yearday" offset 0,xloff
field = "diss"
set label 1 "d: {/Symbol e}"
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
unset multiplot
#
set output pngdir.abrev."flx".termsfx
# Setup spacing
rows = 2
row = 0
cols = 1
col = 0
load "/home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/tlocbloc.plt"
#
set multiplot
# all share the same left/right margins
#set lmargin at screen lloc(col)
#set rmargin at screen rloc(col)
# Truncated depth range
set yrange [-dplt:0]
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
set format cb "%+4.1f"
set cblabel "Transport {/Symbol m}Wm/kg"
set cbtics Ftkemin,(Ftkemax-Ftkemin),Ftkemax;set cbtics add ("0" 0)
set colorbox user origin rloc(col)+cbgap,bloc(rows-1) size cbwid,(rows-1)*vskip+cbhig
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
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
# Plot Pressure transport
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
field = "wpi"
set label 1 "b: w'p'"
plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
unset colorbox
#
# Plot sub-gridscale transport
#row = nextrow(row)
#set tmargin at screen tloc(row)
#set bmargin at screen bloc(row)
#set format x "%g"
#set xlabel "2011 UTC yearday" offset 0,xloff
#field = "sgs"
#set label 1 "d: sgs"
#plot datdir.abrev.field.".dat" binary matrix u 1:2:($3*1e6) w image not
#outdir.abrev.field.".tab" lc rgbcolor nullcolor lt 4 notitle
#
unset multiplot
#
#load datdir.abrev."profiles.plt"
#
