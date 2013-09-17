function palette = paltext(paltype,cmin,cmax)
%function palette = paltext(paltype,cmin,cmax)
% return gnuplot text (with carrige return) to give desired palette
%
% palype = "hue" or "rainbow" gives a rainbow with balck and white end members
% palype = "euh" or "backrainbow" gives a inverted rainbow with balck and white end members
% palype = "plusminus" or "pm" gives blue to cyan to white to yellow to red, white is the midpoint
%   if cmin and cmax are given white is placed at zero
 if nargin()<=1
  cmin = -1;
  cmax = +1;
 end%if
 crange = cmax-cmin;
 switch paltype
  case {"rainbow" "hue"}
   palette = ["set palette mode HSV\n set palette functions (gray)*.8,(1-gray)**.125,gray**.125\n"];
  case {"backrainbow" "euh"}
   palette = ["set palette mode HSV\n set palette functions (1-gray)*.8,(1-gray)**.125,gray**.125\n"];
  case { "plusminus" "pm" "minusplus" "mp" "bluered" "br" }
   palette = ["set palette mode RGB\n set palette defined (0 'blue', " num2str(-.5*cmin/crange) " 'cyan', " num2str(-cmin/crange) " 'white', " num2str((.5*cmax-cmin)/crange) " 'yellow', 1 'red')\n"];
  otherwise
   palette =  "set palette grey"
 end%switch
end%function
