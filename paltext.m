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
 % Define common palette elements
 %
 palstruct.rvals = "rmin=0.5\nrrng=1-rmin\n";
 %
 palstruct.gamma = [palstruct.rvals "a=1\n"];
 %
 palstruct.Ncolors = ["set palette maxcolors " n "\n"];
 %
 palstruct.HSV = [palstruct.gamma  palstruct.Ncolors "set palette mode HSV\n"];
 %
 palstruct.RGB = [palstruct.gamma  palstruct.Ncolors "set palette mode RGB\n"];
 %
 palstruct.xmid = ["xm = " cmid "\nz(x) = (x<xm ? x/xm:(1-x)/(1-xm));"];
 %
 palstruct.xmax = ["xm = 1\nz(x) = (1-x)\n"];
 %
 palstruct.xmin = ["xm = 0\nz(x) = x\n"];
 %
 palstruct.white = ["zval = 1.0\n"];
 %
 palstruct.gray  = ["zval = 0.8\n"];
 %
 palstruct.r = [ ];
 %
 palstruct.g = [];
 %
 palstruct.rgbfunctions = [palstruct.RGB "set palette function r(gray),g(gray),b(gray)\n" palstruct.Ncolors];
 %
 palstruct.posfunctions = [palstruct.xmax "r(x)=(x==0 ? zval:rmin+rrng*z(x)**a)\n" "g(x)=(x==0 ? zval:(rrng+rmin)*z(x)**a)\n" "b(x)=(x==0 ? zval:rrng*z(x)**a)\n" palstruct.rgbfunctions];
 %
 palstruct.negfunctions = [palstruct.xmax "b(x)=(x==0 ? zval:rmin+rrng*z(x)**a)\n" "g(x)=(x==0 ? zval:(rrng+rmin)*z(x)**a)\n" "r(x)=(x==0 ? zval:rrng*z(x)**a)\n" palstruct.rgbfunctions];
 %
 palstruct.pmfunctions = [palstruct.xmid "r(x)=(x>xm ? rmin+rrng*z(x)**a:(x<xm ? rrng*z(x)**a: zval))\n" "g(x)=(x==xm ? zval:(rrng+rmin)*z(x)**a)\n" "b(x)=r(1-x)\n" palstruct.rgbfunctions];
 %
 % Define all the possible palettes
 %
 palstruct.hue = [ palstruct.HSV "set palette functions (gray)*.9,rmin+rrng*(1-gray)**.5,rmin+rrng*gray**.5\n" ];
 %
 palstruct.euh = [palstruct.HSV "set palette function (1-gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n"];
 %
 palstruct.pmnan = [ palstruct.gray palstruct.pmfunctions];
 %
 palstruct.pm =    [ palstruct.white palstruct.pmfunctions];
 %
 palstruct.posnan = [ palstruct.gray palstruct.posfunctions];
 %
 palstruct.negnan = [ palstruct.gray palstruct.negfunctions];
 %
 palstruct.pos = [ palstruct.white palstruct.posfunctions];
 %
 palstruct.neg = [ palstruct.white palstruct.negfunctions];
 %
 palstruct.zissou = [  palstruct.RGB  "set palette defined (0 '#3B9AB2', .25 '#78B7C5', .5 '#EBCC2A', .75 '#E1AF00', 1 '#F21A00')\n"  palstruct.Ncolors ];
 %
 palstruct.zissoublocks = [  palstruct.RGB  "set palette defined (0 '#3B9AB2',.2 '#3B9AB2', .2 '#78B7C5', .4 '#78B7C5', .4 '#EBCC2A', .6 '#EBCC2A', .6 '#E1AF00', .8 '#E1AF00', .8 '#F21A00', 1 '#F21A00')\n"  "set palette maxcolors 5\n" ];
 %
 palstruct.circle = [palstruct.RGB "g(x) = .5*rmin+rrng*(x<.25 ? 2*(x+.25) : (x<.75 ? 2*(.75-x) : 2*(x-.75)  ))\n r(x) = .5*rmin+rrng*(x<.25 ? 2*(x+.25) : (x<.5 ? 1 : (x<.75 ? 4*(.75-x) : 2*(x-.75) ) ) )\n b(x) = .5*rmin+rrng*(x<.25 ? 1 : (x<.75 ? 2*(.75-x) : 4*(x-.75) ) )\n" palstruct.rgbfunctions palstruct.Ncolors ];
 %
 palstruct.other = ["set palette grey\n"  palstruct.Ncolors ];
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

