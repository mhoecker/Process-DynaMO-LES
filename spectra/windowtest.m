num0 = '???'
unix(['rm clean' num0 '*.png sim' num0 '*.png Sine' num0 '*.png Hann' num0 '*.png ' num0 '*.png']);
N = 8192;
t = linspace(0,1-1/N,N);
M = 10^(length(num0)-1)-1;
f1 = N/64;
dy = (2/N);
df = .5*linspace(0,1,M);
Sine = sin(pi*t);
Hann = (1-cos(2*pi*t))/2;
noise = dy*(rand(1,N)-.5);
for i=1:1:M
 num = int2str(i);
 while length(num)<length(num0)
  num=['0' num];
 end
 y = sin(2*pi*(f1+df(i))*t);
 sim = y + noise;
 simSine = sim.*Sine;
 simHann = sim.*Hann;
 [Fy,f,f0,nyq] = PSDplot(t,y,['clean' num]);
 Fsim = PSDplot(t,sim,['sim' num]);
 FSine = PSDplot(t,simSine,['Sine' num]);
 FHann = PSDplot(t,simHann,['Hann' num]);
 figure(1)
 subplot(2,1,1)
 loglog(f,abs(Fy).^2,';Square Window;','linewidth',2,f,abs(Fsim).^2,';Square Window;','linewidth',2,f,abs(FSine).^2,';Sine Window;','linewidth',2,f,abs(FHann).^2,';Hann Window;','linewidth',2);
 axis([f0/2,nyq,(dy/N)^2,1]);
 title(['f/f0 = ' num2str(f1+df(i))])
 xlabel('f/f_0')
 ylabel('|F(y)|^2')
 subplot(2,1,2)
 loglog(f,abs(Fy).^2,'-x;Square Window;','linewidth',2,f,abs(Fsim).^2,'-o;Square Window;','linewidth',2,f,abs(FSine).^2,'-v;Sine Window;','linewidth',2,f,abs(FHann).^2,'-*;Hann Window;','linewidth',2);
 axis([3*f1/4,5*f1/4,(dy/N)^2,1]);
 xlabel('f/f_0')
 ylabel('|F(y)|^2')
 print([num '.png'],'-dpng')
end
