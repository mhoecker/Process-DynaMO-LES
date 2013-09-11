function twocolor(x1,y1,z1,x2,y2,z2,outname,upperlabels,lowerlabels,term,tmp)
 if(nargin()<8)
  upperlabels = {"set xlabel 'x1'","set ylabel 'y1'","set cblabel 'z1'"};
 end%if
 if(nargin()<9)
  lowerlabels = {"set xlabel 'x2'","set ylabel 'y2'","set cblabel 'z2'"};
 end%if
 if(nargin()<10)
  [termtxt,termsfx] = termselect('png');
 else
  [termtxt,termsfx] = termselect(term);
 end%if
 if(nargin()<11)
  tmp = "/home/mhoecker/tmp/";
 end%if
 x1min = min(min(x1));
 x1max = max(max(x1));
 y1min = min(min(y1));
 y1max = max(max(y1));
 z1min = min(min(z1));
 z1max = max(max(z1));
 z1range = z1max-z1min;
 x2min = min(min(x2));
 x2max = max(max(x2));
 y2min = min(min(y2));
 y2max = max(max(y2));
 z2min = min(min(z2));
 z2max = max(max(z2));
 z2range = z2max-z2min;
 topname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".dat"];pause(.0006);
 botname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".dat"];pause(.0006);
 pltname = [tmp num2str(floor(now*3600*24*1000),"%011i") ".plt"];pause(.0006);
 binmatrix(x1,y1,z1,topname);
 binmatrix(x2,y2,z2,botname);
 pltid = fopen(pltname,'w');
 fprintf(pltid,"set term %s\n",termtxt)
 fprintf(pltid,"set output '%s%s'\n",outname,termsfx)
 fprintf(pltid,"set multiplot layout 2,1\n")
 fprintf(pltid,"set view map\n")
 fprintf(pltid,"set pm3d\n")
 fprintf(pltid,"unset surface\n")
# set limits for upper plot
 fprintf(pltid,"set xrange [%f:%f]\n",x1min,x1max)
 fprintf(pltid,"set yrange [%f:%f]\n",y1min,y1max)
 if(sign(z1max*z1min)==-1)
  fprintf(pltid,"set cbrange [%f:%f]\n",z1min,z1max)
  fprintf(pltid,"set palette defined (0 'blue', %f 'cyan', %f 'white', %f 'yellow',  1'red')\n",-.875*z1min/z1range,-z1min/z1range,(.125*z1max-z1min)/z1range)
 else
  fprintf(pltid,"set palette mode HSV\n")
  fprintf(pltid,"set palette functions (gray)*.8,1,1\n")
 end%if
 for i=1:length(upperlabels)
  fprintf(pltid,'%s\n',upperlabels{i});
 end%for
 fprintf(pltid,"splot '%s' binary matrix not\n",topname)
# set limits for upper plot
 fprintf(pltid,"set xrange [%f:%f]\n",x2min,x2max)
 fprintf(pltid,"set yrange [%f:%f]\n",y2min,y2max)
# set lower plot parameters
 if(sign(z2max*z2min)==-1)
  fprintf(pltid,"set cbrange [%f:%f]\n",z2min,z2max)
  fprintf(pltid,"set palette defined (0 'blue', %f 'cyan', %f 'white', %f 'yellow',  1'red')\n",-.875*z2min/z2range,-z2min/z2range,(.125*z2max-z2min)/z2range)
 else
  fprintf(pltid,"set palette mode HSV\n")
  fprintf(pltid,"set palette functions (gray)*.8,1,1\n")
  fprintf(pltid,"set cbrange [%f:%f]\n",z2min,z2max)
 end%if
 for i=1:length(lowerlabels)
  fprintf(pltid,'%s\n',lowerlabels{i});
 end%for
 fprintf(pltid,"splot '%s' binary matrix not\n",botname)
 fclose(pltid)
 unix(["gnuplot " pltname ])
 unix(["rm " topname]);
 unix(["rm " botname]);
 unix(["rm " pltname]);
end%function
