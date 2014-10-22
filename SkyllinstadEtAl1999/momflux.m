function momflux(dagfile,sfxnc,outdir,wavespecHL)
 abrev = "momflox";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 trange = [t0sim,tfsim];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange,wavespecHL);
 # Extract parameters needed for momentum flux
 # reynolds stress
 # mean velocity profile (for shear)
 # mean diffusivity
 field1 = ['time';'zzu'];
 dagvar1 = dagvars(dagnc,field1,trange,zrange);
 field2 = ['time';'zzw'];
 dagvar1 = dagvars(dagnc,field2,trange,zrange);
 field3 = ['time';'z'];
 dagvar3 = dagvars(dagnc,field3,trange,zrange);
 # need to calculate d/dz and d/dt of mean u and v
 #
end#function
