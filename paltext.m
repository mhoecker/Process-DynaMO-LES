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
 if(nargin<1)
  paltype = "";
 end%if
 n = num2str(N,"%i");
 crange = cmax-cmin;
 cmid = num2str(-cmin/(crange));
 switch paltype
  case {"rainbow" "hue"}
   palette = ["set palette mode HSV\nset palette functions (gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\nset palette maxcolors " n "\n"];
  case {"backrainbow" "euh"}
   palette = ["set palette mode HSV\nset palette function (1-gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\nset palette maxcolors " n "\n"];
  case { "plusminusnan" "pmnan" "minusplusnan" "mpnan" "bluerednan" "brnan"}
   palette = ["set palette mode RGB\nxmid = " cmid "\nr(x) = (x>xmid ?  .5+.5*(1-x)/(1-xmid) : .75*x/xmid)\nb(x) = (x<xmid ? .5+.5*x/xmid : .75*(1-x)/(1-xmid))\ng(x) = (x>xmid ? (1-x)/(1-xmid) : (x<xmid ? x/xmid : .75))\nset palette function r(gray),g(gray),b(gray)\nset palette maxcolors " n "\n"];
  case { "plusminus" "pm" "minusplus" "mp" "bluered" "br" }
   palette = ["set palette mode RGB\nxmid = " cmid "\nr(x) = (x>=xmid ?  .5+.5*(1-x)/(1-xmid) : x/xmid)\nb(x) = (x<=xmid ? .5+.5*x/xmid : (1-x)/(1-xmid))\ng(x) = (x>xmid ? (1-x)/(1-xmid) : (x<xmid ? x/xmid : 1))\nset palette function r(gray),g(gray),b(gray)\nset palette maxcolors " n "\n"];
  case { "posnan" "positivenan" "rednan"}
   palette = ["set palette mode RGB\nset palette function 1-.5*gray,(1-gray),.5-.5*gray\nset palette maxcolors " n "\n"];
  case { "negnan" "negativenan" "bluenan"}
   palette = ["set palette mode RGB\nset palette function .5-.5*gray,(1-gray),1-.5*gray\nset palette maxcolors " n "\n"];
  case { "pos" "positive" "red"}
   palette = ["set palette mode RGB\nset palette function 1-.5*gray,(1-gray),1-gray\nset palette maxcolors " n "\n"];
  case { "neg" "negative" "blue"}
   palette = ["set palette mode RGB\nset palette function 1-gray,(1-gray),1-.5*gray\nset palette maxcolors " n "\n"];
  case { "zissou" }
   palette = ["set palette mode RGB\nset palette defined (0 '#3B9AB2', .25 '#78B7C5', .5 '#EBCC2A', .75 '#E1AF00', 1 '#F21A00')\nset palette maxcolors " n "\n"];
  case { "zissoublocks" }
   palette = ["set palette mode RGB\nset palette defined (0 '#3B9AB2',.2 '#3B9AB2', .2 '#78B7C5', .4 '#78B7C5', .4 '#EBCC2A', .6 '#EBCC2A', .6 '#E1AF00', .8 '#E1AF00', .8 '#F21A00', 1 '#F21A00')\nset palette maxcolors 5\n"];
  case { "circle" "angle" "phase"}
   palette = ["set palette mode HSV\nset palette function .3+.3*sgn(sin(2*pi*gray+pi/2)),(.5-.5*cos(4*pi*gray+pi))**.5,.3+.7*(.5-.5*cos(2*pi*gray+pi/2))**.5\nset palette maxcolors " n "\n"];
  otherwise
   palette =  "set palette grey";
 end%switch
end%function

