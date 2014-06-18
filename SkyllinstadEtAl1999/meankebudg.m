function meankebudg(dagnc,outdir)
 if nargin<1
  dagnc = "/media/mhoecker/8982053a-3b0f-494e-84a1-98cdce5e67d9/Dynamo/output/yellowstone6/d1024_1_dag.nc";
 end%if
 zfield = ["time";"z";"ustr_t";"vstr_t"];
 zzufield = ["time";"zzu";"KE_ave";"u_ave";"uwdu_ave";"v_ave";"vwdv_ave"];
 zzwfield = ["time";"zzw";"uw_ave";"vw_ave"];
 zvars = dagvars(dagnc,zfield);
 zzuvars = dagvars(dagnc,zzufield);
 zzwvars = dagvars(dagnc,zzwfield);
 zout = zzwvars.zzw;
 t = zzwvars.time;
 dzout = ddz(zout);
 dtmatrix = ddz(t);
 zzu = zzuvars.zzu;
 mke = interp1(zzu,zzuvars.KE_ave',zout,"extrap");
 uav = interp1(zzu,zzuvars.u_ave',zout,"extrap");
 vav = interp1(zzu,zzuvars.v_ave',zout,"extrap");
 SPu = interp1(zzu,zzuvars.uwdu_ave',zout,"extrap");
 SPv = interp1(zzu,zzuvars.vwdv_ave',zout,"extrap");
 SP = SPu+SPv;
 uw = zzwvars.uw_ave;
 vw = zzwvars.vw_ave;
 mkeflux = (uav.*uw'+vav.*vw');
 mkefdiv = dzout*mkeflux;
 dmkedt = (dtmatrix*mke')';
 sfcidx = find(zout==0);
 work = uav(sfcidx,:).*zvars.ustr_t'+vav(sfcidx,:).*zvars.vstr_t';
 ranges = [0,24*3600,-.005,.005];
 subplot(4,1,1)
 plot(t,sum(dmkedt))
 axis(ranges)
 subplot(4,1,2)
 plot(t,sum(SP))
 axis(ranges)
 subplot(4,1,3)
 plot(t,work)
 %axis(ranges)
 subplot(4,1,4)
 plot(t,sum(dmkedt)-work)
 %axis(ranges)
end%function
