function momflux(dagnc,bcdat,outdir)
 abrev = "momflux";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [0,24*3600*(tfsim-t0sim)];
 zrange = sort([0,-dsim]);
 # Extract surface fluxes
 [tsfx,stress,p,Jh,wdir,sst,sal,SolarNet] = DAGsfcflux(dagnc,bcdat,(trange-t0sim)*24*3600);
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
 [zzwu,ddzzwu] = ddzinterp(-dagvar3.zzw,-dagvar1.zzu,3);
 % Calculate Mixed Layer Depth
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,trange,zrange);
 [MLD,MLI]=getMLD(Savgdag,Tavgdag,zdag);
 [MLD2,MLI2]=getMLD(Savgdag,Tavgdag,zdag,.1);
 % zdag is equal to zzu
 %
 dudt = (ddt*dagvar1.u_ave)';
 ReyFlx = zzwu*dagvar3.uw_ave';
 idx0 = find(abs(dagvar1.zzu)==min(abs(dagvar1.zzu)));
 ReyFlx(idx0,:)=0;
 MLflx = 0*MLI;
 MLflx2 = 0*MLI;
 for i=1:length(MLI)
  MLflx(i) = ReyFlx(MLI(i),i);
  MLflx2(i) = ReyFlx(MLI2(i),i);
 end%for
 ReyFlxDiv = -(dagvar3.uw_ave*ddzzwu')';
 diff = (dagvar1.km_ave.*(dagvar1.u_ave*dsqdzzu')+(dagvar1.km_ave*ddzzu').*(dagvar1.u_ave*ddzzu'))';
 rem = dudt-ReyFlxDiv-diff;
 %
 binarray(t0sim+dagvar2.time'/(24*3600),dagvar2.ustr_t',[dir.dat abrev "ustr.dat"]);
 binarray(t0sim+tdag'/(24*3600),[MLD,MLflx]',[dir.dat abrev "ML.dat"]);
 binarray(t0sim+tdag'/(24*3600),[MLD2,MLflx2]',[dir.dat abrev "ML2.dat"]);
 binmatrix(t0sim+dagvar3.time'/(24*3600),-dagvar1.zzu',ReyFlxDiv,[dir.dat abrev "duwdz.dat"]);
 binmatrix(t0sim+dagvar3.time'/(24*3600),-dagvar1.zzu',ReyFlx,[dir.dat abrev "uw.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',dagvar1.u_ave',[dir.dat abrev "u_ave.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',dudt,[dir.dat abrev "dudt.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',diff,[dir.dat abrev "ddzkmddzu.dat"]);
 binmatrix(t0sim+dagvar1.time'/(24*3600),-dagvar1.zzu',rem,[dir.dat abrev "rem.dat"]);
 unix(["gnuplot " limitsfile " " dir.script abrev ".plt"]);
end#function
