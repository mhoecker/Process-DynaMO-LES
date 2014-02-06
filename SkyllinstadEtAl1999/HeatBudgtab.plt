unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
set table outdir.abrev."a".".tab"
splot datdir.abrev."a.dat" binary matrix
set table outdir.abrev."b".".tab"
splot datdir.abrev."b.dat" binary matrix
unset contour
unset table

