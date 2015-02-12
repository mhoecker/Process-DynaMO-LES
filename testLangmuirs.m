%test Langmuir routines
%
%
trange = [328,330];
dagfile = '/home/mhoecker/work/Dynamo/output/yellowstone14/dag.nc';
%
nc = netcdf(dagfile,'r');
%
t = 328+nc{'time'}(:)/(24*3600);
tidx = inclusiverange(t,trange);
t = 328+nc{'time'}(tidx)/(24*3600);
%
z = -nc{'zzu'}(:);
zw = -nc{'zzw'}(:);
zidx = inclusiverange(z);
z = -nc{'zzu'}(zidx);
%
T = squeeze(nc{'t_ave'}(tidx,zidx,1,1));
S = squeeze(nc{'s_ave'}(tidx,zidx,1,1));
ustar = squeeze(nc{'u_star'}(tidx,1,1,1));
ustokes = squeeze(nc{'S_0'}(tidx,1,1,1));
lambda = squeeze(nc{'wave_l'}(tidx,1,1,1));
wsq = squeeze(nc{'w2_ave'}(tidx,:,1,1));
%
%T = nc{'t_ave'}(tidx,zidx);
%S = nc{'s_ave'}(tidx,zidx);
ncclose(nc)
[MLD,MLI,drho,rho,DRHO]=getMLD(S,T,z);
[La_t,La_SL] = Langmuirnums(ustar,ustokes,lambda,abs(MLD));
La_SLgrid = linspace(min(La_SL),max(La_SL),128);
La_SLgridg1 = La_SLgrid>1;
La_SLgridl1 = La_SLgrid<=1;
wbyustargrid = (0.398+0.480*La_SLgrid.^(-4/3)).*La_SLgridl1;
wbyustargrid = wbyustargrid+(0.640+3.50*exp(-2.69*La_SLgrid)).*La_SLgridg1;
w2ML = ustokes*0;
for i=1:length(t)
 wsqML = interp1(zw,wsq(i,:),z(MLI(i):end));
 w2ML(i) = mean(wsqML);
end%for
wbyustar = w2ML./ustar.^2;

binarray(t',[wbyustar,La_SL,ustar,MLD,lambda,La_t]',"/home/mhoecker/work/Dynamo/plots/y14/dat/Langmuir.dat")

fontsize = 16;
idxgood = find((~isnan(wbyustar))&(MLD<-0.1)&(La_t>0.001));
wbystargood = wbyustar(idxgood);
x = [ones(length(idxgood),1),La_t(idxgood),log(-MLD(idxgood)./lambda(idxgood))];
b = inv(x'*x)*x'*wbystargood

figure(1)
subplot(1,1,1)
plot(t,La_t,";La_t;",t,La_SL,";La_{SL};")
xlabel("2011 yearday")
ylabel("Langmuir number")
print("/home/mhoecker/work/Dynamo/plots/y14/png/Langmuir1.png","-dpng",["-F:" num2str(fontsize,"%i")],"-S1536,1024")

figure(1)
subplot(1,1,1)
plot(t,wbyustar,";<w'w'>_{ML}/u^*u^*;")
xlabel("2011 yearday")
ylabel("<w'w'>/u*u*")
print("/home/mhoecker/work/Dynamo/plots/y14/png/Langmuir2.png","-dpng",["-F:" num2str(fontsize,"%i")],"-S1536,1024")

figure(1)
subplot(1,1,1)
plot(La_SLgrid,wbyustargrid,"-k;Harcourt (2008) fit;","linewidth",3,wbyustar,La_SL,"+k;data;")
axis([min(La_SL),max(La_SL),min(wbyustar),max(wbyustar)]);
xlabel("La_{SL}")
ylabel("<w'w'>/u*u*")
print("/home/mhoecker/work/Dynamo/plots/y14/png/Langmuir.png","-dpng",["-F:" num2str(fontsize,"%i")],"-S1600,1000","-tight")

figure(1)
subplot(2,2,1)
plot(log(La_t),log(wbyustar),"+k;data;")
axis([-3,2,-3,2])
xlabel("log(La_t)")
ylabel("log(<w'w'>/u*u*)")
subplot(2,2,2)
plot(log(wbyustar),log(-MLD./lambda),"+k;data;")
axis([-2,1,-2,1])
xlabel("log(<w'w'>/u*u*)")
ylabel("log(MLD/lambda)")
subplot(2,2,3)
plot(log(-MLD./lambda),log(La_t),"+k;data;")
axis([-2,1,-2,1])
ylabel("log(La_t)")
xlabel("log(MLD/lambda)")
subplot(2,2,4)
plot((La_t.^b(2)).*((-MLD./lambda).^b(3)),wbyustar,"+k;data;")
ylabel("log(<w'w'>/u*u*)")
print("/home/mhoecker/work/Dynamo/plots/y14/png/Langmuir3.png","-dpng",["-F:" num2str(fontsize,"%i")],"-S1600,1000","-tight")

