%filterTCCham
gswloc = "/home/mhoecker/work/TEOS-10/";
gswlib = "/home/mhoecker/work/TEOS-10/library/";
fileloc = "/home/mhoecker/work/Dynamo/Observations/AurelieObs/";
filename = "TCCham10_leg3";
TCChamF.lat = 0;
TCChamF.lon = 80.5;
addpath(gswloc);
addpath(gswlib);
load([fileloc filename ".mat"]);
TCChamF.depth = TCCham.depth;
tidx = 1:length(TCCham.time);
TCChamF.t = TCCham.time(tidx);
TCChamF.th = floor(min(TCChamF.t)*24)/24:1./24:ceil(max(TCChamF.t)*24)/24;
% Get Pressure from depth
TCChamF.P = gsw_p_from_z(-TCChamF.depth,lat);
TCChamF.Pm = mean(TCChamF.P);
TCChamF.Sa = 0*TCCham.S(:,tidx);
TCChamF.Tc = 0*TCCham.T(:,tidx);
TCChamF.epsd = TCCham.EPSILON(:,tidx);
TCChamF.rho = TCChamF.Tc;
TCChamF.rhoSa = TCChamF.Tc;
TCChamF.rhoTc = TCChamF.Tc;
[tt,zz]=meshgrid(TCChamF.th,-TCCham.depth);
%
filsize         = size(tt);
TCChamF.Sah     = zeros(filsize);
TCChamF.Salp    = zeros(filsize);
TCChamF.Tch     = zeros(filsize);
TCChamF.Tclp    = zeros(filsize);
TCChamF.epsh    = zeros(filsize);
TCChamF.epslp   = zeros(filsize);
TCChamF.rhoh    = zeros(filsize);
TCChamF.rholp   = zeros(filsize);
TCChamF.spiceh  = zeros(filsize);
TCChamF.spicelp = zeros(filsize);
% need to be done for each time slice and reassembled
for i=1:length(TCChamF.t)
 TCChamF.Sa(:,i) = gsw_SA_from_SP(TCCham.S(:,tidx(i)),TCChamF.P,TCChamF.lon,TCChamF.lat);
 TCChamF.Tc(:,i) = gsw_CT_from_t(TCChamF.Sa(:,i),TCCham.T(:,tidx(i)),TCChamF.P);
 for j=1:length(TCCham.depth)
  TCChamF.rho(j,i) = gsw_rho_CT(TCChamF.Sa(j,i),TCChamF.Tc(j,i),TCChamF.Pm);
 end%for
% Calculate the density from salinity or temperature alone
end%for
TCChamF.Tcmean= nanmean(nanmean(TCChamF.Tc,2));
TCChamF.Samean= nanmean(nanmean(TCChamF.Sa,2));
%
TCChamF.rhomean = gsw_rho_CT(TCChamF.Samean,TCChamF.Tcmean,TCChamF.Pm);
%
TCChamF.alpha = (gsw_rho_CT(TCChamF.Samean,TCChamF.Tcmean*1.001,TCChamF.Pm)-TCChamF.rhomean)/(TCChamF.Tcmean*0.001);
TCChamF.beta  = (gsw_rho_CT(TCChamF.Samean*1.001,TCChamF.Tcmean,TCChamF.Pm)-TCChamF.rhomean)/(TCChamF.Samean*0.001);
%
% Filter each depth in time
for j=1:length(TCCham.depth)
 TCChamF.Sah(j,:)     = csqfil(TCChamF.Sa(j,:)     ,TCChamF.t  ,TCChamF.th);
 TCChamF.Salp(j,:)    = csqfil(TCChamF.Sah(j,:)    ,TCChamF.th ,TCChamF.th,3);
 TCChamF.Tch(j,:)     = csqfil(TCChamF.Tc(j,:)     ,TCChamF.t  ,TCChamF.th);
 TCChamF.Tclp(j,:)    = csqfil(TCChamF.Tch(j,:)    ,TCChamF.th ,TCChamF.th,3);
 TCChamF.epsh(j,:)    = csqfil(TCChamF.epsd(j,:)   ,TCChamF.t  ,TCChamF.th);
 TCChamF.epslp(j,:)   = csqfil(TCChamF.epsh(j,:)   ,TCChamF.th ,TCChamF.th,3);
 TCChamF.rhoh(j,:)    = csqfil(TCChamF.rho(j,:)    ,TCChamF.t  ,TCChamF.th);
 TCChamF.rholp(j,:)   = csqfil(TCChamF.rhoh(j,:)   ,TCChamF.th ,TCChamF.th,3);
end%for
TCChamF.spice   = linearSpice(TCChamF.Tc-TCChamF.Tcmean,TCChamF.Sa-TCChamF.Samean,TCChamF.alpha,TCChamF.beta);
TCChamF.spiceh  = linearSpice(TCChamF.Tch-TCChamF.Tcmean,TCChamF.Sah-TCChamF.Samean,TCChamF.alpha,TCChamF.beta);
TCChamF.spicelp = linearSpice(TCChamF.Tclp-TCChamF.Tcmean,TCChamF.Salp-TCChamF.Samean,TCChamF.alpha,TCChamF.beta);
%
save([fileloc filename "filtered.mat"],"TCChamF");
