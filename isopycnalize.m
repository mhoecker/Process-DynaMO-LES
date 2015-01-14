function [isoP]=isopycnalize(t,z,rho_cords,U_z,V_z,SA,CT)
%
%
%
%
 interp_order = 4;
 if(nargin<1)
  t = 1:.5:20;
  z = -(1:.25:20);
  zmid = mean(z);
  zrange = (max(z)-min(z))/2;
  wh = zrange*.2;
  [tt,zz] = meshgrid(t,z);
  SA = 35.-.5*(wh*sin(t)+zz-zmid)/zrange+tanh(pi*(wh*sin(t).+zz-zmid)/zrange);
  CT = 10.+5*(wh*sin(t)+zz-zmid)/zrange+5*tanh(pi*(wh*sin(t).+zz-zmid)/zrange);
  U_z = .5.+.5*tanh(pi*(wh*sin(t).+zz-zmid)/zrange);
  V_z = .5.+.5*tanh(pi*(wh*sin(t).+zz-zmid)/zrange);
 end%if
 rho = gsw_rho(SA,CT,0);
 if(nargin<1)
  rhomax = max(max(rho));
  rhomin = min(min(rho));
  rhodiff = rhomax-rhomin;
  rho_cords = rhomin:rhodiff/100:rhomax;
 end%if
 [tr,rr] = meshgrid(t,rho_cords);
 isoP.z = rr*0;
 isoP.SA = isoP.z;
 isoP.CT = isoP.z;
 isoP.U = isoP.z;
 isoP.V = isoP.z;
 for i=1:length(t)
  % find z(t,rho)
  rhoi = rho(:,i);
  val = ddzinterp(rhoi,rho_cords,interp_order);
  isoP.z(:,i) = val*z';
  isoP.CT(:,i) = val*CT(:,i);
  isoP.SA(:,i) = val*SA(:,i);
  isoP.U(:,i) = val*U_z(:,i);
  isoP.V(:,i) = val*V_z(:,i);
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
   pcolor(tt,zz,rho); shading flat; caxis([rhomin,rhomax]); colorbar
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
