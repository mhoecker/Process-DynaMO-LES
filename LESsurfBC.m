function outname = LESsurfBC(filename,wantdates,outloc,avgtime,wavespecHL);
 # function LESsurfBC(fileloc,ncfile,wantdates,outloc)
 # filename - name of the data file
 # wantdates - [start date, end date] in 2011 yearday
 # outloc   - directory of output file (assume to be the currentdirectory if not given)
 if(nargin<3)
  outloc = "";
 end%if
 findgsw;
 nc = netcdf(filename,"r");
 t = nc{'Yday'}(:);
 dateidx = find((t>=min(wantdates))&(t<=max(wantdates)));
 t = nc{'Yday'}(dateidx);
 s = min(t):avgtime:max(t);
 tmodel = (s-min(t))*24;
 shortw = -nc{'Solarup'}(dateidx)-nc{'Solardn'}(dateidx);
 shortw = meanfil(shortw,t,s,avgtime);
 %
 surfac = -nc{'IRup'}(dateidx)-nc{'IRdn'}(dateidx)-nc{'shf'}(dateidx)-nc{'rhf'}(dateidx);
 surfac = meanfil(surfac,t,s,avgtime);
 %
 LW = -nc{'IRup'}(dateidx)-nc{'IRdn'}(dateidx);
 LW = meanfil(LW,t,s,avgtime);
 %
 Sen = -nc{'shf'}(dateidx);
 Sen = meanfil(Sen,t,s,avgtime);
 %
 RainF = -nc{'rhf'}(dateidx);
 RainF = meanfil(RainF,t,s,avgtime);
 %
 latent = -nc{'lhf'}(dateidx);
 latent = meanfil(latent,t,s,avgtime);
 %
 precip = nc{'P'}(dateidx);
 precip = meanfil(precip,t,s,avgtime);
 %
 Taux   = -nc{'stress'}(dateidx).*sin(nc{'Wdir'}(dateidx)*pi/180);
 Taux = meanfil(Taux,t,s,avgtime);
 %
 Tauy   = -nc{'stress'}(dateidx).*cos(nc{'Wdir'}(dateidx)*pi/180);
 Tauy = meanfil(Tauy,t,s,avgtime);
 %
 %wave_height = nc{'sigH'}(dateidx);
 %wave_height = meanfil(wave_height,t,s,avgtime);
 %
 %wave_length = (2*pi./gsw_grav(0))*nc{'cp'}(dateidx).^2;
 %wave_length = meanfil(wave_length,t,s,avgtime);
 %
 if(nargin==5)
  load(wavespecHL)
  wave_height = meanfil(Hs,tHL,s,avgtime);
  wave_length = meanfil(Lam,tHL,s,avgtime);
 else
  PMwaves = PiersonMoskowitz(nc{'U10'}(dateidx),t);
  wave_height = meanfil(2*PMwaves.A,PMwaves.t,s,avgtime);
  wave_length = meanfil(PMwaves.L,PMwaves.t,s,avgtime);
  clear waves
 end
 %
 wave_direct = exp(nc{'Wdir'}(dateidx)*I*pi/180);
 wave_direct = meanfil(wave_direct,t,s,avgtime);
 wave_direct = mod(180+imag(log(wave_direct))*180/pi,360);
 %
 outname = [outloc "Surface_Flux_" int2str(floor(min(t))) "-" int2str(ceil(max(t)))];
 fileout = [outname ".bc"];
 outid = fopen(fileout,"w");
 fprintf(outid,'Flux=%s.nc  waves=%s %sGMT-%sGMT\n',filename,"faked",datestr(min(t),"dd-mmm-yyyy HH"),datestr(max(t),"dd-mmm-yyyy HH"));
 fprintf(outid,' \n');
 fprintf(outid,' swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle\n');
 for i=1:length(tmodel);
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
 axis([min(tmodel),max(tmodel),0,360])
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
