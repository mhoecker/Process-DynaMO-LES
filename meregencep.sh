# this script extracts the equatorial band from a directory of ncep files
ncrcat -d lat,-10.0,10.0 uwnd.????.nc uwnd.all.nc && ncrcat -d lat,-10.0,10.0 vwnd.????.nc uvwnd.all.nc && ncks -A uwnd.all.nc uvwnd.all.nc && rm uwnd.all.nc
