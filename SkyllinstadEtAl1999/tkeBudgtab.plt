# Make table for countours
unset pm3d
unset surface
set style data lines
set contour
set cntrparam levels discrete 0
# tke
field = "tke"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
#
field = "dtkedt"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "dwpidz"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "wpi"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "dwtkedz"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "wtke"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "dsgsdz"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "sgs"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "bw"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "uudUdz"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "uudSdz"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
field = "diss"
set table outdir.abrev.field.".tab"
splot datdir.abrev.field.".dat" binary matrix
set table outdir.abrev.field."R".".tab"
splot datdir.abrev.field."R.dat" binary matrix
#
unset contour
unset table
#
