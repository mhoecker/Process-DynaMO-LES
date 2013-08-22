function slbmovie(dagfile,outname,tn,x1n,y1n,z1n,x2n,y2n,z2n)
 if(nargin()<9)
  z2n = 'w_y';
 end%if
 if(nargin()<8)
  y2n = 'zw';
 end%if
 if(nargin()<7)
  x2n = 'xw';
 end%if
 if(nargin()<6)
  z1n = 'w_x';
 end%if
 if(nargin()<5)
  y1n = 'zw';
 end%if
 if(nargin()<4)
  x1n = 'yu';
 end%if
 if(nargin()<3)
  tn = 'time';
 end%if
 nc = netcdf(dagfile,'r');
 t = nc{tn}(:)';
 x1 = nc{x1n}(:)';
 y1 = -nc{y1n}(:)';
 x2 = nc{x2n}(:)';
 y2 = -nc{y2n}(:)';
 for i=1:length(t)
  countstr = num2str(i,"%06i");
  z1 = squeeze(nc{z1n}(i,:,:,:));
  z2 = squeeze(nc{z2n}(i,:,:,:));
  upperlab = {
  "set xtics out nomirror"
  "set xlabel 'Meridional Position (m)'",
  "set ylabel 'Depth (m)'",
  "set cblabel 'w (m/s)'",
  "set cbrange [-.1:.1]",
  "set palette defined (0 'blue', .45 'cyan', .5 'white', .55 'yellow',  1 'red')",
  ["set title 'Vertical Velocity at t_0 + " num2str(floor(t(i)/3600),"%03i") ":" num2str(floor(rem(t(i),3600)/60),"%02i") ":" num2str(rem(t(i),60),"%005.2f") "'"]
  };
  lowerlab = {
  "set xlabel 'Zonal Position (m)'",
  "set ylabel 'Depth (m)'",
  "set cblabel 'w (m/s)'",
  "set cbrange [-.1:.1]",
  "set palette defined (0 'blue', .45 'cyan', .5 'white', .55 'yellow',  1 'red')",
  "unset title"
  };
  twocolor(x1,y1,z1,x2,y2,z2,[outname countstr],upperlab,lowerlab,'pngposter');
 end%for
 ncclose(nc)
 unix(['/home/mhoecker/bin/pngmovie.sh -l ' outname ' -n ' outname ' -t avi -w 1024 -v 1536'])
end%function
