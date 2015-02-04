function [isoP] = isopycnalize(t,z,U_z,V_z,SA,CT,rho_cords)
%
%
%
%
 interp_order = 4;
 findgsw;
 if(nargin<1)
  t = 2*pi*linspace(0,1,20);
  z = -(1:1:30);
  zmid = mean(z);
  zrange = (max(z)-min(z))/2;
  wh = .3;
  [zz,tt] = meshgrid(z,t);
  bad = rand(size(zz));
  idxbad = find(bad>.9);
  bad = 0*bad;
  bad(idxbad) = NaN;
  ww = wh*sin(tt)+(zz-zmid)/zrange;
  SA  = bad + 35+.005*(ww-.05*tt.*tanh(pi*ww));
  CT  = bad + 15+12*(ww-.05*tt.*tanh(pi*ww));
  U_z = bad + 0.5.+sin(pi*ww);
  V_z = bad + 0.5.+cos(pi*ww);
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
  rho_cords = linspace(isoP.rhomin,isoP.rhomax,2*length(z));
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
   pcolor(tt,zz,SA); shading flat; title("SA")
   subplot(2,2,2)
   pcolor(tt,zz,CT); shading flat; title("CT")
   subplot(2,2,3)
   pcolor(tt,zz,U_z); shading flat; title("U ")
   subplot(2,2,4)
   pcolor(tt,zz,V_z); shading flat; title("V ")
  figure(2)
   subplot(2,1,1)
   pcolor(tt,zz,isoP.rho); shading flat; caxis([isoP.rhomin,isoP.rhomax]); colorbar
   subplot(2,1,2)
   pcolor(tr,rr,isoP.z); shading flat; caxis(zmid+[-1.1,+1.1]*zrange); colorbar
  figure(3)
   subplot(2,2,1)
   pcolor(tr,rr,isoP.SA); shading flat; title("SA")
   subplot(2,2,2)
   pcolor(tr,rr,isoP.CT); shading flat; title("CT")
   subplot(2,2,3)
   pcolor(tr,rr,isoP.U); shading flat; title("U ")
   subplot(2,2,4)
   pcolor(tr,rr,isoP.V); shading flat; title("V ")
 end%if
end%function

function B = clipper(A,Arange)
 B = A;
 idxhigh    = find(A>max(Arange));
 B(idxhigh) = max(Arange);
 idxlow     = find(A<min(Arange));
 B(idxlow)  = min(Arange);
end%function
