load termfile
Tmin = 26.5
Tmax = 30.20
Smin = 35.00
Smax = 35.54
UVmin = -0.9
UVmax = +0.9
set output outdir.abrev.termsfx
#
# Setup spacing
rows = 5
row = 0
cols = 2
col = 0
load scriptdir."tlocbloc.plt"
#
cbform = "%+04.2f"
set multiplot title "Profiles and Surface Forcings"
set style data lines
# Surface Observations
set format x ""
set format x2 ""
set ylabel "J_h (W/m^2)" offset yloff,0
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set autoscale y
set key l t
set ytics nomirror -900,300,900 offset ytoff,0
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:2 axis x2y1 notitle ls 1
#, datdir.abrev."ab.dat" binary format="%f%f%f%f%f"u 1:3
#
set ylabel ""
unset yrange
unset ytics
set format y ""
set format x ""
set format x2 ""
set y2range [-.1:.8]
set y2tics nomirror -0,.2,.6 offset -ytoff,0
set y2label "{/Symbol t} (Pa)" offset -yloff,0
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
plot datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:4 axes x1y2 title "{/Symbol t}_x" ls 2,\
datdir.abrev."JPtau.dat" binary format="%f%f%f%f%f"u 1:5 axes x1y1 title "{/Symbol t}_y" ls 3
unset x2tics
unset y2tics
unset y2range
unset y2label
unset x2label
#
# Profile Observations
load scriptdir."tlocbloc.plt"
load limfile
#
# Temperature
set cblabel "T (^oC)"
cbmin = Tmin
cbmax = Tmax
load outdir."pospalnan.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin),cbmax
set format cb cbform
# Observed
set ylabel "Z (m)"
set format y "%g"
set format x ""
unset colorbox
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."To.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x ""
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
row = nextrow(row)
plot datdir.abrev."Ts.dat" binary matrix w image notitle
unset colorbox
# Salinity
load outdir."negpalnan.plt"
set cblabel "S (psu)"
cbmin = Smin
cbmax = Smax
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin),cbmax
set format cb cbform
# Observed
unset colorbox
set ylabel "Z (m)"
set format y "%g"
set format x ""
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
plot datdir.abrev."So.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x ""
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,cbhig
row = nextrow(row)
plot datdir.abrev."Ss.dat" binary matrix w image notitle
unset colorbox
# U Velocity
set format cb cbform
set cblabel "u,v (m/s)"
cbmin = UVmin
cbmax = UVmax
load outdir."sympalnan.plt"
set cbrange [cbmin:cbmax]
set cbtics cbmin,(cbmax-cbmin)/2,cbmax; set cbtics add ("0" 0)
# Observed
unset colorbox
set ylabel "Z (m)"
set format y "%g"
set format x ""
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "u"
plot datdir.abrev."Uo.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x ""
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
plot datdir.abrev."Us.dat" binary matrix w image notitle
# V velocity
# Observed
unset colorbox
set ylabel "Z (m)"
set format y "%g"
set format x "%g"
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set ylabel "v"
set xlabel "Observed Fields"
plot datdir.abrev."Vo.dat" binary matrix w image notitle
# Simulated
set ylabel ""
set format y ""
set format x "%g"
col = nextcol(col)
set lmargin at screen lloc(col)
set rmargin at screen rloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col)+cbgap,bloc(row) size cbwid,1*vskip+cbhig
row = nextrow(row)
set xlabel "Simulated Fields"
plot datdir.abrev."Vs.dat" binary matrix w image notitle
unset colorbox
unset multiplot
