function [outname,termsfx] = pcolorContour(outname,term,x,y,z1,z2,tmpdir)
% pcolorCountour(outname,x,y,z1,z2)
% plots array z1 using  shading
% plots array z2 using contours
[termtxt,termsfx] = termselect(term);
if(nargin<7)
 tmpdir = outname;
end%if
% Save the data as gnuplot readable binaries
 binmatrix(x,y,z1,[tmpdir 'binmat1.dat'])
 binmatrix(x,y,z2,[tmpdir 'binmat2.dat'])
% Create the gnuplot script
 pltid = fopen([tmpdir 'pcolorContour.plt'],'w');
% Set the resolution
 fprintf(pltid,'set isosamples 250,250\n');
% Create a table of values for the pcolor plot
 fprintf(pltid,'set surface\n');
 fprintf(pltid,'set table "%s"\n',[tmpdir "tab1.dat"]);
 fprintf(pltid,'splot  "%s" binary\n',[tmpdir "binmat1.dat"]);
 fprintf(pltid,'unset table \n');
% Create a table of values for the contours
% later add functionality to highlight zero
% and distinguish positive from zegative contours
 fprintf(pltid,'set contour\n');
 fprintf(pltid,'set cntrparam levels auto 10\n');
 fprintf(pltid,'unset surface\n');
 fprintf(pltid,'set table "%s"\n',[tmpdir "tab2.dat"]);
 fprintf(pltid,'splot  "%s" binary\n',[tmpdir "binmat2.dat"]);
 fprintf(pltid,'unset table \n');
 fprintf(pltid,'unset contour\n');
% plot the two data sets
 fprintf(pltid,'set xrange [%f:%f]\n',min(x),max(x))
 fprintf(pltid,'set yrange [%f:%f]\n',min(y),max(y))
 fprintf(pltid,'#set xlabel "xlabel"\n')
 fprintf(pltid,'#set ylabel "ylabel"\n')
 fprintf(pltid,'#set cblabel "cblabel"\n')
 fprintf(pltid,'set term %s\n',termtxt);
 fprintf(pltid,'set palette mode HSV\n');
 fprintf(pltid,'set palette function (1-gray)*.8,1,1\n');
 fprintf(pltid,'set output "%s"\n',[outname termsfx]);
 fprintf(pltid,'plot "%s" w image notitle,\\\n',[tmpdir "tab1.dat"]);
 fprintf(pltid,'"%s" w lines lt 1 lw 2 lc rgb "#FFFFFF" notitle ,\\\n',[tmpdir "tab2.dat"]);
 fprintf(pltid,'"%s" w lines lt 1 lw 1 lc rgb "#000000"\n',[tmpdir "tab2.dat"]);
%
 fclose(pltid)
unix(["gnuplot " tmpdir "pcolorContour.plt"]);
