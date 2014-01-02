# given a number of figures calculate the vertical spacing
tlocmax = .925
blocmin = .075
tloc(r) = tlocmax-(tlocmax-blocmin)*(r+0.0)/(rows)
bloc(r) = tloc(r+1)
vskip = tloc(0)-bloc(0)
nextrow(r) = (r+1)%rows
# Common margin locations
rloc = .825
mloc = .5
lloc = .125
set rmargin at screen rloc
set lmargin at screen lloc
#
# Common Ranges
set xrange[t0sim:tfsim]
set yrange [-dsim/2:0]
#
# Common label offsets
yloff = 1.25
xloff = 1
# How to use
set ylabel offset yloff,0
set xlabel offset 0,xloff
set cblabel offset -yloff,0
#set y2label offset -yloff,0
#set x2label offset 0,-xloff
#
# Common tic offsets
xtoff = .5
ytoff = .9
# How to use
set xtics offset 0,xtoff
set ytics offset ytoff,0
set cbtics offset -ytoff,0
#set x2tics offset 0,-xtoff
#set y2tics offset -ytoff,0
#
#
# common tics
set ytics -dsim*3.5/8,dsim/8.0,-.5*dsim/8
dxtic = .25
set xtics t0sim,dxtic,tfsim
