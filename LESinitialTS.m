function fileout = LESinitialTS(filename,outloc,maxdepth)
 #function fileout = LESinitialTS(fileloc,filename,date,outloc)
 # filename - name of the data file (no suffix, it is assumed to be .nc)
 # wantdate - date in matlab datenum format
 # outloc   - directory of output file (assume to be the currentdirectory if not given)
 if(nargin<2)
  outloc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/nextrun/";
 end%if
 % Check for Gibbs Sea Water
 [version_number,version_date] = findgsw;
 nc = netcdf(filename,"r");
  z = nc{'Z'}(:);
 if(nargin<3)
  maxdepth = max(abs(z));
 end%if
 depthidx = find(abs(z)<=abs(maxdepth));
 clear z;
 z = nc{'Z'}(depthidx);
 Tc = nc{'CT'}(depthidx);
 Sa = nc{'SA'}(depthidx);
 P = gsw_p_from_z(z,0);
 idxgood = find(isnan(Tc).*isnan(Sa)==0);
 z = z(idxgood);
 Nz = length(z);
 Tc = Tc(idxgood);
 Sa = Sa(idxgood);
 P = P(idxgood);
 Sp = gsw_SP_from_SA(Sa,P,80.5,0);
 ncclose(nc);
 #
 outname = [outloc "TS_profiles0to" num2str(maxdepth) "m"];
 fileout = [outname ".ic"];
 outid = fopen(fileout,"w");
 fprintf(outid,'-z|Tc|Sp/%s\n',filename);
 if(max(z)<0)
  imax = find(z==max(z));
  fprintf(outid,'%f %f %f\n',0.0,Tc(imax),Sp(imax));
 end%if
 if(mean(diff(z))<0)
 for i=1:length(z);
  fprintf(outid,'%f %f %f\n',abs(z(i)),Tc(i),Sp(i));
 end%for
 else
 for i=length(z):-1:1;
  fprintf(outid,'%f %f %f\n',abs(z(i)),Tc(i),Sp(i));
 end%for
 end%if
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
