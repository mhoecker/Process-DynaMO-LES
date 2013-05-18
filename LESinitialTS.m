function fileout = LESinitialTS(fileloc,filename,wantdate,outloc)
#function fileout = LESinitialTS(fileloc,filename,date,outloc)
# fileloc  - directiory of the data file
# filename - name of the data file (no suffix, it is assumed to be .nc)
# wantdate - date in matlab datenum format
# outloc   - directory of output file (assume to be the currentdirectory if not given)
 if(nargin<4)
  outloc = "";
 end%if
 gswloc = "/home/mhoecker/work/TEOS-10/";
 gswlib = "/home/mhoecker/work/TEOS-10/library/";
 addpath(gswloc)
 addpath(gswlib)
 gsw_data = 'gsw_data_v3_0.mat';
 gsw_data_file = which(gsw_data)
 load(gsw_data_file,'version_number','version_date');
 ncfile = [fileloc filename ".nc"];
 nc = netcdf(ncfile,"r");
 t = nc{'th'}(:);
 z = nc{'z'}(:);
 lat = nc{'lat'}(:);
 lon = nc{'lon'}(:);
 dateidx = find(abs(t-wantdate)==min(abs(t-wantdate)),1);
 dateused  = t(dateidx);
 clear t;
 Tc = nc{'Tc'}(dateidx,:);
 Sa = nc{'Sa'}(dateidx,:);
 P = nc{'P'}(:);
 idxgood = find(isnan(Tc).*isnan(Sa)==0);
 z = z(idxgood);
 Tc = Tc(idxgood);
 Sa = Sa(idxgood);
 P = P(idxgood);
 Sp = gsw_SP_from_SA(Sa,P,lon,lat);
 ncclose(nc);
 #
 fileout = [outloc int2str(floor(dateused)) filename ".ic"];
 outid = fopen(fileout,"w");
 fprintf(outid,'-z|Tc|Sp/%s.nc %sGMT lat %3.2f lon %3.2f\n',filename,datestr(dateused,"dd-mmm-yyyy HH"),lat,lon);
 if(max(z)<0)
  imax = find(z==max(z));
  fprintf(outid,'%f %f %f\n',0.0,Tc(imax),Sp(imax))
 end%if
 for i=1:length(z);
  fprintf(outid,'%f %f %f\n',abs(z(i)),Tc(i),Sp(i))
 end%for
 fclose(outid)
end%function
