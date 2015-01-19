function [isoP] = isopycnalize(t,z,U_z,V_z,SA,CT,rho_cords)
%
%
%
%
 interp_order = 4;
 findgsw;
 if(nargin<1)
  t = 1:.5:20;
  z = -(1:.25:20);
  zmid = mean(z);
  zrange = (max(z)-min(z))/2;
  wh = zrange*.2;
  [zz,tt] = meshgrid(z,t);
  bad = rand(size(zz));
  idxbad = find(bad>.99);
  bad = 0*bad;
  bad(idxbad) = NaN;
  SA = bad+35.-.5*(wh*sin(tt)+zz-zmid)/zrange+tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
  CT = bad+10.+5*(wh*sin(tt)+zz-zmid)/zrange+5*tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
  U_z = bad+.5.+.5*tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
  V_z = bad+.5.+.5*tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
 end%if
 isoP.t = t;

 zmid = mean(z);
 zrange = (max(z)-min(z))/2;

 isoP.rho = gsw_rho(SA,CT,0);

 isoP.Umax   = max(max(U_z));
 isoP.Umin   = min(min(U_z));
 isoP.Vmax   = max(max(V_z));
 isoP.Vmin   = min(min(V_z));
 isoP.CTmax  = max(max(CT));
 isoP.CTmin  = min(min(CT));
 isoP.SAmax  = max(max(SA));
 isoP.SAmin  = min(min(SA));
 isoP.zmin   = min(z);
 isoP.zmax   = max(z);
 isoP.rhomax = max(max(isoP.rho));
 isoP.rhomin = min(min(isoP.rho));

if(nargin<7)
  rhodiff = isoP.rhomax-isoP.rhomin;
  rho_cords = isoP.rhomin:rhodiff/(2*length(z)):isoP.rhomax;
 end%if
 isoP.rho_cords = rho_cords;
 [zz,tt] = meshgrid(z,t);
 [rr,tr] = meshgrid(isoP.rho_cords,t);
 fields = {isoP.rho,U_z,V_z,CT,SA};
 changed = changevar2(t,z,fields,rho_cords);
 clear fields
 isoP.z  = changed.fields{1};
 isoP.U  = changed.fields{2};
 isoP.V  = changed.fields{3};
 isoP.CT = changed.fields{4};
 isoP.SA = changed.fields{5};
 if(nargin<1)
  figure(1)
   subplot(2,2,1)
   pcolor(tt,zz,SA); shading flat
   subplot(2,2,2)
   pcolor(tt,zz,CT); shading flat
   subplot(2,2,3)
   pcolor(tt,zz,U_z); shading flat
   subplot(2,2,4)
   pcolor(tt,zz,V_z); shading flat
  figure(2)
   subplot(2,1,1)
   pcolor(tt,zz,isoP.rho); shading flat; caxis([isoP.rhomin,isoP.rhomax]); colorbar
   subplot(2,1,2)
   pcolor(tr,rr,isoP.z); shading flat; caxis(zmid+[-1.1,+1.1]*zrange); colorbar
  figure(3)
   subplot(2,2,1)
   pcolor(tr,rr,isoP.SA); shading flat;
   subplot(2,2,2)
   pcolor(tr,rr,isoP.CT); shading flat;
   subplot(2,2,3)
   pcolor(tr,rr,isoP.U); shading flat;
   subplot(2,2,4)
   pcolor(tr,rr,isoP.V); shading flat;
 end%if
end%function

function B = clipper(A,Arange)
 B = A;
 idxhigh    = find(A>max(Arange));
 B(idxhigh) = max(Arange);
 idxlow     = find(A<min(Arange));
 B(idxlow)  = min(Arange);
end%function
