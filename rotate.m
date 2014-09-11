function [zzr,Lx,Ly] = rotate(x,y,zz,phi,Lx,Ly)
Nx = length(x);
Ny = length(y);

if nargin()<5
Lx = (max(x)-min(x))*(Nx+1)/(Nx);
 if nargin()<6
  Ly = (max(y)-min(y))*(Ny+1)/(Ny);
 endif
endif
xm = mean(x);
ym = mean(y);
Nxpad = ceil((sqrt(Nx^2+Ny^2)-Nx)/2);
Nypad = ceil((sqrt(Nx^2+Ny^2)-Ny)/2);

[xx,yy] = meshgrid(x-xm,y-ym);

pcolor(xx,yy,zz); shading flat; colorbar; axis([[-0.5,0.5]*Lx,[-0.5,0.5]*Ly]); title("Input Field")

xa = [x(Nx-Nxpad:Nx)-Lx,x,x(1:Nxpad)+Lx]-xm;
ya = [y(Ny-Nypad:Ny)-Ly,y,y(1:Nypad)+Ly]-ym;

[xxa,yya] = meshgrid(xa,ya);

zza = flipud([zz(1:Nypad,	Nx-Nxpad:Nx),zz(1:Nypad,1:Nx),zz(1:Nypad,1:Nxpad)]);
zza = [zza;zz(1:Ny,Nx-Nxpad:Nx),zz(1:Ny,1:Nx),zz(1:Ny,1:Nxpad)];
zza = [zza;flipud([zz(Ny-Nypad:Ny,	Nx-Nxpad:Nx),zz(Ny-Nypad:Ny,1:Nx),zz(Ny-Nypad:Ny,1:Nxpad)])];

pcolor(xxa,yya,zza); shading flat; colorbar; axis([[-0.5,0.5]*Lx*(1+Nxpad/Nx),[-0.5,0.5]*Ly*(1+Nypad/Ny)]); title("Augmaneted Field")


xxra = cos(phi)*xxa+sin(phi)*yya;
yyra = cos(phi)*yya-sin(phi)*xxa;

pcolor(xxra,yyra,zza);  shading flat; colorbar; axis([[-0.5,0.5]*Lx*(1+Nxpad/Nx),[-0.5,0.5]*Ly*(1+Nypad/Ny)]*(2)); title("Rotated Augmented Field")

zzr = griddata(xxra(:),yyra(:),zza(:),xx,yy);

pcolor(xx,yy,zzr);  shading flat; colorbar; axis([[-0.5,0.5]*Lx,[-0.5,0.5]*Ly]); title("Regridded and Cropped Field")

endfunction
