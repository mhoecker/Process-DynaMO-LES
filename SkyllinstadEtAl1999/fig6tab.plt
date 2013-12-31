reset
load "/home/mhoecker/work/Dynamo/Documents/EnergyBudget/Skyllinstad1999copy/limits.plt"
# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
# tke
set table outdir."fig6a".".tab"
splot datdir."fig6a.dat" binary matrix
set table outdir."fig6adt".".tab"
splot datdir."fig6adt.dat" binary matrix
#
set table outdir."fig6b".".tab"
splot datdir."fig6b.dat" binary matrix
set table outdir."fig6bR".".tab"
splot datdir."fig6bR.dat" binary matrix
#
set table outdir."fig6c".".tab"
splot datdir."fig6c.dat" binary matrix
set table outdir."fig6c".".tab"
splot datdir."fig6c.dat" binary matrix
#
set table outdir."fig6d".".tab"
splot datdir."fig6d.dat" binary matrix
set table outdir."fig6dR".".tab"
splot datdir."fig6dR.dat" binary matrix
#
set table outdir."fig6e".".tab"
splot datdir."fig6e.dat" binary matrix
set table outdir."fig6eR".".tab"
splot datdir."fig6eR.dat" binary matrix
#
set table outdir."fig6f".".tab"
splot datdir."fig6f.dat" binary matrix
set table outdir."fig6fR".".tab"
splot datdir."fig6fR.dat" binary matrix
#
set table outdir."fig6g".".tab"
splot datdir."fig6g.dat" binary matrix
set table outdir."fig6gR".".tab"
splot datdir."fig6gR.dat" binary matrix
#
set table outdir."fig6h".".tab"
splot datdir."fig6h.dat" binary matrix
set table outdir."fig6hR".".tab"
splot datdir."fig6hR.dat" binary matrix
#
set table outdir."fig6i".".tab"
splot datdir."fig6i.dat" binary matrix
set table outdir."fig6iR".".tab"
splot datdir."fig6iR.dat" binary matrix
#
set table outdir."fig6j".".tab"
splot datdir."fig6j.dat" binary matrix
set table outdir."fig6jR".".tab"
splot datdir."fig6jR.dat" binary matrix
#
unset contour
unset table
#
