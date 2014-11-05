#richistogram.plt
load termfile
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
set cbtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0, "+{\274}" .5, "+{/Symbol \245}" 1)
set cbrange [-1:1]
plot outdir.'phiSPrank.dat' binary matrix u 1:2:(($3+abs($3))/2) w image
#
set title "Ri Ranked by Shear Production"
set output outdir.'phiSPflat.png'
set xrange [.8:1]
unset logscale cb
set autoscale y
set multiplot layout 2,1
set logscale y
set ytics auto
set format y "10^{%+T}"
set style data points
plot outdir.'flat.dat' binary format="%f%f%f%f%f%f%f" u 1:6 lc -1
unset logscale y
set yrange [0:1]
set format y "%g"
set ytics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
plot outdir.'flat.dat' binary format="%f%f%f%f%f%f%f" u 1:7 lc -1
unset multiplot
#
set autoscale
unset logscale
set xtics auto
set ytics auto
set xrange [0:1]
set format x "%g"
set xtics ("-{/Symbol \245}" -1, "-{\274}" -.5, 0 "0", "+{\274}" .5, "+{/Symbol \245}" 1)
set output outdir.'Hphi.png'
plot outdir."Hphi.dat" binary format="%f%f"
#
set autoscale
unset logscale
set logscale x
set xrange [2**(-4):2**(+6)]
set xtics 4
set ytics auto
set output outdir.'HRi.png'
plot outdir."HRi.dat" binary format="%f%f"
