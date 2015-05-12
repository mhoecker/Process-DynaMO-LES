xytic = 128
set xrange [0:2*xytic]
set yrange [0:2*xytic]
set zrange [-60:0]
set ztics out 60
set xtics xytic offset 0,0
set ytics xytic offset .5,-.5
set xlabel "x [m]"
set xlabel rotate parallel
set xlabel offset -1,-1
set ylabel "y [m]"
set ylabel rotate parallel
set ylabel offset 1,-1
set zlabel "z [m]"
set zlabel rotate parallel
unset zeroaxis
unset mxtics
unset mytics
set border 1+2+4+8+16+32+64+128+256+512+1024+2048
set view 60,30
set lmargin at screen .25
set rmargin at screen .8
set colorbox user horizontal origin .1,.2 size .8,.025
set parametric
do for [ti=2:2]{
#
name = "w"
load pltdir."sympal.plt"
set cbrange [-.08:.08]
unset logscale cb
unset mcbtics
set cbtics .08
set format cb "%+4.2f"
set cblabel "w [m/s]"
set xyplane 0
set view equal xyz
set output pngdir.name.'t_'.ti.'.png'
c(w) = abs(w)>.8 ? (1+sgn(w))/2 : (w+.08)/.16
R(w) = 255*r(c(w))
G(w) = 255*g(c(w))
B(w) = 255*b(c(w))
A(w) = abs(w)/.08 > .1 ? 255 : 0
a(x,xmax) = x>xmax ? 0 : 1
splot \
datdir.name.'yz010'.ti.'.dat' u (000):1:2:3 binary matrix w image not,\
datdir.name.'xz030'.ti.'.dat' u 1:(256):2:3 binary matrix w image not,\
datdir.name.'xy010'.ti.'.dat' u 1:2:(-5):3 every :::255 binary matrix w image not,\
datdir.name.'xz020'.ti.'.dat' u 1:(128):2:3 binary matrix w image not,\
datdir.name.'xz010'.ti.'.dat' u 1:(000):2:3 binary matrix w image not,\
datdir.name.'yz030'.ti.'.dat' u (256):1:2:3 every ::255 binary matrix w image not

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
