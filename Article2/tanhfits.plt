DYNAMOdir = "/home/mhoecker/work/Dynamo"
datdir    = DYNAMOdir."/plots/MIMOC/dat"
pngdir    = DYNAMOdir."/plots/MIMOC/png"
month(i) = ((1+(i-1)%12)<10) ? "0".(1+(i-1)%12) : "".(1+(i-1)%12)
monthtxt(i) = (i%12==0) ? "Dec" : ( (i%12==1) ? "Jan" : ( (i%12==2) ? "Feb" : ((i%12==3) ? "Mar" : ((i%12==4) ? "Apr" : ( (i%12==5) ? "May" : ( (i%12==6) ? "Jun" : ( (i%12==7) ? "Jul" : ( (i%12==8) ? "Aug" : ( (i%12==9) ? "Sep" : ( (i%12==10) ? "Oct" : ( (i%12==11) ? "Nov" : ( "else"))))))))))))
pad2(i)  = (i<10) ? "0".i : "".i
set xrange [40:380]
set xtics out 30,30,390 nomirror
set key at 300,graph 1.1 center samplen .1
set label 10 "Indian"   front offset 0,-1 at  65,graph 0
set label 11 "Pacific"  front offset 0,-1 at 185,graph 0
set label 12 "Atlantic" front offset 0,-1 at 335,graph 0
set style data lines
set style line 1 lw 3 lc -1
set style line 2 lw 3 lc "grey50"
set style fill solid
set term png size 1280,768
do for [i=1:12]{
indata = datdir."/tanhfitsTfitparams".month(i).".dat"
outpng = pngdir."/tanhfitsTfitparams".pad2(i).".png"
set output outpng
set multiplot layout 4,1 title "Temperature ".monthtxt(i)
set yrange [4:14]
set format x ""
unset title
plot \
 indata binary format="%f%f%f%f%f%f" u 1:2 ls 1 title "Amplitude",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):2 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):2 ls 1 notitle
set yrange [-250:0]
plot \
 indata binary format="%f%f%f%f%f%f" u 1:3 ls 1 title "Depth",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):3 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):3 ls 1 notitle
set yrange [0:160]
plot \
 indata binary format="%f%f%f%f%f%f" u 1:4 ls 1 title "Width",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):4 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):4 ls 1 notitle
set yrange [17:26]
set format x "%g"
plot \
 indata binary format="%f%f%f%f%f%f" u 1:5 ls 1 title "Mean",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):5 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):5 ls 1 notitle
unset multiplot
print outpng
indata = datdir."/tanhfitsSfitparams".month(i).".dat"
outpng = pngdir."/tanhfitsSfitparams".pad2(i).".png"
set output outpng
set autoscale y
set format x ""
set multiplot layout 4,1 title "Salinity ".monthtxt(i)
set autoscale y
set yrange [-1.2:0.8]
unset title
plot \
 indata binary format="%f%f%f%f%f%f" u 1:2 ls 1 title "Amplitude",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):2 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):2 ls 1 notitle
set yrange [-250:0]
plot \
 indata binary format="%f%f%f%f%f%f" u 1:3 ls 1 title "Depth",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):3 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):3 ls 1 notitle
set yrange [0:160]
plot \
 indata binary format="%f%f%f%f%f%f" u 1:4 ls 1 title "Width",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):4 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):4 ls 1 notitle
set yrange [34:36]
set format x "%g"
plot \
 indata binary format="%f%f%f%f%f%f" u 1:5 ls 1 title "Mean",\
 indata binary format="%f%f%f%f%f%f" u ($1-360):5 ls 1 notitle,\
 indata binary format="%f%f%f%f%f%f" u ($1+360):5 ls 1 notitle
unset multiplot
print outpng
indatT = datdir."/tanhfitsTfitparams".month(i).".dat"
indatS = datdir."/tanhfitsSfitparams".month(i).".dat"
outpng = pngdir."/tanhfitsT-Sfitparams".pad2(i).".png"
set output outpng
unset y2tics
set x2zeroaxis
set ytics nomirror
set multiplot layout 2,1 title "Equatorial Thermo- & Halo-cline Parameters ".monthtxt(i)
set yrange [-0.7:3.1]
set format x ""
set title "Amplitude (g/kg)"
plot \
 indatT binary format="%f%f%f%f%f%f" u 1:6        ls 1 title "Temperature",\
 indatT binary format="%f%f%f%f%f%f" u ($1-360):6 ls 1 notitle,\
 indatT binary format="%f%f%f%f%f%f" u ($1+360):6 ls 1 notitle,\
 indatS binary format="%f%f%f%f%f%f" u 1:6        ls 2 title "Salinity",\
 indatS binary format="%f%f%f%f%f%f" u ($1-360):6 ls 2 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1+360):6 ls 2 notitle
set yrange [-340:0]
set ytics mirror
unset y2tics
unset x2zeroaxis
set title "Depth (m)"
set format x "%g"
plot \
 indatT binary format="%f%f%f%f%f%f" u 1:($3+$4):($3-$4)        w filledcurves lc -1 notitle,\
 indatT binary format="%f%f%f%f%f%f" u ($1-360):($3+$4):($3-$4) w filledcurves lc -1 notitle,\
 indatT binary format="%f%f%f%f%f%f" u ($1+360):($3+$4):($3-$4) w filledcurves lc -1 notitle,\
 indatS binary format="%f%f%f%f%f%f" u 1:($3+$4)        ls 2 notitle,\
 indatS binary format="%f%f%f%f%f%f" u 1:($3)           ls 2 lw 4 notitle,\
 indatS binary format="%f%f%f%f%f%f" u 1:($3-$4)        ls 2 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1-360):($3+$4) ls 2 lw 2 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1-360):3       ls 2 lw 4 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1-360):($3+$4) ls 2 lw 2 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1+360):($3+$4) ls 2 lw 2 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1+360):3       ls 2 lw 4 notitle,\
 indatS binary format="%f%f%f%f%f%f" u ($1+360):($3-$4) ls 2 lw 2 notitle
unset multiplot
}

