function [lat,lon,day,weight,P,T,S] = regridargo(argofiles,CFL_vel);
# regrids the data from argo profiles,
# grid size/time window is set using a CFL like limit
# the velocity used is 1m/s
 waiter = waitbar(0);
 if(nargin<1)
  prefix = "/home/mhoecker/work/Dynamo/Observations/netCDF/Argo/201111";
  suffix = "_prof.nc";
  argofiles = {[prefix "23" suffix],[prefix "24" suffix],[prefix "25" suffix]};
 end%if
 if(nargin<2)
  CFL_vel = 1;
 end%if
 Ucfl = CFL_vel*3600*24; # convert to m/day
 lats = [];
 lons = [];
 times = [];
 Ps = [];
 Ts = [];
 Ss = [];
 for i=1:length(argofiles)
  argo = netcdf(argofiles{i},'r')
  profile = squeeze(argo{'DIRECTION'}(:));
  for j=1:length(profile)
   waitbar(j./length(profile),waiter,["reading" argofiles{i}]);
   lats = [lats,squeeze(argo{'LATITUDE'}(j))];
   lons = [lons,squeeze(argo{'LONGITUDE'}(j))];
   times = [times,squeeze(argo{'JULD'}(j))];
   Ps = [Ps,squeeze(argo{'PRES_ADJUSTED'}(j,:))];
   Ts = [Ts,squeeze(argo{'TEMP_ADJUSTED'}(j,:))];
   Ss = [Ss,squeeze(argo{'PSAL_ADJUSTED'}(j,:))];
  end%for
  ncclose(argo)
 end%for
 Adist = [];
 was=now();
 for i=1:length(lats)
  tofin = 24*3600*((now()-was)*(length(lats)-i)/i);
  waitbar(i./length(lats),waiter,["calculating interprofile distances, approximate secons remaining " num2str(tofin,"%04.0f")]);
  Ads = [];
  for j=1:length(lats)
   Ads = [Ads,argodist([lats(i),lons(i),times(i)],[lats(j),lons(j),times(j)],Ucfl)];
  end%for
  Adist = [Adist;Ads];
 end%for
 Adist;
 Lsq = sort(Adist(:))(6*length(lats));
 L = sqrt(Lsq);
 R = 6378100;
 dangle = 180*L/(pi*R);
 lat = min(lats):dangle:max(lats);
 lon = min(lons):dangle:max(lons);
 day = min(times):L/Ucfl:max(times);
 if(length(day)==1)
  day = mean(times);
 end%if
 weight = zeros([length(lat),length(lon),length(day)]);
 was = now();
 for i=1:length(lat)
  for j=1:length(lon)
   tofin = 24*3600*((now()-was)*(length(lat)*length(lon)-i*length(lon)-j)/(i*length(lon)+j));
   for k=1:length(day)
    for l=1:length(lats)
     waitbar(i./length(lat),waiter,["calculating points at lat " num2str(lat(i),"%04.0f") ", lon " num2str(lon(j)) ", date " num2str(day(k)) " time remaining " num2str(tofin)]);
     dist = [argodist([lats(i),lons(i),times(i)],[lats(j),lons(j),times(j)],Ucfl)];
     if(dist<Lsq)
      weight(i,j,k)=weight(i,j,k)+1;
     end%if
    end%for
   end%for
  end%for
 end%for
 close(waiter)
 [xx,yy] = meshgrid(lon,lat);
 wsum = sum(weight,3);
 pcolor(xx,yy,wsum);
end%function

function Asq = argodist(latlontime1,latlontime2,U)
 loc1 = latlontime1(1:2);
 loc2 = latlontime2(1:2);
 dsq = dsqsphere(loc1,loc2);
 Asq = dsq+(U*(latlontime1(3)-latlontime2(3))).^2;
end%function

