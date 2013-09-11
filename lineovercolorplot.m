function lineovercolorplot(x,y,z,c,outname,upperlabels,lowerlabels,term,tmp)
# Assumes data have a common x-axis
# x,y,z are 1-D arrays
# x,y are of the same length (N)
# z may be of a different length (M)
# c is a 2-D Array ( M x N )
#
# Bad ascii version of the output
#
# y|   ++    ++
# y|  +  +  +  +
# y| +    ++    ++
# ----------------
# z| ccccccccccccc
# z| ccccccccccccc
# z| ccccccccccccc
# z| ccccccccccccc
# ----------------
# xxxxxxxxxxxxxxxx
N = length(x);
M = length(z);
if(length(y)!=N)
 error("x-axis and linear data (y) not of same length");
end%if
if(size(c)!=[M,N])
 error("2-D data array is mishapen");
end%if
if(nargin()<9)
 tmp = "/home/mhoecker/tmp/";
end%if
if(nargin()<8)
 [termtxt,termsfx] = termselect('png');
else
 [termtxt,termsfx] = termselect(term);
end%if
if(nargin()<7)
 lowerlabels = {"set xlabel 'x'","set ylabel 'z'","set cblabel 'c'"};
end%if
if(nargin()<6)
 upperlabels = {"set ylabel 'y'"};
end%if
xmin = min(min(x));
xmax = max(max(x));
cmin = min(min(c));
cmax = max(max(c));
crange = cmax-cmin;
xyname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".dat"];pause(.0006);
arrayform = binarray(x,y,xyname);
xzcname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".dat"];pause(.0006);
binmatrix(x,z,c,xzcname)
pltname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".plt"];pause(.0006);
pltid = fopen(pltname,'w');
fprintf(pltid,"set term %s\n",termtxt)
fprintf(pltid,"set output '%s%s'\n",outname,termsfx)
fprintf(pltid,"set multiplot\n")
# set margin locations for upper plot
fprintf(pltid,"set offset 0,0,0, graph .1\n")
fprintf(pltid,"set lmargin at screen .2\n")
fprintf(pltid,"set rmargin at screen .75\n")
fprintf(pltid,"set tmargin at screen .9\n")
fprintf(pltid,"set bmargin at screen .6\n")
fprintf(pltid,"set ytics rangelimited offset char .5,0\n")
fprintf(pltid,"set xrange [%f:%f]\n",xmin,xmax)
fprintf(pltid,"unset xtics\n")
	for i=1:length(upperlabels)
		fprintf(pltid,'%s\n',upperlabels{i});
	endfor
fprintf(pltid,"plot '%s' %s w lines lc -1 not\n",xyname,arrayform)
# set lower plot parameters
fprintf(pltid,"set view map\n")
fprintf(pltid,"set pm3d\n")
if(sign(cmax*cmin)==1)
 fprintf(pltid,"%s",paltext("hue"))
else
 fprintf(pltid,"set cbrange [%f:%f]\n",cmin,cmax)
 fprintf(pltid,"%s",paltext("pm",cmin,cmax))
end%if
fprintf(pltid,"set xtics out offset 0,char .5\n")
fprintf(pltid,"set cbtics offset char -0.75,0\n")
fprintf(pltid,"unset surface\n")
# set margin locations for lower plot
fprintf(pltid,"set tmargin at screen .6\n")
fprintf(pltid,"set bmargin at screen .2\n")
	for i=1:length(lowerlabels)
		fprintf(pltid,'%s\n',lowerlabels{i});
	endfor
fprintf(pltid,"splot '%s' binary matrix not\n",xzcname)
fclose(pltid)
unix(["gnuplot " pltname ])
unix(["rm " xyname]);
unix(["rm " xzcname]);
unix(["rm " pltname]);
end %function
