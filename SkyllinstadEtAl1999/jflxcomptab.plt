# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
#
outroot = outdir.abrev
datroot = datdir.abrev
#
# Density deviation
set cntrparam levels incremental 20,20,1000
set table outroot."drhosz.tab"
splot datroot."drhosz.dat" binary matrix
#
# Mixed Layer Depth
# REF e-mail from Aurelie 01/31/2014 03:24
# 0.02 threshold from the avg density of 1-3 m!
#
set cntrparam levels discrete 20
set table outroot."MLD.tab"
splot datroot."drhosz.dat" binary matrix
#
#
