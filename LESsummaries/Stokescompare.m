#Various ways of calculating stokes production of tke
#dagnc ='/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone7/dyntest-b_dag.nc'

dagnc = '/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone6/d1024_1_dag.nc'

[tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss,badStDr,badPTra,Sz] = DAGtkeprofiles(dagnc);
#
# calculate the sum of weights for the stokes distribution
Sweight = sum(Sz,2)./sum(diff(zdag));
#Wave Shear . Reynolds stress
#StDr
zavStDr = sum(StDr,2)./sum(diff(zdag));
#In code
#badStDr
zavbadStDr = sum(badStDr,2)./sum(diff(zdag));
resStDr = (zavbadStDr./Sweight).*Sz;
#Pressure Transport
#badPTra
zavbadPTra = sum(badPTra,2)./sum(diff(zdag));
#
# Gridded co-ordinates
[tt,zz] = meshgrid(tdag/(3600*24),-log(-zdag));
zmax = max(max(zz));
zmin = min(min(zz));
zrange = [zmin,zmax];
tmax = max(max(tt));
tmin = min(min(tt));
trange = [tmin,tmax];
tzrange = [trange,zrange];
cmax = max([max(max(StDr)),max(max(badStDr)),max(max(badPTra))]);
cmin = min([min(min(StDr)),min(min(badStDr)),min(min(badPTra))]);
crange = [cmin,cmax]/	4;
figure(1)
subplot(4,1,1)
pcolor(tt,zz,StDr'); axis(tzrange); caxis(crange);shading flat; colorbar; title("<u'w'>dU_s/dz"); ylabel("log(depth)");
subplot(4,1,2)
pcolor(tt,zz,badStDr'); axis(tzrange); caxis(crange); shading flat; colorbar; title("Stokes Production in model"); ylabel("log(depth)");
subplot(4,1,3)
pcolor(tt,zz,resStDr'); axis(tzrange); caxis(crange); shading flat; colorbar; title("Stokes Production in model, redistributed"); ylabel("log(depth)");
subplot(4,1,4)
pcolor(tt,zz,badPTra'); axis(tzrange); caxis(crange); shading flat; colorbar; title("Pressure transport in model"); ylabel("log(depth)");
xlabel("time (days)")
figure(2)
subplot(1,1,1)
plot(tdag,zavStDr,";<u'w'>dU_s/dz;",tdag,zavbadStDr,";Model Stokes Prod.;",tdag,zavbadPTra,";model Pressure Transport;"); axis([trange])
