function LESsurfBC(fileloc,filename,wantdates,outloc)
 # function LESsurfBC(fileloc,ncfile,wantdates,outloc)
 # fileloc  - directiory of the data file
 # filename - name of the data file (no suffix, it is assumed to be .nc)
 # wantdates - [start date, end date] in matlab datenum format
 # outloc   - directory of output file (assume to be the currentdirectory if not given)
 if(nargin<4)
  outloc = "";
 end%if
 ncfile = [fileloc filename ".nc"];
 nc = netcdf(ncfile,"r");
 t = nc{'t'}(:);
 dateidx = find((t>=min(wantdates))&(t<=max(wantdates)));
 t = nc{'t'}(dateidx);
 tmodel = (t-min(t))*24;
 shortw = 1.01*nc{'SW'}(dateidx);
 surfac = nc{'LW'}(dateidx)+nc{'Sen'}(dateidx)+nc{'RainF'}(dateidx);
 LW = nc{'LW'}(dateidx);
 Sen = nc{'Sen'}(dateidx);
 RainF = nc{'RainF'}(dateidx);
 latent = nc{'La'}(dateidx);
 precip = nc{'Precip'}(dateidx);
 Taux   = nc{'Tau_x'}(dateidx);
 Tauy   = nc{'Tau_y'}(dateidx);
 fadein = 1-exp((min(t)-t)*8);
 L = 30;
 Lmax = 1000;
 Height = 2;
 outname = [outloc int2str(floor(min(t))) "-" int2str(ceil(max(t))) filename];
 fileout = [outname ".bc"];
 outid = fopen(fileout,"w");
 fprintf(outid,'Flux=%s.nc  waves=%s %sGMT-%sGMT\n',filename,"faked",datestr(min(t),"dd-mmm-yyyy HH"),datestr(max(t),"dd-mmm-yyyy HH"));
 fprintf(outid,' \n');
 fprintf(outid,' swf_top, hf_top, lhf_top, rain, ustr_t, vstr_t, wave_l, wave_h, w_angle\n');
 for i=1:length(t);
  fprintf(outid,'%f %f %f %f %f %f %f %f %f %f\n',tmodel(i),shortw(i),surfac(i),latent(i),precip(i),Taux(i),Tauy(i),Lmax*L/(L+(Lmax-L)*fadein(i)),Height*fadein(i),mod(atan2(Taux(i),Tauy(i))*180/pi+360,360))
 end%for
 fclose(outid)
 # plot forcing functions
 figure(1)
 subplot(3,1,1)
 plot(tmodel,shortw,";swf_{top};")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,2)
 plot(tmodel,surfac,";hf_{top};")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,3)
 plot(tmodel,latent,";lhf_{top};")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 print([outname "heat.png"],"-dpng")
 figure(2)
 plot(tmodel,precip,";rain;")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 ylabel("mm/hr")
 print([outname "rain.png"],"-dpng")
 figure(3)
 plot(tmodel,Taux,";ustr_{t};",tmodel,Tauy,";vstr_{t};")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 ylabel("Pa")
 print([outname "stress.png"],"-dpng")
 figure(4)
 subplot(3,1,1)
 plot(tmodel,LW,";LW;")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,2)
 plot(tmodel,Sen,";Sen;")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 subplot(3,1,3)
 plot(tmodel,RainF,";RainF;")
 ylabel("W/m^2")
 axis([min(tmodel),max(tmodel)])
 xlabel("model hour")
 print([outname "hf.png"],"-dpng")

end%function
