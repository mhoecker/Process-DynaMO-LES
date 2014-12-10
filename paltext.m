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
 rmid = .7;
 % Define common palette elements
 palstruct.HSV = "set palette mode HSV\n";
 %
 palstruct.RGB = "set palette mode RGB\n";
 %
 palstruct.gamma = "a= .75;\n";
 %
 palstruct.Ncolors = ["set palette maxcolors " n "\n"];
 %
 palstruct.xmid = ["xmid = " cmid "\nz(x) = (x<xmid ? x/xmid:(1-x)/(1-xmid));"];
 %
 palstruct.rgbfunctions = "set palette function r(gray),g(gray),b(gray)\n";
 %
 palstruct.r = [palstruct.xmid palstruct.gamma "rb(x,rmid,zval)=(x>xmid ? 1-rmid+rmid*z(x)**a:(x<xmid ? rmid*z(x)**a : zval))\n"];
 %
 palstruct.g = [palstruct.xmid "G(x,rmid)=(x==xmid ? rmid:z(x)**a)\n"];
 %
 % Define all the possible palettes
 %
 palstruct.hue = [ palstruct.HSV "set palette functions (gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n" palstruct.Ncolors];
 %
 palstruct.euh = [palstruct.HSV "set palette function (1-gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n" palstruct.Ncolors];
 %
 palstruct.pmnan = [ palstruct.RGB palstruct.r palstruct.g "r(x) = rb(x," num2str(rmid) "," num2str(rmid) ")\n" "b(x) = r(1-x)\n" "g(x) = G(x," num2str(rmid) ")\n" palstruct.rgbfunctions palstruct.Ncolors];
 %
 palstruct.pm = [  palstruct.RGB  palstruct.r  palstruct.g "r(x) = rb(x," num2str(rmid) ",1)\n" "b(x) = r(1-x)\n" "g(x) = G(x,1)\n"  palstruct.rgbfunctions  palstruct.Ncolors ];
 %
 palstruct.posnan = [  palstruct.RGB palstruct.gamma "set palette function " num2str(1-rmid) "+" num2str(rmid) "*(1-gray)**a,(1-gray)**a," num2str(rmid) "*(1-gray)**a\n"  palstruct.Ncolors ];
 %
 palstruct.negnan = [  palstruct.RGB palstruct.gamma "set palette function " num2str(rmid) "*(1-gray)**a,(1-gray)**a," num2str(1-rmid) "+" num2str(rmid) "*(1-gray)**a\n"  palstruct.Ncolors ];
 %
 palstruct.pos = [  palstruct.RGB palstruct.gamma "set palette function " num2str(1-rmid) "+" num2str(rmid) "*(1-gray)**a,(1-gray)**a,(1-gray)**a\n"  palstruct.Ncolors ];
 %
 palstruct.neg = [  palstruct.RGB palstruct.gamma "set palette function (1-gray)**a,(1-gray)**a," num2str(1-rmid) "+" num2str(rmid) "*(1-gray)**a\n"  palstruct.Ncolors ];
 %
 palstruct.zissou = [  palstruct.RGB  "set palette defined (0 '#3B9AB2', .25 '#78B7C5', .5 '#EBCC2A', .75 '#E1AF00', 1 '#F21A00')\n"  palstruct.Ncolors ];
 %
 palstruct.zissoublocks = [  palstruct.RGB  "set palette defined (0 '#3B9AB2',.2 '#3B9AB2', .2 '#78B7C5', .4 '#78B7C5', .4 '#EBCC2A', .6 '#EBCC2A', .6 '#E1AF00', .8 '#E1AF00', .8 '#F21A00', 1 '#F21A00')\n"  "set palette maxcolors 5\n" ];
 %
 palstruct.circle = [  palstruct.HSV  "set palette function .3+.3*sgn(sin(2*pi*gray+pi/2)),(.5-.5*cos(4*pi*gray+pi))**.5,.3+.7*(.5-.5*cos(2*pi*gray+pi/2))**.5\n"  palstruct.Ncolors ];
 %
 palstruct.other = [  "set palette grey\n"  palstruct.Ncolors ];
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

