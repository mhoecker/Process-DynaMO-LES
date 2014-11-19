#richistogram.plt
load termfile
# Setup spacing
rows = 1
cols = 1
col = 0
row = 0
#
load scriptdir."tlocbloc.plt"
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
#
set xrange [0:1]
set xtics .1
set colorbox
set encoding iso_8859_1
unset key
#
set output outdir.'phirank.png'
set palette maxcolors 12
set title "Ri"
set cbtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0, "+{\274}" .5, "+{/Symbol \245}" 1)
set cbrange [-1:1]
plot outdir.'phirank.dat' binary matrix w image
#
load outdir."pospal.plt"
set output outdir.'Riirank.png'
set cbtics auto
set autoscale cb
set logscale cb
set format cb "10^{%+T}"
plot outdir.'Rirank.dat' binary matrix w image
#
load outdir."negpal.plt"
set title "Shear Squared"
set output outdir.'Ssqrank.png'
set cbtics auto
set autoscale cb
set logscale cb
plot outdir.'Ssqrank.dat' binary matrix w image
#
load outdir."negpal.plt"
set title "Buoyancy Frequency Squared"
set output outdir.'Nsqrank.png'
set cbtics auto
set autoscale cb
set logscale cb
plot outdir.'Nsqrank.dat' binary matrix w image
#
load outdir."pospal.plt"
set palette maxcolors 11
set title "Shear Production"
set output outdir.'SPrank.png'
set cbtics auto
set logscale cb
set cbrange [1e-8:1e-4]
plot outdir.'SPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
#
load outdir."pospal.plt"
set palette maxcolors 11
set title "Ri Ranked by Shear Production"
set output outdir.'RiSPrank.png'
set cbtics auto
set autoscale cb
set logscale cb
plot outdir.'RiSPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
#
load outdir."sympal.plt"
set palette maxcolors 11
set title "Ri Ranked by Shear Production"
set output outdir.'phiSPrank.png'
unset logscale cb
set format cb "%g"
set cbtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
set cbrange [-1:1]
plot outdir.'phiSPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
#
load outdir."pospal.plt"
set autoscale
unset logscale
set xtics auto out mirror
set ytics auto out mirror
set xrange [0:1]
set xlabel "Ri"
set ylabel "SP percentile"
set yrange [0:1]
set logscale cb
set cbrange [10**(-3):1]
set cbtics 10
set format cb "10^{%T}"
set format x "%g"
set xtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
set xtics out mirror
set output outdir.'Hphi.png'
plot outdir."Hphi.dat" binary matrix w image
#
load outdir."pospal.plt"
unset logscale x
set xrange [-5:7]
set xtics 2
set xtics out mirror
set xlabel "log_2(Ri)"
set output outdir.'HRi.png'
plot outdir."HLRi.dat" binary matrix w image
#
load outdir."pospal.plt"
set title "Shear Production with percentiles"
set autoscale
set xtics auto
set ytics auto
set ylabel "Z (m)"
set xlabel "time (hr)"
set cbrange [1e-12:1e-4]
set xrange [0:30]
set yrange [-80:0]
set output outdir.'SP.png'
set key
set key samplen 1
set key spacing 1.05
set key b l
plot outdir."SP.dat" binary matrix w image not,\
outdir."SPcntr099.dat" w lines lc rgbcolor "#FFFFFF" title "99%",\
outdir."SPcntr095.dat" w lines lc rgbcolor "#CCCCCC" title "95%",\
outdir."SPcntr090.dat" w lines lc rgbcolor "#999999" title "90%",\
outdir."SPcntr080.dat" w lines lc rgbcolor "#666666" title "80%",\
outdir."SPcntr070.dat" w lines lc rgbcolor "#333333" title "70%",\
outdir."SPcntr060.dat" w lines lc rgbcolor "#000000" title "60%",\
#
# Setup spacing
rows = 2
cols = 1
col = 0
row = 0
#
load scriptdir."tlocbloc.plt"
set output outdir.'phiSPflat.png'
set xrange [0:1]
unset logscale cb
set autoscale y
set multiplot title "Ri Ranked by Shear Production"
set rmargin at screen rloc(col)
set lmargin at screen lloc(col)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set logscale y
set ytics auto
unset xlabel
set format x ""
set format cb "%g"
set style data points
plot outdir.'flat.dat' binary format="%f%f%f%f%f%f%f" u 1:6 lc -1
#
row = nextrow(row)
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
unset logscale y
set xlabel "Percentile"
set format x "%g"
set yrange [0:1]
set format y "%g"
set ytics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
plot outdir.'flat.dat' binary format="%f%f%f%f%f%f%f" u 1:7 lc -1
unset multiplot
