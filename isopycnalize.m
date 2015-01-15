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
  SA = 35.-.5*(wh*sin(tt)+zz-zmid)/zrange+tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
  CT = 10.+5*(wh*sin(tt)+zz-zmid)/zrange+5*tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
  U_z = .5.+.5*tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
  V_z = .5.+.5*tanh(pi*(wh*sin(tt).+zz-zmid)/zrange);
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
 isoP.z = rr*0;
 isoP.SA = isoP.z;
 isoP.CT = isoP.z;
 isoP.U = isoP.z;
 isoP.V = isoP.z;

 for i=1:length(t)
  % find z(t,rho)
  rhoi = isoP.rho(i,:);
  rhoirange = [min(rhoi),max(rhoi)];
  idxbad = find((isoP.rho_cords<min(rhoi))+(isoP.rho_cords>max(rhoi)));
  Ui  = U_z(i,:);
  Vi  = V_z(i,:);
  CTi = CT(i,:);
  SAi = SA(i,:);
  %
  val = ddzinterp(rhoi,isoP.rho_cords,interp_order);
  isoP.z(i,:)  = clipper(val*z'  ,z);
  isoP.CT(i,:) = clipper(val*CTi',CTi);
  isoP.SA(i,:) = clipper(val*SAi',SAi);
  isoP.U(i,:)  = clipper(val*Ui' ,Ui);
  isoP.V(i,:)  = clipper(val*Vi' ,Vi);
  isoP.z(i,idxbad) = NaN;
  isoP.U(i,idxbad) = NaN;
  isoP.V(i,idxbad) = NaN;
  isoP.CT(i,idxbad) = NaN;
  isoP.SA(i,idxbad) = NaN;
 end%for
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
