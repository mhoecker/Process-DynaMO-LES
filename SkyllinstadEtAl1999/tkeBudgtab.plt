reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
abrev = "tkeBudg"
# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
# tke
set table outdir.abrev."a".".tab"
splot datdir.abrev."a.dat" binary matrix
set table outdir.abrev."adt".".tab"
splot datdir.abrev."adt.dat" binary matrix
#
set table outdir.abrev."b".".tab"
splot datdir.abrev."b.dat" binary matrix
set table outdir.abrev."bR".".tab"
splot datdir.abrev."bR.dat" binary matrix
#
set table outdir.abrev."c".".tab"
splot datdir.abrev."c.dat" binary matrix
set table outdir.abrev."c".".tab"
splot datdir.abrev."c.dat" binary matrix
#
set table outdir.abrev."d".".tab"
splot datdir.abrev."d.dat" binary matrix
set table outdir.abrev."dR".".tab"
splot datdir.abrev."dR.dat" binary matrix
#
set table outdir.abrev."e".".tab"
splot datdir.abrev."e.dat" binary matrix
set table outdir.abrev."eR".".tab"
splot datdir.abrev."eR.dat" binary matrix
#
set table outdir.abrev."f".".tab"
splot datdir.abrev."f.dat" binary matrix
set table outdir.abrev."fR".".tab"
splot datdir.abrev."fR.dat" binary matrix
#
set table outdir.abrev."g".".tab"
splot datdir.abrev."g.dat" binary matrix
set table outdir.abrev."gR".".tab"
splot datdir.abrev."gR.dat" binary matrix
#
set table outdir.abrev."h".".tab"
splot datdir.abrev."h.dat" binary matrix
set table outdir.abrev."hR".".tab"
splot datdir.abrev."hR.dat" binary matrix
#
set table outdir.abrev."i".".tab"
splot datdir.abrev."i.dat" binary matrix
set table outdir.abrev."iR".".tab"
splot datdir.abrev."iR.dat" binary matrix
#
set table outdir.abrev."j".".tab"
splot datdir.abrev."j.dat" binary matrix
set table outdir.abrev."jR".".tab"
splot datdir.abrev."jR.dat" binary matrix
#
unset contour
unset table
#
