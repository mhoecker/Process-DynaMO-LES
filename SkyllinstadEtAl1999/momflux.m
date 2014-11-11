function momflux(dagnc,sfxnc,outdir,wavespecHL)
 abrev = "momflux";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 trange = [0,24*3600*(tfsim-t0sim)];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = surfaceflux(sfxnc,trange,wavespecHL);
 # Extract parameters needed for momentum flux
 # reynolds stress
 # mean velocity profile (for shear)
 # mean diffusivity
 field1 = ['time';'zzu';'u_ave';'v_ave';'km_ave'];
 dagvar1 = dagvars(dagnc,field1,trange);
 field2 = ['time';'z';'ustr_t';'vstr_t'];
 dagvar2 = dagvars(dagnc,field2,trange);
 field3 = ['time';'zzw';'uw_ave';'vw_ave'];
 dagvar3 = dagvars(dagnc,field3,trange);
 # need to calculate d/dz and d/dt of mean u and v
 #
 ddt = ddz(dagvar1.time);
 [ddzzu,dsqdzzu] = ddz(-dagvar1.zzu,8);
 [zzwu,ddzzwu] = ddzinterp(-dagvar3.zzw,-dagvar1.zzu,2);
 %uwonzzu = dagvar3.uw_ave*zzwu';
 %idx0 = find(dagvar1.zzu==0);
 %uwonzzu(:,idx0)=0;
 #
 dudt = (ddt*dagvar1.u_ave)';
 ReyFlxDiv = -(dagvar3.uw_ave*ddzzwu')';
 diff = (dagvar1.km_ave.*(dagvar1.u_ave*dsqdzzu')+(dagvar1.km_ave*ddzzu').*(dagvar1.u_ave*ddzzu'))';
 rem = dudt-ReyFlxDiv-diff;
 %
 binarray(t0sim+dagvar2.time'/(24*3600),dagvar2.ustr_t',[outdir abrev "ustr.dat"]);
 binmatrix(t0sim+dagvar3.time'/(24*3600),-dagvar1.zzu',ReyFlxDiv,[outdir abrev "duwdz.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',dudt,[outdir abrev "dudt.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',diff,[outdir abrev "ddzkmddzu.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',rem,[outdir abrev "rem.dat"]);
 unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
end#function
