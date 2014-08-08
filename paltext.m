function palette = paltext(paltype,N,clims)
%function palette = paltext(paltype,cmin,cmax)
% return gnuplot text (with carrige return) to give desired palette
%
% palype = "hue" or "rainbow" gives a rainbow with balck and grey80 end members
% palype = "euh" or "backrainbow" gives a inverted rainbow with balck and grey80 end members
% palype = "plusminus" or "pm" gives blue to cyan to grey80 to yellow to red, grey80 is the midpoint
%   if cmin and cmax are given grey80 is placed at zero
 if nargin()<=2
  cmin = -1;
  cmax = +1;
 else
  cmin = min(clims);
  cmax = max(clims);
 end%if
 if(nargin<2)
  N=9;
 end%if
 n = num2str(N,"%i");
 crange = cmax-cmin;
 cmid = num2str(-cmin/(crange));
 switch paltype
  case {"rainbow" "hue"}
   palette = ["set palette mode HSV\nset palette functions (gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n set palette maxcolors " n "\n"];
  case {"backrainbow" "euh"}
   palette = ["set palette mode HSV\nset palette function (1-gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n set palette maxcolors " n "\n"];
  case { "plusminus" "pm" "minusplus" "mp" "bluered" "br" }
   palette = ["set palette mode RGB\nxmid = " cmid ";r(x) = ( x>= xmid ? 1 : 0 );b(x) = ( x<=xmid ? 1 : 0 );g(x) = (x<xmid ? b(x)*((1-x)/(1-xmid))  : r(x)*(x/xmid));set palette function r(gray),g(gray),b(gray)\n set palette maxcolors " n "\n"];
  case { "pos" "positive" "red" "posnan" "positivenan" "rednan"}
   palette = ["set palette mode RGB\nset palette function 1,(1-gray),0\n set palette maxcolors " n "\n"];
  case { "neg" "negative" "blue" "negnan" "negativenan" "bluenan"}
   palette = ["set palette mode RGB\nset palette function 0,(1-gray),1\n set palette maxcolors " n "\n"];
  case { "plusminusnan" "pmnan" "minusplusnan" "mpnan" "bluerednan" "brnan" }
   palette = ["set palette mode RGB\nxmid = " cmid ";dx = .1/" n ";r(x) = 1-exp(-1-(x-xmid)/dx);b(x) = 1-exp(-1+(x-xmid)/dx);g(x) = (x>xmid ? r(x)*((1-x)/(1-xmid))  : b(x)*(x/xmid));set palette function r(gray),g(gray),b(gray)\n set palette maxcolors " n "\n"];
  case { "zissou" }
   palette = ["set palette mode RGB\nset palette defined (0 '#3B9AB2', .25 '#78B7C5', .5 '#EBCC2A', .75 '#E1AF00', 1 '#F21A00')\n set palette maxcolors " n "\n"];
  case { "zissoublocks" }
   palette = ["set palette mode RGB\nset palette defined (0 '#3B9AB2',.2 '#3B9AB2', .2 '#78B7C5', .4 '#78B7C5', .4 '#EBCC2A', .6 '#EBCC2A', .6 '#E1AF00', .8 '#E1AF00', .8 '#F21A00', 1 '#F21A00')\n set palette maxcolors 5\n"];
  otherwise
   palette =  "set palette grey"
 end%switch
end%function
