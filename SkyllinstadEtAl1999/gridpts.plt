unset tics
unset key
set view equal
set view 60,30,1.19,1.19
set xyplane 0
set border 2**12-1
set xrange [-1:1]
set yrange [-1:1]
set zrange [-1:1]
set xlabel "x"
set ylabel "y"
set zlabel "z"
rgb(r,g,b) = int(b*255)+int(g*255*256)+int(r*255*256*256)
set term pdfcairo enhanced mono size 9in,6in font "Helvetica,36"
set output "gridpts.pdf"
splot 'gridpts.dat' u 1:2:3 w linespoints lc rgbcolor "gray" pt 7 ps 5 lw 4, 'gridpts.dat' u 1:2:3:7 w labels
set term wxt
