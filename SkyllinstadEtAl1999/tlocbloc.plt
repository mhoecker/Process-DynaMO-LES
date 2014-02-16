# given a number of figures calculate spacing for flush plots
# vertical spacing
tlocmax = .94
blocmin = .07
tloc(r) = tlocmax-(tlocmax-blocmin)*(r+0.0)/(rows)
bloc(r) = tloc(r+1)
vskip = tloc(0)-bloc(0)
nextrow(r) = (r+1)%rows
# Horizontal Spacing
rlocmax = .84
llocmin = .11
lloc(c) = llocmin+(rlocmax-llocmin)*(c+0.0)/(cols)
rloc(c) = lloc(c+1)
hskip = rloc(0)-lloc(0)
nextcol(c) = (c+1)%cols
set rmargin at screen rloc(0)
set lmargin at screen lloc(0)
#
# Common Ranges
set xrange[t0sim:tfsim]
set yrange [-2*dsim/3.0:0]
#
# Common label offsets
yloff = 2
xloff = 1
# How to use
set ylabel offset yloff,0
set xlabel offset 0,xloff
set cblabel offset 0,0
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
set ytics -7*dsim/8,dsim/4.0,-1*dsim/8
dxtic = .25
set xtics t0sim,dxtic,tfsim
