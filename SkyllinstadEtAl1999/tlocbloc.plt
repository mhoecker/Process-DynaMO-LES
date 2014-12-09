# given a number of figures calculate spacing for flush plots
# vertical spacing
tlocmax = .93
blocmin = .07
tloc(r) = tlocmax-(tlocmax-blocmin)*(r+0.0)/(rows)
vgap = .04
bloc(r) = tloc(r+1)+vgap
if(exists('rows')) vskip = tloc(0)-tloc(1)
if(exists('rows')) cbhig = vskip-vgap
nextrow(r) = (r+1)%rows
# Horizontal Spacing
rlocmax = .78
cbwid = .1*(1-rlocmax)
cbgap = .5*cbwid
llocmin = .15
lloc(c) = llocmin+(rlocmax-llocmin)*(c+0.0)/(cols)
rloc(c) = lloc(c+1)
if(exists('cols')) hskip = rloc(0)-lloc(0)
nextcol(c) = (c+1)%cols
if(exists('cols')) set rmargin at screen rloc(0)
if(!exists('cols')) set rmargin at screen rlocmax
if(exists('cols')) set lmargin at screen lloc(0)
if(!exists('cols')) set lmargin at screen llocmin
#
#
# Common label offsets
yloff = 2
xloff = 1.25
# How to use
#set ylabel offset yloff,0
#set xlabel offset 0,xloff
#set cblabel offset 0,0
#
# Common tic offsets
xtoff = .5
ytoff = .9
# set common key sample length
set key samplen 1
# How to use
#set xtics out nomirror offset 0,xtoff
#set xzeroaxis ls 2 lw 2 lc rgbcolor "grey80"
#set ytics out nomirror offset ytoff,0
#set cbtics offset -ytoff,0
