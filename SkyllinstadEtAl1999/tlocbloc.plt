# given a number of figures calculate the vertical spacing
tlocmax = .95
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
set ylabel offset 1.25,0
set xlabel offset 0,1
#
# Common tic offsets
set xtic offset 0,.5
set ytic offset .9,0
set cbtics offset -.5,0
#
# common tics
set ytics -dsim*3.5/8,dsim/8.0,-.5*dsim/8
dxtic = .25
set xtics t0sim,dxtic,tfsim
