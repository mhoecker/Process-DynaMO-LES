function palette = paltext(paltype,cmin,cmax)
%function palette = paltext(paltype,cmin,cmax)
% return gnuplot text (with carrige return) to give desired palette
%
% palype = "hue" or "rainbow" gives a rainbow with balck and grey80 end members
% palype = "euh" or "backrainbow" gives a inverted rainbow with balck and grey80 end members
% palype = "plusminus" or "pm" gives blue to cyan to grey80 to yellow to red, grey80 is the midpoint
%   if cmin and cmax are given grey80 is placed at zero
 if nargin()<=1
  cmin = -1;
  cmax = +1;
 end%if
 crange = cmax-cmin;
 switch paltype
  case {"rainbow" "hue"}
   palette = ["set palette mode HSV\nset palette functions (gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n"];
  case {"backrainbow" "euh"}
   palette = ["set palette mode HSV\nset palette function (1-gray)*.9,.25+.75*(1-gray)**.5,.25+.75*gray**.5\n"];
  case { "plusminus" "pm" "minusplus" "mp" "bluered" "br" }
   palette = ["set palette mode RGB\nset palette defined (0 'blue', " num2str(-.5*cmin/crange) " 'cyan', " num2str(-cmin/crange) " 'white', " num2str((.5*cmax-cmin)/crange) " 'yellow', 1 'red')\n"];
  case { "pos" "positive" "red"}
   palette = ["set palette mode RGB\nset palette defined (0 'white', .5 'yellow', 1 'red')\n"];
  case { "neg" "negative" "blue"}
   palette = ["set palette mode RGB\nset palette defined (0 'white', .5 'cyan', 1 'blue')\n"];
  case { "plusminusnan" "pmnan" "minusplusnan" "mpnan" "bluerednan" "brnan" }
   palette = ["set palette mode RGB\nset palette defined (0 'blue', " num2str(-.5*cmin/crange) " 'cyan', " num2str(-cmin/crange) " 'grey80', " num2str((.5*cmax-cmin)/crange) " 'yellow', 1 'red')\n"];
  case { "posnan" "positivenan" "rednan"}
   palette = ["set palette mode RGB\nset palette defined (0 'grey80', .5 'yellow', 1 'red')\n"];
  case { "negnan" "negativenan" "bluenan"}
   palette = ["set palette mode RGB\nset palette defined (0 'grey80', .5 'cyan', 1 'blue')\n"];
  case { "zissou" }
   palette = ["set palette mode RGB\nset palette defined (0 '#3B9AB2', .25 '#78B7C5', .5 '#EBCC2A', .75 '#E1AF00', 1 '#F21A00')\n set palette maxcolors 9\n"];
  case { "zissoublocks" }
   palette = ["set palette mode RGB\nset palette defined (0 '#3B9AB2',.2 '#3B9AB2', .2 '#78B7C5', .4 '#78B7C5', .4 '#EBCC2A', .6 '#EBCC2A', .6 '#E1AF00', .8 '#E1AF00', .8 '#F21A00', 1 '#F21A00')\n set palette maxcolors 5\n"];
  otherwise
   palette =  "set palette grey"
 end%switch
end%function
