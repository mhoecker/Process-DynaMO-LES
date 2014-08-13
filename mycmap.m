function cmap = mycmap(name,N)
 cmap = [];
 switch(name)
  case{"red","RED","Red"}
   cmap = [cmap;hex2dec('FF'),hex2dec('FF'),hex2dec('FF')];% #FFFFFF
   cmap = [cmap;hex2dec('FF'),hex2dec('FF'),hex2dec('00')];% #FFFF00
   cmap = [cmap;hex2dec('FF'),hex2dec('99'),hex2dec('00')];% #FF9900
   cmap = [cmap;hex2dec('FF'),hex2dec('00'),hex2dec('00')];% #FF0000
  case{"blue","Blue","BLUE"}
   cmap = [cmap;hex2dec('FF'),hex2dec('FF'),hex2dec('FF')];% #FFFFFF
   cmap = [cmap;hex2dec('00'),hex2dec('FF'),hex2dec('FF')];% #00FFFF
   cmap = [cmap;hex2dec('00'),hex2dec('99'),hex2dec('FF')];% #0099FF
   cmap = [cmap;hex2dec('00'),hex2dec('00'),hex2dec('FF')];% #0000FF
  case{"grey","gray"}
   cmap = [cmap;255*[1,1,1]];% white
   cmap = [cmap;floor(.8*255)*[1,1,1]];% #
   cmap = [cmap;floor(.7*255)*[1,1,1]];% #
   cmap = [cmap;floor(.6*255)*[1,1,1]];% #
   cmap = [cmap;floor(.55*255)*[1,1,1]];% #
   cmap = [cmap;floor(.5*255)*[1,1,1]];% #
   cmap = [cmap;floor(.45*255)*[1,1,1]];% #
   cmap = [cmap;floor(.4*255)*[1,1,1]];% #
   cmap = [cmap;floor(.3*255)*[1,1,1]];% #
   cmap = [cmap;floor(.2*255)*[1,1,1]];% #
   cmap = [cmap;0*[1,1,1]];% black
 end%switch
 cmap = cmap/255;
 if(nargin>1)
  if(N>length(cmap(:,1)))
   level1 = (0:(length(cmap(:,1))-1))/(length(cmap(:,1))-1);
   level2 = (0:(N-1))/(N-1);
   cmap2 = interp1(level1',cmap,level2','linear');
   clear cmap
   cmap = cmap2;
  end%if
 end%if
end%function
