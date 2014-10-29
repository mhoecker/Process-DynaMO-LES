function momflux(dagnc,sfxnc,outdir,wavespecHL)
 abrev = "momflux";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 trange = [0,24*3600*(tfsim-t0sim)]
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
 ddzzu = ddz(dagvar1.zzu);
 ddzzw = ddz(dagvar3.zzw);
 #
 dudt = (ddt*dagvar1.u_ave)';
 ReyFlxDiv = -(dagvar3.uw_ave*ddzzw)';
 diff = (dagvar1.km_ave.*(dagvar1.u_ave*ddzzu))';
 #duwdzzw = dagvar3.uw_ave*ddzzw;
 #subplot(3,1,1)
 #pcolor(dagvar1.u_ave'); shading flat
 subplot(3,1,1)
 pcolor(dudt); caxis([-.00005,.00005]); shading flat; title("du/dt")
 subplot(3,1,2)
 pcolor(ReyFlxDiv); caxis([-.00005,.00005]); shading flat; title("d/dz(u'w')")
 subplot(3,1,3)
 pcolor(diff); caxis([-.00005,.00005]); shading flat; title("d/dz(km du/dz)")
 #plot(t0sim+dagvar2.time/(24*3600),dagvar2.ustr_t); axis(t0sim+trange/(24*3600))
 binmatrix(t0sim+dagvar3.time'/(24*3600),-dagvar3.zzw',ReyFlxDiv,[outdir abrev "duwdz.dat"])
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',dudt,[outdir abrev "dudt.dat"])
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',diff,[outdir abrev "ddzkmddzu.dat"])
 unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
end#function
