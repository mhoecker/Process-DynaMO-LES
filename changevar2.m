function [changed]=changevar2(x,y,fields,z)
% function [changed]=changevar2(x,y,fields,z)
%          [changed]=changevar2(x,y,fields)
%
% Regrid 2-d fields onto the field fieldss{1}
%
% x       = 1-d co-ordinate
% y       = 1-d co-ordinate
% z       = 1-d co-ordinate
% fieldss  = cell array of 2-d fields fields{i}(x,y)
% changed = structure containing
%           changed.x
%           changed.z
%           changed.fields{1} = yy(x,z)
%           if length(fields>1)
%           changed.fields{i}(x,z)
 if(nargin<1)
  x=4*pi*(0:.03125:1);
 end%if
 if(nargin<2)
  y=0:.05:1;
 end%if
 if(nargin<3)
  [yy,xx]=meshgrid(y,x);
  ww = yy+.5*cos(xx);
  fields = {ww};
  fields = {fields{:},cos(4*pi*ww/3)};
  %fields = {fields{:},sin(4*pi*ww/3)};
 end%if
 %
 changed.x = x;
 if(nargin<4)
  zmax = max(max(fields{1}));
  zmin = min(min(fields{1}));
  zrange = zmax-zmin;
  changed.z = zmin:zrange/(2*length(y)):zmax;
 end%if
 changed.fields = {NaN*zeros(length(x),length(changed.z))};
 for i=2:length(fields)
  changed.fields = {changed.fields{:},changed.fields{1}};
 end%for
 for i=1:length(x)
  zi = fields{1}(i,:);
  zirange = [min(zi),max(zi)];
  idxbad = find((changed.z<min(zi))+(changed.z>max(zi)));
  val = ddzinterp(zi,changed.z,4);
  for j=1:length(fields)
   if(j==1)
    fieldsi                     = y;
   else
    fieldsi                     = fields{j}(i,:);
   end%if
   changed.fields{j}(i,:)      = clipper(val*fieldsi',fieldsi);
   changed.fields{j}(i,idxbad) = NaN;
  end%for
 end%for
 if(nargin<1)
  NF = length(fields);
  figure(1)
  [xy,yy]=meshgrid(x,y);
  [xz,zz]=meshgrid(x,changed.z);
  xyrange=[min(x),max(x),min(y),max(y)];
  xzrange=[min(x),max(x),min(changed.z),max(changed.z)];
  for i=1:NF
   subplot(NF,2,2*i-1)
   pcolor(xy,yy,fields{i}'); shading flat; axis(xyrange); colorbar
   xlabel("x")
   ylabel("y")
   if(i==1)
    title("z(x,y)")
   else
    title(["field{" num2str(i,"%i") "}(x,y)"])
   end%if
   subplot(NF,2,2*i)
   pcolor(xz,zz,changed.fields{i}'); shading flat; axis(xzrange); colorbar
   xlabel("x")
   ylabel("z")
   if(i==1)
    title("y(x,z)")
   else
    title(["field{" num2str(i,"%i") "}(x,z)"])
   end%if
  end%for
  print("/home/mhoecker/tmp/changevar2.png","-dpng")
 end%if
end%function

function B = clipper(A,Arange)
 B = A;
 idxhigh    = find(A>max(Arange));
 B(idxhigh) = max(Arange);
 idxlow     = find(A<min(Arange));
 B(idxlow)  = min(Arange);
end%function

