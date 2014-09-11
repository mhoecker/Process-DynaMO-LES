[h,t] =Wavecorrected2NetCDF("/home/mhoecker/work/Dynamo/Observations/ascii/PSD_wave/","Wavecorrected_32812","/home/mhoecker/tmp/");
output_dir = "/home/mhoecker/work/Dynamo/output/surfspectra/";
plot_dir = "/home/mhoecker/work/Dynamo/plots/surfacewaves/";
basename = "wavespectra";
time()-tic
win = 'sinw';
day = floor(min(t));
Nt = length(t);
dN = 1799;
close all
for i=1:dN:Nt-dN
 tic = time();
 hin = h(i:i+dN);
 hin = hin;
 j = ceil((i+dN)/(dN+1));
 hour = floor((t(i)-day)*24);
 minute = floor(((t(i)-day)*24-hour)*60);
 second = floor((((t(i)-day)*24-hour)*60-minute)*60);
 datestring = [padint2str(day,3) '-' padint2str(hour,2) '-' padint2str(minute,2) '-' padint2str(second,2)];
 tin = t(i:i+dN);
 tin = (tin-min(tin))*24*60*60;
 dt = mean(diff(tin));
 [Px,dPx,f,xfit] = gappypsd(hin,tin,win);
 df = mean(diff(f));
#
 Pxm = max(Px);
 fmax = f(find(Px==Pxm,1));
#
 figure(1)
#
 subplot(2,1,1);
 plot(tin,hin,'k.-;observation;',tin,xfit,'.-;fit;');
 title(['Starting' padint2str(hour,2) ':' padint2str(minute,2) ':' padint2str(second,2) ', Julian day ' int2str(day)])
 axis([0,dN*dt,min(hin),max(hin)])
 xlabel('Time (s)');
 ylabel('Displacement (m)');
#
 subplot(2,1,2)
 loglog(f,Px,'.-;fit Spectra;');
 title([' A_{max}=' num2str(sqrt(2*Pxm*df)) 'm Period=' num2str(1/fmax) ' wavelength=' num2str(9.80665/(2*pi*fmax^2))])
 xlabel('Frequency (1/s)');
 ylabel('Displacement (m^2/Hz)');
 axis([df,(dN+1)*df/2,Pxm/256,2*Pxm]);
#
 print([plot_dir basename datestring '.png'],'-dpng')
 time()-tic
 save("-V7",[output_dir basename datestring ".mat"],"tin","hin","xfit","f","Px");
end
