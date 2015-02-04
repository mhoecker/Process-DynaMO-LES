function F = mycrosscorr(x,y,t,bands,ci)
 if(nargin<1)
  [x,y,t,bands,ci]=testmycrosscorr;
 else
  if(nargin<2)
  y=x;
  end
  if(nargin<3)
  t=1:length(x);
  end
  if(nargin<4)
  bands=1;
  end
  if(nargin<5)
  ci = .95;
  end
 end
 # Calculate the Fourier frequencies
 N = length(x);
 dt = mean(diff(t));
 T = N*dt;
 df = 1./T;
 f = (linspace(1,N,N)-1-floor(N/2))./T;
 # remove mean
 xi = x(:)-mean(x);
 yi = y(:)-mean(y);
 # window
 xw = window(xi',ceil((bands-1)/2));
 yw = window(yi',ceil((bands-1)/2));
 # Fourier Transform
 Xf = fftshift(fft(xw))/N;
 Yf = fftshift(fft(yw))/N;
 # Power Spectral Density
 Sx  = N*dt*real(Xf.*conj(Xf));
 Sy  = N*dt*real(Yf.*conj(Yf));
 Sxy = N*dt*Yf.*conj(Xf);
 # One Sided
 idx = find(f>0);
 f1  = f(idx);
 Sx1 = 2*Sx(idx);
 Sy1 = 2*Sy(idx);
 #
 Serr = (mean(Sx)+mean(Sy));
 ferr = mean(f1);
 #
 [Pm,Pp] = PSDuncert(ci,1);
 [Pmavg,Ppavg] = PSDuncert(ci,bands);
 [gamsq,gamc,favg,phi,dphi,fphi,Sxavg,Syavg,Sxyavg] = gammaphi(Sxy,Sx,Sy,f,bands,ci);
 # Load the output struct
 F.f = f;
 F.Pm = Pm;
 F.Pp = Pp;
 F.Sx = Sx;
 F.Sy = Sy;
 F.Sxy = Sxy;
 F.favg = favg;
 F.Pmavg = Pmavg;
 F.Ppavg = Ppavg;
 F.Sxavg = Sxavg;
 F.Syavg = Syavg;
 F.Sxyavg = Sxyavg;
 F.gamsq = gamsq;
 F.gamc = gamc;
 F.fphi = fphi;
 F.phi = phi;
 F.dphi = dphi;
 #if(nargin<1)
 # Spectra
  figure(1)
  subplot(3,1,1)
  loglog(f,Sx,favg,Sxavg)
  axis([1/T,N/(2*T)])
  subplot(3,1,2)
  loglog(f,Sy,favg,Syavg)
  axis([1/T,N/(2*T)])
  subplot(3,1,3)
  loglog(f,abs(Sxy),favg,abs(Sxyavg))
  axis([1/T,N/(2*T)])
 #Cross spectra
  figure(2)
  subplot(2,1,1)
  plot(favg,gamsq,favg,gamc,"k.")
  axis([0,N/(2*T),0,1])
  subplot(2,1,2)
  phiplt = [phi;phi+dphi;phi-dphi];
  fphiplt = [fphi;fphi;fphi];
  plot(fphiplt,phiplt,"k+-")
  axis([0,N/(2*T),-pi,pi])
 #end
end
# test function
function [x,y,t,bands,ci] = testmycrosscorr()
 N = 2048;
 t = ((1:N)-1)/N;
 x = (rand(1,N)-.5)/sqrt(N)+sin(2*pi*200.25*t)+sin(2*pi*300.25*t)+cos(2*pi*400.25*t);
 y = (rand(1,N)-.5)/sqrt(N)+ cos(2*pi*200.25*t)+sin(2*pi*500.75*t)+sin(2*pi*400.25*t);
 bands = 12;
 ci = .95;
end
