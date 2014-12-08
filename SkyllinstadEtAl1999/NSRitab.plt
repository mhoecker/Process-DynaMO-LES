# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
#
outroot = datdir.abrev
datroot = datdir.abrev
# Density
set cntrparam levels incremental 1000,.1,1040
set table outroot."e.tab"
splot datroot."e.dat" binary matrix
#
#
