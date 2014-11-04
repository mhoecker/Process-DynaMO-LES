#richistogram.plt
load termfile
set output outdir.'phirank.png'
set xrange [0:1]
set cbrange [-1:1]
plot outdir.'phirank.dat' binary matrix w image
