% figure Ri
function figRi(sfxnc,outdir)
 [useoctplot,t0sim,dsim,tfsim]=plotparam(outdir);
 trange = [t0sim-4,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange);
 # Calulatwe the Driven Richarson number
 [Ri,Jb]  = surfaceRi(stress,Jh,sst,sal);
 figure(1)
 subplot(3,1,1)
 plot(tsfx,Jb)
 axis([trange,0,max(Jb)])
 subplot(3,1,2)
 semilogy(tsfx,.25*stress.^2)
 axis([trange])
 subplot(3,1,3)
 plot(tsfx,sign(4*Ri)+sign(4*Ri-1))
 axis([trange,-2.5,2.5])
end%function
