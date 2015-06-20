# Setup spacing
rows = 4
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
xytic = 128
do for [ti=2:2]{
#
name = "w"
load pltdir."sympal.plt"
set cbrange [-.08:.08]
unset logscale cb
unset mcbtics
set cbtics .08 offset 0,.5
set format cb "%+4.2f"
set cblabel "w [m/s]" offset 0,1.5
set xyplane 0
set view equal xyz
set output pngdir.name.'t_'.ti.'.png'
set multiplot
row=0
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set y2label "tke [mJ/m^3]"
set ylabel "{/Symbol t} [Pa]"
set yrange [0:.6]
set ytics  0,.3,.6
set y2range [0:.9]
set y2tics 0,.4,.8
set x2tics (328.67) offset 0,-.5
unset xzeroaxis
set key horizontal at graph 1,0 bottom Right
set parametric
set label 1 "a"
plot \
datdir."tkeBudgtkezavg.dat" binary format="%f%f" u 1:($2*1e3) ls 11 axis x1y2 t "tke",\
datdir."ObsSurfEpsJhPrecipTxTyUk.dat" binary format="%f%f%f%f%f%f%f" u 1:(sqrt($4**2+$5**2)) ls 12 t "|{/Symbol t}|",\
328.67,t lt 0 not

row=1
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
#plot t,t
row=2
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
#plot t,t
row=3
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
#plot t,t
set label 1 "b" at screen lloc(col), tloc(row-1)
set parametric
set xrange [0:2*xytic]
set yrange [0:2*xytic]
set zrange [-60:0]
set ztics out 60 offset 2,0
set xtics xytic offset 0,0
set ytics xytic offset .5,0
set xlabel "x [m]"
set xlabel rotate parallel
set xlabel offset -2,0
set ylabel "y [m]"
set ylabel rotate parallel
set ylabel offset 1.5,0
set zlabel "z [m]" offset 4,0
set zlabel rotate parallel
unset zeroaxis
unset mxtics
unset mytics
set border 1+2+4+8+16+32+64+128+256+512+1024+2048
set view 60,30
set colorbox user horizontal origin lloc(col)/2,bloc(row) size .5-lloc(col),cbwid
set tmargin at screen tloc(row-2)
set bmargin at screen bloc(row)
splot \
datdir.name.'yz010'.ti.'.dat' u (000):1:2:3 binary matrix w image not,\
datdir.name.'xz030'.ti.'.dat' u 1:(256):2:3 binary matrix w image not,\
datdir.name.'xy010'.ti.'.dat' u 1:2:(-5):3 every :::255 binary matrix w image not,\
datdir.name.'xz020'.ti.'.dat' u 1:(128):2:3 binary matrix w image not,\
datdir.name.'xz010'.ti.'.dat' u 1:(000):2:3 binary matrix w image not,\
datdir.name.'yz030'.ti.'.dat' u (256):1:2:3 every ::255 binary matrix w image not
unset multiplot
#
#name = "tke"
#load pltdir."pospal.plt"
#set cbrange [.00025:.4]
#set logscale cb
#unset mcbtics
#set cbtics 10
#set format cb "10^{%T}"
#set cblabel "tke [J/kg]"
#set xyplane 0
#set ztics (-2,-4,-8,-32)
#set view equal
#set view 60,30
#set output pngdir.name.'t_'.ti.'.png'
#splot for [zi=1:5] \
#datdir.name.'0'.zi.'0'.ti.'.dat' binary matrix u 1:2:(-2**zi):3 w image not
#
#name = "p"
#load pltdir."sympal.plt"
#set cbrange [-.01:.01]
#unset logscale cb
#unset mcbtics
#set format cb "%+5.2f"
#set cbtics .01;
#set cblabel "P' [Pa]"
#set xyplane 0
#set ztics (-2,-4,-8,-32)
#set view equal
#set view 60,30
#set output pngdir.name.'t_'.ti.'.png'
#splot for [zi=1:5] \
#datdir.name.'0'.zi.'0'.ti.'.dat' binary matrix w image not
}
