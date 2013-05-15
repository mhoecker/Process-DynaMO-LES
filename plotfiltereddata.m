%Plot data from filtered series
clear all
close all
tzero = datenum([2010,12,31]);
xyranges = [315,329,-250,0];
xyshal = [xyranges(1),xyranges(2),xyranges(4)+.25*(xyranges(3)-xyranges(4)),xyranges(4)];
xydeep = [xyranges(1),xyranges(2),xyranges(3),xyranges(3)+.8*(xyranges(4)-xyranges(3))];
imsize = "-S1280,1024";
font = "-F:8";
device = "-dpng";
addpath "/home/mhoecker/work/TEOS-10";
addpath "/home/mhoecker/work/TEOS-10/library";
plotdir = "/home/mhoecker/work/Dynamo/plots/Filtered/";
adcpfilename = "adcp150_filled_with_140_filtered_1hr_3day";
adcpfile = ["/home/mhoecker/work/Dynamo/Observations/netCDF/ADCP/" adcpfilename ".nc"];
# load adcp data
nc = netcdf(adcpfile,'r');
s = nc{'t'}(:);
z = nc{'z'}(:);
uhp = nc{'uhp'}(:);
vhp = nc{'vhp'}(:);
ulp = nc{'ulp'}(:);
vlp = nc{'vlp'}(:);
lats = nc{'lat'}(:);
lons = nc{'lon'}(:);
[zs,ss] = meshgrid(z,s-tzero);
uhrange = max(max(abs(uhp-ulp)));
ulrange = max(max(abs(ulp)));
vhrange = max(max(abs(vhp-vlp)));
vlrange = max(max(abs(vlp)));
%
figure(1)
subplot(4,1,1)
pcolor(ss,zs,uhp-ulp);shading flat;axis(xyranges);caxis(uhrange*[-1,1]);colorbar;title("U high pass"); ylabel("depth")
%
subplot(4,1,2)
pcolor(ss,zs,vhp-vlp);shading flat;axis(xyranges);caxis(vhrange*[-1,1]);colorbar;title("V high pass"); ylabel("depth")
%
subplot(4,1,3)
pcolor(ss,zs,ulp);shading flat;axis(xyranges);caxis(ulrange*[-1,1]);colorbar;title("U low pass"); ylabel("depth")
%
subplot(4,1,4)
pcolor(ss,zs,vlp);shading flat;axis(xyranges);caxis(vlrange*[-1,1]);colorbar;title("V low pass"); xlabel("2011 yearday"); ylabel("depth")
%
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" adcpfilename ".png"],device,imsize,font)
close all
%
dzmatrix = ddz(z);
Sxhp = dzmatrix*uhp';
Syhp = dzmatrix*vhp';
Sxlp = dzmatrix*ulp';
Sylp = dzmatrix*vlp';
Ssqh = Sxhp.^2+Syhp.^2;
Sshp = (Sxhp-Sxlp).^2+(Syhp-Sylp).^2;
Sslp = Sxlp.^2+Sylp.^2;
Sslpmean = nanmean(nanmean(Sslp,1),2);
Sshpmean = nanmean(nanmean(Sshp,1),2);
Ssrange = 2.^[-4,4];
Sshprange = log10(Sshpmean*Ssrange);
Sslprange = log10(Sslpmean*Ssrange);
%
figure(1)
subplot(4,1,1)
pcolor(ss,zs,log10(Sshp'));shading flat;caxis(Sshprange);colorbar; axis(xyshal); title("(Shear)^2, high pass velocity"); ylabel("depth")
subplot(4,1,2)
pcolor(ss,zs,log10(Sshp'));shading flat;caxis(Sshprange);colorbar;axis(xydeep);ylabel("depth")
subplot(4,1,3)
pcolor(ss,zs,log10(Sslp'));shading flat;caxis(Sslprange);colorbar; axis(xyshal); title("(Shear)^2, low pass velocity"); ylabel("depth")
subplot(4,1,4)
pcolor(ss,zs,log10(Sslp'));shading flat;caxis(Sslprange);colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print([plotdir "Shearsq.png"],device,imsize,font)
close all
%
TCChfilename = "TCCham10_leg3filtered";
TCChfile = ["/home/mhoecker/work/Dynamo/Observations/AurelieObs/"  TCChfilename ".mat"];
load(TCChfile);

spiceh  = (TCChamF.Tch-TCChamF.Tcmean)*TCChamF.alpha-(TCChamF.Sah-TCChamF.Samean)*TCChamF.beta;
spicelp = (TCChamF.Tclp-TCChamF.Tcmean)*TCChamF.alpha-(TCChamF.Sah-TCChamF.Samean)*TCChamF.beta;

%
[tt,zt] = meshgrid(TCChamF.th-tzero,-TCChamF.depth);
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,TCChamF.Sah-TCChamF.Salp);shading flat;colorbar;axis(xyshal);title("High pass salinity"); ylabel("depth")
subplot(4,1,2)
pcolor(tt,zt,TCChamF.Sah-TCChamF.Salp);shading flat;colorbar;axis(xydeep);ylabel("depth")
subplot(4,1,3)
pcolor(tt,zt,TCChamF.Salp);shading flat;colorbar;axis(xyshal); title("Low pass Salinity"); ylabel("depth")
subplot(4,1,4)
pcolor(tt,zt,TCChamF.Salp);shading flat;colorbar;axis(xydeep); ylabel("depth");xlabel("2011 yearday")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename "SaFiltered.png"],device,imsize,font)
close all
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,TCChamF.Tch-TCChamF.Tclp);shading flat;colorbar;axis(xyshal);title("High pass Temperature");ylabel("depth")
subplot(4,1,2)
pcolor(tt,zt,TCChamF.Tch-TCChamF.Tclp);shading flat;colorbar;axis(xydeep);ylabel("depth")
subplot(4,1,3)
pcolor(tt,zt,TCChamF.Tclp);shading flat;colorbar;axis(xyshal);title("Low Pass Temperature");ylabel("depth")
subplot(4,1,4)
pcolor(tt,zt,TCChamF.Tclp);shading flat;colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename "TcFiltered.png"],device,imsize,font)
close all
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,TCChamF.rhoh-TCChamF.rholp);shading flat;colorbar;axis(xyshal);title("High pass Density");ylabel("depth");
subplot(4,1,2)
pcolor(tt,zt,TCChamF.rhoh-TCChamF.rholp);shading flat;colorbar;axis(xydeep);ylabel("depth");
subplot(4,1,3)
pcolor(tt,zt,TCChamF.rholp);shading flat;colorbar;axis(xyshal);title("Low pass Density");ylabel("depth");
subplot(4,1,4)
pcolor(tt,zt,TCChamF.rholp);shading flat;colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename "rhoFiltered.png"],device,imsize,font)
close all
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,log10(TCChamF.epsh)-log10(TCChamF.epslp)); shading flat; colorbar;axis(xyshal);ylabel("depth");title("Hourly Dissipation/Low Pass Dissipation")
subplot(4,1,2)
pcolor(tt,zt,log10(TCChamF.epsh)-log10(TCChamF.epslp)); shading flat; colorbar;axis(xydeep);ylabel("depth");
subplot(4,1,3)
pcolor(tt,zt,log10(TCChamF.epslp)); shading flat; colorbar;axis(xyshal);ylabel("depth");title("Low Pass Dissipation")
subplot(4,1,4)
pcolor(tt,zt,log10(TCChamF.epslp)); shading flat; colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename "epsFiltered.png"],device,imsize,font)
close all
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,spiceh-spicelp);shading flat;colorbar;axis(xyshal);ylabel("depth");title("High pass Spice")
subplot(4,1,2)
pcolor(tt,zt,spiceh-spicelp);shading flat;colorbar;axis(xydeep);ylabel("depth");
subplot(4,1,3)
pcolor(tt,zt,spicelp);shading flat;colorbar;axis(xyshal);ylabel("depth");title("Low pass Spice")
subplot(4,1,4)
pcolor(tt,zt,spicelp);shading flat;colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename "spiceFiltered.png"],device,imsize,font)
close all
%
dzmatrix = ddz(-TCChamF.depth);
nanderh = nanstencil(TCChamF.rhoh,3,1);
sigh = TCChamF.rhoh-1000;
sigh(find(isnan(sigh)))=0;
Nsqh = -gsw_grav(mean(lats))*(nanderh+dzmatrix*sigh)/TCChamF.rhomean;
%
nanderlp = nanstencil(TCChamF.rholp,3,1);
siglp = TCChamF.rholp-1000;
siglp(find(isnan(siglp)))=0;
Nsqlp = -gsw_grav(mean(lats))*(nanderlp+dzmatrix*siglp)/TCChamF.rhomean;
%
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,Nsqh-Nsqlp);shading flat; axis(xyshal);colorbar;ylabel("depth");title("High Pass (Buoyancy Frequency)^2")
subplot(4,1,2)
pcolor(tt,zt,Nsqh-Nsqlp);shading flat;colorbar;axis(xydeep);ylabel("depth")
subplot(4,1,3)
pcolor(tt,zt,Nsqlp);shading flat;axis(xyshal);colorbar;ylabel("depth");title("Low Pass (Buoyancy Frequency)^2")
subplot(4,1,4)
pcolor(tt,zt,Nsqlp);shading flat;colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print([plotdir "BVfreq.png"],device,imsize,font)
close all
%
figure(1)
Sshpt = interp2(zs,ss,Sshp',zt,tt);
Sslpt = interp2(zs,ss,Sslp',zt,tt);
Ssqht = interp2(zs,ss,Ssqh',zt,tt);
subplot(4,1,1)
pcolor(tt,zt,real(log10(4*Nsqh./Ssqht)));shading flat; axis(xyshal);caxis([-3,3]);colorbar;ylabel("depth");title("Hourly Daynamic Stability")
subplot(4,1,2)
pcolor(tt,zt,real(log10(4*Nsqh./Ssqht)));shading flat;caxis([-3,3]);colorbar;axis(xydeep);ylabel("depth")
subplot(4,1,3)
pcolor(tt,zt,log10(4*Nsqlp./Sslpt));shading flat;axis(xyshal);caxis([-3,3]);colorbar;ylabel("depth");title("Low pass Dynamic Stability")
subplot(4,1,4)
pcolor(tt,zt,log10(4*Nsqlp./Sslpt));shading flat;caxis([-3,3]);colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print([plotdir "Stability.png"],device,imsize,font)
close all
%
figure(1)
subplot(4,1,1)
pcolor(tt,zt,log10(TCChamF.epsh)-1.5*log10(Sslpt)); shading flat; colorbar;axis(xyshal);ylabel("depth");title("Hourly Dissipation scaled by Low Pass Shear cubed")
subplot(4,1,2)
pcolor(tt,zt,log10(TCChamF.epsh)-1.5*log10(Sslpt)); shading flat; colorbar;axis(xydeep);ylabel("depth");
subplot(4,1,3)
pcolor(tt,zt,log10(TCChamF.epsh)-1.5*log10(abs(Nsqlp))); shading flat; colorbar;axis(xyshal);ylabel("depth");title("Hourly Dissipation scaled by Low Pass Stratification cubed")
subplot(4,1,4)
pcolor(tt,zt,log10(TCChamF.epsh)-1.5*log10(abs(Nsqlp))); shading flat; colorbar;axis(xydeep);ylabel("depth");xlabel("2011 yearday")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename adcpfilename "scaledepsFiltered.png"],device,imsize,font)
close all
%
figure(1)
subplot(2,2,1)
plot(TCChamF.alpha*(TCChamF.Tch-TCChamF.Tcmean),TCChamF.beta*(TCChamF.Sah-TCChamF.Samean),".");ylabel("Salinity");title("Hourly T/S Density Anomaly")
subplot(2,2,2)
plot(TCChamF.alpha*(TCChamF.Tch-TCChamF.Tclp),TCChamF.beta*(TCChamF.Sah-TCChamF.Salp),".");title("High pass T/S Density Anomaly")
subplot(2,2,3)
plot(TCChamF.alpha*(TCChamF.Tclp-TCChamF.Tcmean),TCChamF.beta*(TCChamF.Salp-TCChamF.Samean));ylabel("Salinity");title("Daily T/S Density Anomaly")
subplot(2,2,4)
plot(TCChamF.Tclp-TCChamF.Tcmean,TCChamF.Salp-TCChamF.Samean);ylabel("Salinity");title("Daily T/S Anomaly")
print(["/home/mhoecker/work/Dynamo/plots/Filtered/" TCChfilename adcpfilename "TSFiltered.png"],device,imsize,font)
close all
%
[spice,spice2,rholin] = linearSpice(TCChamF.Tclp-TCChamF.Tcmean,TCChamF.Salp-TCChamF.Samean,TCChamF.alpha,TCChamF.beta);
pcolorContour("/home/mhoecker/tmp/test","png",TCChamF.th-tzero,-TCChamF.depth,spice,rholin)
pcolorContour("/home/mhoecker/tmp/test2","png",TCChamF.th-tzero,-TCChamF.depth,spice2,rholin)
close all
