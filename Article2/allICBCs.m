# make a bunch of Initial conditions
MIMOCfitpath = "/home/mhoecker/work/Dynamo/plots/MIMOC/dat/tanhfits";
overalloutpath = "/home/mhoecker/work/Dynamo/output/CompareRuns/";
RAMATAOfitpath = "/home/mhoecker/work/Dynamo/Observations//netCDF/monthly/";
RAMATAOfitfile = [RAMATAOfitpath "RAMA_TAO.nc"];
%
%
%month for U;
Umonth = 11;
Unc = netcdf(RAMATAOfitfile,'r');
lons = Unc{'lon'}(:);
Uparams = zeros(4,length(lons));
tidx = find(Unc{'month'}(:)==Umonth)
Uparams(1,:) = Unc{'DU'}(tidx,:);
Uparams(2,:) = Unc{'Zm_u'}(tidx,:);
Uparams(3,:) = Unc{'dZ_u'}(tidx,:);
Uparams(4,:) = Unc{'U_ave'}(tidx,:);
ncclose(Unc);
Uparams
%
%
maxbadmonth = 2;
% DYNAMO fluxes
  dynamo.JSW = [500,50];
  dynamo.JLW = [-50,-50];
  dynamo.JLA = [-100,-300];
  dynamo.P   = [0,50];
  dynamo.Tx  = [0,0.3];
  dynamo.Ty  = [0,0];
  dynamo.Wl  = [100,30];
  dynamo.Wh  = [dynamo.Wl(1)/100,dynamo.Wl(2)/10];
  dynamo.Wd  = 180*atan2(dynamo.Tx,dynamo.Ty)/pi;
% TOGA/COARE fluxes
  togacoare.JSW = [700,700];
  togacoare.JLW = [-50,-50];
  togacoare.JLA = [-150,-150];
  togacoare.P   = [0,10];
  togacoare.Tx  = [0,0.2];
  togacoare.Ty  = [0,0];
  togacoare.Wl  = [100,30];
  togacoare.Wh  = [togacoare.Wl(1)/100,togacoare.Wl(2)/10];
  togacoare.Wd  = 180*atan2(togacoare.Tx,togacoare.Ty)/pi;

for i=1:12
# Read T parameters
 MIMOCtmpfit = [MIMOCfitpath "Tfitparams" num2str(i,"%02i") ".dat"];
 tmpid = fopen(MIMOCtmpfit);
 T = fread(tmpid,[6,Inf],"float32");
 fclose(tmpid);
 idxATL = find(T(1,:)<20);
 T(1,idxATL)=T(1,idxATL)+360;
# Read S parameters
 MIMOCsalfit = [MIMOCfitpath "Sfitparams" num2str(i,"%02i") ".dat"];
 salid = fopen(MIMOCsalfit);
  S = fread(salid,[6,Inf],"float32");
 fclose(salid);
 idxATL = find(S(1,:)<20);
 S(1,idxATL)=S(1,idxATL)+360;
# interp nans
 if(i==1)
  nodat = sign(sum(isnan(T)+isnan(S)));
 else
  nodat = nodat+sign(sum(isnan(T)+isnan(S)));
 end%if
 for j=2:6
  Tisbad      = find(isnan(T(j,:)));
  Tisgood     = find(~isnan(T(j,:)));
  T(j,Tisbad) = interp1(T(1,Tisgood),T(j,Tisgood),T(1,Tisbad));
  Sisbad      = find(isnan(S(j,:)));
  Sisgood     = find(~isnan(S(j,:)));
  S(j,Sisbad) = interp1(S(1,Sisgood),S(j,Sisgood),S(1,Sisbad));
 end%for
# Calculate means
 if(i==1)
 Tmean = T;
 Smean = S;
 else
  Tmean = Tmean+T;
  Smean = Smean+S;
 end%if

end%for
idxbad = find(nodat>=maxbadmonth);
Tmean(:,idxbad) = NaN;
Smean(:,idxbad) = NaN;
Tmean           = Tmean/12;
Smean           = Smean/12;
idxgood         = find(nodat<maxbadmonth);
Tmean           = Tmean(:,idxgood);
Smean           = Smean(:,idxgood);
findgsw;
g = gsw_grav(0);
Pbar   = gsw_p_from_z((Tmean(3,:)+Smean(3,:))/2,0);
rhobar = gsw_rho(Smean(5,:),Tmean(5,:),Pbar);
Tparams = zeros(4,length(lons));
Sparams = zeros(4,length(lons));
badparam = interp1(T(1,:),nodat,lons)
for i=1:4
 i
 Tparams(i,:) = interp1(Tmean(1,:),Tmean(i+1,:),lons);
 Sparams(i,:) = interp1(Smean(1,:),Smean(i+1,:),lons);
end%for
idxbadparam = find(badparam>maxbadmonth);
Tparams(:,idxbadparam) = NaN;
Sparams(:,idxbadparam) = NaN;
[lons,Tparams']
[lons,Sparams']
[lons,Uparams']
for i=1:length(lons)
 outpath = [overalloutpath num2str(lons(i),"%005.1f")];
 makeICBCnetCDF([outpath "DYNAMO/data/"],Uparams(:,i),Tparams(:,i),Sparams(:,i),dynamo)
 makeICBCnetCDF([outpath "TOGACOARE/data/"],Uparams(:,i),Tparams(:,i),Sparams(:,i),togacoare)
end%for
