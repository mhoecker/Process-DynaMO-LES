Nx = 64;
Ny = 48;
Lx = 1;
Ly = Lx*Ny/Nx;
pading = Npad/N
phi = pi/6;
phi*180/pi
Nxpad = ceil((sqrt(Nx^2+Ny^2)-Nx)/2)
Nypad = ceil((sqrt(Nx^2+Ny^2)-Ny)/2)
x = linspace(.5,Nx-.5,Nx)/Nx-.5;
y = linspace(.5,Ny-.5,Ny)/Ny-.5;
x = x*Lx;
y = y*Ly;
[xx,yy] = meshgrid(x,y);
zz = 	+sin(4*pi*xx/Lx).*sin(2*pi*yy/Ly);
zzr1 = rotate(x,y,zz,phi);


subplot(1,2,1); 
pcolor(xx,yy,zz); shading flat; colorbar; axis([[-0.5,0.5]*Lx,[-0.5,0.5]*Ly]); title("Input Field")

subplot(1,2,2); 
pcolor(xx,yy,zzr1);  shading flat; colorbar; axis([[-0.5,0.5]*Lx,[-0.5,0.5]*Ly]); title("Regridded and Cropped Field")

print("RotationTest.png","-dpng")
