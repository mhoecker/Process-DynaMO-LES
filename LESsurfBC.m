function LESsurfBC(fileloc,filename,wantdates,outloc)
 # function LESsurfBC(fileloc,ncfile,wantdates,outloc)
 # fileloc  - directiory of the data file
 # filename - name of the data file (no suffix, it is assumed to be .nc)
 # wantdates - [start date, end date] in 2011 yearday
 # outloc   - directory of output file (assume to be the currentdirectory if not given)
 if(nargin<4)
  outloc = "";
 end%if
 ncfile = [fileloc filename ".nc"];
 nc = netcdf(ncfile,"r");
 t = nc{'Yday'}(:);
 dateidx = find((t>=min(wantdates))&(t<=max(wantdates)));
 t = nc{'Yday'}(dateidx);
 tmodel = (t-min(t))*24;
 shortw = -nc{'Solarup'}(dateidx)-nc{'Solardn'}(dateidx);
 surfac = -nc{'IRup'}(dateidx)-nc{'IRdn'}(dateidx)-nc{'shf'}(dateidx)-nc{'rhf'}(dateidx);
 LW = -nc{'IRup'}(dateidx)-nc{'IRdn'}(dateidx);
 Sen = -nc{'shf'}(dateidx);
 RainF = -nc{'rhf'}(dateidx);
 latent = -nc{'lhf'}(dateidx);
 precip = nc{'P'}(dateidx);
 Taux   = nc{'stresx'}(dateidx);
 Tauy   = nc{'stresy'}(dateidx);
 fadein = 1-exp((min(t)-t)*8);
 L = 30;
 Lmin = eps*L;
 Height = 2;
 wave_height = Height*fadein;
 wave_length = Lmin+(L-Lmin)*fadein;
 wave_direct = mod(atan2(Taux,Tauy)*180/pi+360,360);
 outname = [outloc int2str(floor(min(t))) "-" int2str(ceil(max(t))) filename];
 fileout = [outname ".bc"];
 outid = fopen(fileout,"w");
 fprintf(outid,'Flux=%s.nc  waves=%s %sGMT-%sGMT\n',filename,"faked",datestr(min(t),"dd-mmm-yyyy HH"),datestr(max(t),"dd-mmm-yyyy HH"));
 fprintf(outid,' \n');
 fprintf(outid,' swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle\n');
 for i=1:length(t);
  fprintf(outid,'%f %f %f %f %f %f %f %f %f %f\n',tmodel(i),shortw(i),surfac(i),latent(i),precip(i),Taux(i),Tauy(i),wave_length(i),wave_height(i),wave_direct(i))
 end%for
 fclose(outid)
 # plot forcing functions
 figure(1)
 subplot(3,1,1)
 plot(tmodel,shortw,";Net Short Wave Flux (swf_{top});")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,2)
 plot(tmodel,surfac,";Net Non-Penetrating Heat Flux (hf_{top});")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,3)
 plot(tmodel,latent,";Latent Heat Flux (lhf_{top});")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 print([outname "heat.png"],"-dpng")
 figure(2)
 subplot(3,1,1)
 plot(tmodel,precip,";Precipitation Rate;")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 ylabel("mm/hr")
 subplot(3,1,2)
 plot(tmodel,wave_height,";wave height;",tmodel,wave_length,";wave length;")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 ylabel("m")
 subplot(3,1,3)
 plot(tmodel,wave_direct,";wave-direction;")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 ylabel("degrees")
 print([outname "rain_waves.png"],"-dpng")
 figure(3)
 subplot(2,1,1)
 plot(tmodel,Taux,";East/West stress;")
 axis([min(tmodel),max(tmodel)])
 ylabel("Pa")
 subplot(2,1,2)
 plot(tmodel,Tauy,";North/South stress;")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 ylabel("Pa")
 print([outname "stress.png"],"-dpng")
 figure(4)
 subplot(3,1,1)
 plot(tmodel,LW,";Net Long Wave Radiation;")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,2)
 plot(tmodel,Sen,";Sensible Heat;")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,3)
 plot(tmodel,RainF,";Rain Heat Flux;")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 print([outname "hf.png"],"-dpng")

end%function
