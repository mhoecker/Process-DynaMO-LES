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
 else
  N=max(N,3);
 end%if
 if(nargin<1)
  paltype = "";
 end%if
 n = num2str(N,"%i");
 crange = cmax-cmin;
 cmid = num2str(-cmin/(crange));

 % Define all the possible palettes
 palstruct.hue = ["set palette mode HSV\nset palette functions (gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\nset palette maxcolors " n "\n"];
 %
 palstruct.euh = ["set palette mode HSV\nset palette function (1-gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\nset palette maxcolors " n "\n"];
 %
 palstruct.pmnan = ["set palette mode RGB\nxmid = " cmid "\nr(x) = (x>xmid ?  .3+.7*(1-x)/(1-xmid) : .75*x/xmid)\nb(x) = (x<xmid ? .3+.7*x/xmid : .75*(1-x)/(1-xmid))\ng(x) = (x>xmid ? (1-x)/(1-xmid) : (x<xmid ? x/xmid : .75))\nset palette function r(gray),g(gray),b(gray)\nset palette maxcolors " n "\n"];
 %
 palstruct.pm = ["set palette mode RGB\nxmid = " cmid "\nr(x) = (x>=xmid ?  .3+.7*(1-x)/(1-xmid) : x/xmid)\nb(x) = (x<=xmid ? .3+.7*x/xmid : (1-x)/(1-xmid))\ng(x) = (x>xmid ? (1-x)/(1-xmid) : (x<xmid ? x/xmid : 1))\nset palette function r(gray),g(gray),b(gray)\nset palette maxcolors " n "\n"];
 %
 palstruct.posnan = ["set palette mode RGB\nset palette function 1-.7*gray,(1-gray),.7-.7*gray\nset palette maxcolors " n "\n"];
 %
 palstruct.negnan = ["set palette mode RGB\nset palette function .7-.7*gray,(1-gray),1-.7*gray\nset palette maxcolors " n "\n"];
 %
 palstruct.pos = ["set palette mode RGB\nset palette function 1-.7*gray,(1-gray),1-gray\nset palette maxcolors " n "\n"];
 %
 palstruct.neg = ["set palette mode RGB\nset palette function 1-gray,(1-gray),1-.7*gray\nset palette maxcolors " n "\n"];
 %
 palstruct.zissou = ["set palette mode RGB\nset palette defined (0 '#3B9AB2', .25 '#78B7C5', .5 '#EBCC2A', .75 '#E1AF00', 1 '#F21A00')\nset palette maxcolors " n "\n"];
 %
 palstruct.zissoublocks = ["set palette mode RGB\nset palette defined (0 '#3B9AB2',.2 '#3B9AB2', .2 '#78B7C5', .4 '#78B7C5', .4 '#EBCC2A', .6 '#EBCC2A', .6 '#E1AF00', .8 '#E1AF00', .8 '#F21A00', 1 '#F21A00')\nset palette maxcolors 5\n"];
 %
 palstruct.circle = ["set palette mode HSV\nset palette function .3+.3*sgn(sin(2*pi*gray+pi/2)),(.5-.5*cos(4*pi*gray+pi))**.5,.3+.7*(.5-.5*cos(2*pi*gray+pi/2))**.5\nset palette maxcolors " n "\n"];
 %
 palstruct.other = ["set palette grey\nset palette maxcolors " n "\n"];
 %
 switch paltype
  case {"rainbow" "hue"}
   palette = palstruct.hue;
  case {"backrainbow" "euh"}
   palette = palstruct.euh;
  case { "plusminusnan" "pmnan" "minusplusnan" "mpnan" "bluerednan" "brnan"}
   palette = palstruct.pmnan;
  case { "plusminus" "pm" "minusplus" "mp" "bluered" "br" }
   palette = palstruct.pm;
  case { "posnan" "positivenan" "rednan"}
   palette = palstruct.posnan;
  case { "negnan" "negativenan" "bluenan"}
   palette = palstruct.negnan;
  case { "pos" "positive" "red"}
   palette = palstruct.pos;
  case { "neg" "negative" "blue"}
   palette = palstruct.neg;
  case { "zissou" }
   palette = palstruct.zissou;
  case { "zissoublocks" }
   palette = palstruct.zissoublocks;
  case { "circle" "angle" "phase"}
   palette = palstruct.circle;
  otherwise
   palette =  palstruct.other;
 end%switch
end%function

