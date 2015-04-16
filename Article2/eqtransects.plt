load pltdir.prefix.'lontics.plt'
set yrange [-400:0]
set ytics out scale .5
set xrange [40:375]
set colorbox
set ylabel "Depth [m]"
set xlabel "Longitude [deg]"
set title "Equatorial MIMOC Transect"
mon(i) = 1+(i-1)%12
montxt(i) = \
i==1 ? "Jan" :\
i==2 ? "Feb" :\
i==3 ? "Mar" :\
i==4 ? "Apr" :\
i==5 ? "May" :\
i==6 ? "Jun" :\
i==7 ? "Jul" :\
i==8 ? "Aug" :\
i==9 ? "Sep" :\
i==10 ? "Oct" :\
i==11 ? "Nov" :\
"Dec"
set label 10 "Indian"   front offset 0,1 at  45,graph 0
set label 11 "Pacific"  front offset 0,1 at 180,graph 0
set label 12 "Atlantic" front offset 0,1 at 310,graph 0
do for [i=1:48] {
 set title montxt(mon(i))." Equatorial MIMOC Transect"
 #
 load pltdir."negpalnan.plt"
 set cbrange [34:36]
 set cblabel "Absolute Salinity [g/kg]"
 thedat = datdir.prefix.'_S'.sprintf('%02i',mon(i)).'.dat'
 theout = pngdir.'S'.sprintf('%04i',i).termsfx
 set output theout
 plot \
 thedat binary matrix w image not,\
 thedat binary matrix u ($1-360):2:3 w image not,\
 thedat binary matrix u ($1+360):2:3 w image not
 #
 load pltdir."sympalnan.plt"
 set autoscale cb 
 set cbrange [-.15:.15]
 set cblabel "Absolute Salinity Gradient [g/kg m]"
 thedat = datdir.prefix.'_dSdZ'.sprintf('%02i',mon(i)).'.dat'
 theout = pngdir.'dSdZ'.sprintf('%04i',i).termsfx
 set output theout
 plot \
 thedat binary matrix w image not,\
 thedat binary matrix u ($1-360):2:3 w image not,\
 thedat binary matrix u ($1+360):2:3 w image not
 #
 load pltdir."pospalnan.plt"
 set cbrange [10:35]
 set cblabel "Conservative Temperature [^oC]
 thedat = datdir.prefix.'_T'.sprintf('%02i',mon(i)).'.dat'
 theout = pngdir.'T'.sprintf('%04i',i).termsfx
 set output theout
 plot \
 thedat binary matrix w image not,\
 thedat binary matrix u ($1-360):2:3 w image not,\
 thedat binary matrix u ($1+360):2:3 w image not
 #
 load pltdir."pospalnan.plt"
 set autoscale cb
 set cbrange [0:.8]
 set cblabel "Conservative Temperature Gradient [^oC]
 thedat = datdir.prefix.'_dTdZ'.sprintf('%02i',mon(i)).'.dat'
 theout = pngdir.'dTdZ'.sprintf('%04i',i).termsfx
 set output theout
 plot \
 thedat binary matrix w image not,\
 thedat binary matrix u ($1-360):2:3 w image not,\
 thedat binary matrix u ($1+360):2:3 w image not
 #
 load pltdir."pospalnan.plt"
 set cbrange [0:25]
 set cblabel "Buoyancy Frequency [10^{-4}(rad/s)^2]"
 thedat = datdir.prefix.'_Nsq'.sprintf('%02i',mon(i)).'.dat'
 theout = pngdir.'Nsq'.sprintf('%04i',i).termsfx
 set output theout
 plot \
 thedat binary matrix u 1:2:($3*1e4)w image not,\
 thedat binary matrix u ($1-360):2:($3*1e4) w image not,\
 thedat binary matrix u ($1+360):2:($3*1e4) w image not
}
