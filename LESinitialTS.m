function fileout = LESinitialTS(filename,wantdate,outloc,avgtime,maxdepth)
 #function fileout = LESinitialTS(fileloc,filename,date,outloc)
 # fileloc  - directiory of the data file
 # filename - name of the data file (no suffix, it is assumed to be .nc)
 # wantdate - date in matlab datenum format
 # outloc   - directory of output file (assume to be the currentdirectory if not given)
 if(nargin<3)
  outloc = "";
 end%if
 % Check for Gibbs Sea Water
 [version_number,version_date] = findgsw;
 nc = netcdf(filename,"r");
 t = nc{'t'}(:);
 z = nc{'z'}(:);
 dateidx = find(abs(t-wantdate)<avgtime,1);
 depthidx = find(abs(z)<=abs(maxdepth));
 dateused  = mean(t(dateidx));
 clear t;
 clear z;
 z = nc{'z'}(depthidx);
 Tc = nanmean(nc{'T'}(dateidx,depthidx),1);
 Sa = nanmean(nc{'S'}(dateidx,depthidx),1);
 P = gsw_p_from_z(z,0);
 idxgood = find(isnan(Tc).*isnan(Sa)==0);
 z = z(idxgood);
 Tc = Tc(idxgood);
 Sa = Sa(idxgood);
 P = P(idxgood);
 Sp = gsw_SP_from_SA(Sa,P,80.5,0);
 ncclose(nc);
 #
 outname = [outloc "TS_profiles" int2str(floor(dateused))]
 fileout = [outname".ic"];
 outid = fopen(fileout,"w");
 fprintf(outid,'-z|Tc|Sp/%s.nc %sGMT\n',filename,datestr(dateused,"dd-mmm-yyyy HH"));
 if(max(z)<0)
  imax = find(z==max(z));
  fprintf(outid,'%f %f %f\n',0.0,Tc(imax),Sp(imax))
 end%if
 for i=1:length(z);
  fprintf(outid,'%f %f %f\n',abs(z(i)),Tc(i),Sp(i))
 end%for
 fclose(outid)
 subplot(1,2,1)
 plot(Tc,z)
 xlabel("Temperature (C)")
 ylabel("Depth (m)")
 subplot(1,2,2)
 plot(Sp,z)
 xlabel("Salinity (psu)")
 ylabel("Depth (m)")
 print([outname ".png"],"-dpng")
end%function
