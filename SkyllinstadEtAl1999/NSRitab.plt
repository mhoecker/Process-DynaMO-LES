# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
#
outroot = datdir.abrev
datroot = datdir.abrev
# Density
set yrange [-dsim:0]
set cntrparam levels incremental 1020,.1,1040
set table outroot."e.tab"
splot datroot."e.dat" binary matrix
#
# common interval for (S/2)^2 and N^2
set cntrparam levels incremental -4e-4,4e-5,4e-4
# Shear
set table outroot."c.tab"
splot datroot."c.dat" binary matrix u 1:2:($3/4)
#
# Stratification
set table outroot."b.tab"
splot datroot."b.dat" binary matrix
#
