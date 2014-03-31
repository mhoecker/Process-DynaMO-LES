function [Fy,f,f0,nyq] = PSDplot(t,y,outname)
 N = length(t);
 maxy = max(abs(y));
 maxA = (maxy)^2;
 minA = maxA*1./N^4;
 Fy = fft(y)/N;
 f0 = ((N+1)/N)/abs(t(N)-t(1));
 f0 = f0;
 f = f0*(0:1:N-1);
 nyq = f0*floor((N+1)/2);
 ReFy = real(Fy);
 ImFy = imag(Fy);
 tmpdir = '/home/mhoecker/tmp/';
 tmpname = 'PSD';

 datid = fopen([tmpdir tmpname '.dat'],'w');
 fwrite(datid,[t; y; f; ReFy; ImFy],'float');
 fclose(datid);

 pltid = fopen([tmpdir tmpname '.plt'],'w');
 plt = 'set term png size 1024,768';

 fprintf(pltid,'%s\n',plt)
 plt = ["set output '" outname ".png'"];

 fprintf(pltid,'%s\n',plt)
 plt = "set multiplot layout 2,2";
 fprintf(pltid,'%s\n',plt)
 % Signal
 plt = "set yrange";
 fprintf(pltid,'%s [%f:%f]\n',plt,-1.1*maxy,1.1*maxy)

 plt = ['plot "' tmpdir tmpname '.dat" binary format="%float%float%float%float%float" u 1:2 w linespoints not'];
 fprintf(pltid,'%s\n',plt)
 % PSD
 plt = "set logscale";
 fprintf(pltid,'%s\n',plt)

 plt = "set xrange";
 fprintf(pltid,'%s [%g:%g]\n',plt,f0/2,nyq)

 plt = "set yrange";
 fprintf(pltid,'%s [%g:%g]\n',plt,minA,1.1*maxA)

 plt = ['plot "' tmpdir tmpname '.dat" binary format="%float%float%float%float%float" u 3:(4*($4**2+$5**2)) w linespoints not'];
 fprintf(pltid,'%s\n',plt)

 plt = "unset logscale";
 fprintf(pltid,'%s\n',plt)
 % Real
 plt = "set logscale x";
 fprintf(pltid,'%s\n',plt)

 plt = "set yrange";
 fprintf(pltid,'%s [%f:%f]\n',plt,-1.1*maxy,1.1*maxy)

 plt = ['plot "' tmpdir tmpname '.dat" binary format="%float%float%float%float%float" u 3:(2*$4) w linespoints not'];
 fprintf(pltid,'%s\n',plt)
 % Imaginary
 plt = "set yrange";
 fprintf(pltid,'%s [%f:%f]\n',plt,-1.1*maxy,1.1*maxy)

 plt = ['plot "' tmpdir tmpname '.dat" binary format="%float%float%float%float%float" u 3:(2*$5) w linespoints not'];
 fprintf(pltid,'%s\n',plt)

 plt = "unset multiplot";
 fprintf(pltid,'%s\n',plt)
 %
 fclose(pltid);
 %
 unix(["gnuplot " tmpdir tmpname ".plt" ]);
 #unix(["rm " tmpdir tmpname ".dat " tmpdir tmpname ".plt"]);
endfunction
