set output outdir.abrev.termsfx
set style data lines
# Setup vertical spacing
rows = 3
row = 0
cols = 1
col = 0
load scriptdir."tlocbloc.plt"
#
load outdir."sympal.plt"
#
set multiplot title "Surface Flux Comparison"
#
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
row = nextrow(row)
Jmax = 800
Jmin = -400
set yrange [Jmin:Jmax]
set ytics auto nomirror
set y2tics auto nomirror
set autoscale y2
set ylabel "W/m^2"
set y2label "mm/hr"
cbform = "%+03.0f"
set autoscale cb
set format x ""
plot \
datdir.abrev."surf.dat" binary format="%float%float%float%float%float%float" u 1:2 lw 2 t "hf_{top}",\
datdir.abrev."surf.dat" binary format="%float%float%float%float%float%float" u 1:3 t "lhf_{top}",\
datdir.abrev."surf.dat" binary format="%float%float%float%float%float%float" u 1:4 t "q",\
datdir.abrev."surf.dat" binary format="%float%float%float%float%float%float" u 1:5 t "swf_{top}",\
datdir.abrev."surf.dat" binary format="%float%float%float%float%float%float" u 1:6 axes x1y2 t "rain"
#
unset y2tics
unset y2label
load scriptdir."tlocbloc.plt"
#
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set colorbox user origin rloc(col),bloc(row)+.1*vskip size 0.1*(1.0-rloc(col)),.8*(vskip)
row = nextrow(row)
drhomax = 800
cbform = "%+03.0f"
#set autoscale cb
set ylabel "Z (m)"
set cbrange [0:drhomax]
set cbtics 0,(drhomax)/palcolors,drhomax
set format cb cbform
set cblabel "{/Symbol Dr} (g/m^3)"
set format x ""
plot datdir.abrev."drhosz.tab" lc pal notitle
#
set format x "%g"
set ylabel "Z (m)"
set tmargin at screen tloc(row)
set bmargin at screen bloc(row)
set format cb cbform
set cblabel "Honecker Number"
set cbrange [-1:1]
set cbtics -1,(2.0)/palcolors,1
set cbtics add ("+1" .5, "-1" -.5, "0" 0, "+{/Symbol \245}" 1, "-{/Symbol \245}" -1, "-3" -.75, "+3" .75, "-1/3" -.25, "+1/3" .25)
set colorbox user origin rloc(col),bloc(row)+.1*vskip size 0.1*(1.0-rloc(col)),0.8*vskip
plot datdir.abrev."Ho.dat" binary matrix u 1:2:($3/(abs($3)+1)) w image not, datdir.abrev."MLD.tab" lc -1 notitle
#
unset multiplot
