# make a bunch of Initial conditions
MIMOCfitpath = "/home/mhoecker/work/Dynamo/plots/MIMOC/dat/tanhfits";
overalloutpath = "/home/mhoecker/work/Dynamo/output/CompareRuns/"
maxbadmonth = 2;
lons = [65,81,90,147,156,165,180,190];
% DYNAMO fluxes
  dynamo.JSW = [50,500];
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
  Tisbad = find(isnan(T(j,:)));
  Tisgood = find(~isnan(T(j,:)));
  T(j,Tisbad) = interp1(T(1,Tisgood),T(j,Tisgood),T(1,Tisbad));
  Sisbad = find(isnan(S(j,:)));
  Sisgood = find(~isnan(S(j,:)));
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
Tmean = Tmean/12;
Smean = Smean/12;
idxgood = find(nodat<maxbadmonth);
Tmean = Tmean(:,idxgood);
Smean = Smean(:,idxgood);
findgsw;
g = gsw_grav(0);
Pbar   = gsw_p_from_z((Tmean(3,:)+Smean(3,:))/2,0);
rhobar = gsw_rho(Smean(5,:),Tmean(5,:),Pbar);
#Tmean = [Tmean,Tmean.-[360,0,0,0,0,0]'];
#Smean = [Smean,Smean.-[360,0,0,0,0,0]'];
subplot(3,1,1)
plot(Tmean(1,:),Tmean(3,:),"r.",Smean(1,:),Smean(3,:),"b.")
hold on
plot(Tmean(1,:),Tmean(3,:)+Tmean(4,:),"r--",Smean(1,:),Smean(3,:)+Smean(4,:),"b--")
plot(Tmean(1,:),Tmean(3,:)-Tmean(4,:),"r--",Smean(1,:),Smean(3,:)-Smean(4,:),"b--")
axis([50,370,-300,0])
xlabel("Longitude (deg)")
ylabel("Depth (m)")
hold off
subplot(3,1,2)
plot(Tmean(1,:),(g./rhobar).*Tmean(6,:)./Tmean(4,:),Smean(1,:),(g./rhobar).*Smean(6,:)./Smean(4,:))
axis([50,370])
xlabel("Longitude")
ylabel("Stratification (rad/s)^2")
subplot(3,1,3)
plot(Tmean(1,:),Tmean(6,:),Smean(1,:),Smean(6,:))
axis([50,370])
xlabel("Longitude")
ylabel("Density change (kg/m^3)")
Tparams = zeros(4,length(lons));
Sparams = zeros(4,length(lons));
badparam = interp1(T(1,:),nodat,lons)
for i=1:4
 Tparams(i,:) = interp1(Tmean(1,:),Tmean(i+1,:),lons);
 Sparams(i,:) = interp1(Smean(1,:),Smean(i+1,:),lons);
end%for
idxbadparam = find(badparam>maxbadmonth);
Tparams(:,idxbadparam) = NaN;
Sparams(:,idxbadparam) = NaN;
[lons',Tparams',NaN*lons',lons',Sparams']
for i=1:length(lons)
 outpath = [overalloutpath num2str(lons(i),"%005.1f")];
 makeICBCnetCDF([outpath "dynamo"],Sparams(:,i),Tparams(:,i),Sparams(:,i),dynamo)
 makeICBCnetCDF([outpath "TOGACOARE"],Sparams(:,i),Tparams(:,i),Sparams(:,i),togacoare)
end%for