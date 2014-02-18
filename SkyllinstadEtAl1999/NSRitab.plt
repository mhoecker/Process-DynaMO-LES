# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
#
outroot = outdir.abrev
datroot = datdir.abrev
# Surface Ri is a 2-D field so no contours for you!
#
# Nsq
set table outroot."b.tab"
#splot datroot."b.dat" binary matrix
#
# Ssq
set table outroot."c.tab"
#splot datroot."c.dat" binary matrix
#
# Richardson #
# +1/4 contour
set cntrparam levels discrete .25
set table outroot."d.tab"
#splot datroot."d.dat" binary matrix
# zero contour
set cntrparam levels discrete 0
set table outroot."d0.tab"
#splot datroot."d.dat" binary matrix
# -1/4 contour
set cntrparam levels discrete -0.25
set table outroot."dm.tab"
#splot datroot."d.dat" binary matrix
#
# Density
set cntrparam levels incremental 1000,.05,1040
set table outroot."e.tab"
splot datroot."e.dat" binary matrix
#
#
