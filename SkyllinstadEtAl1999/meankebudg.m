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
 zout = -zzwvars.zzw;
 t = zzwvars.time;
 dzout = ddz(zout);
 dtmatrix = ddz(t);
 zzu = -zzuvars.zzu;
 mke = interp1(zzu,zzuvars.KE_ave',zout,"extrap");
 uav = interp1(zzu,zzuvars.u_ave',zout,"extrap");
 vav = interp1(zzu,zzuvars.v_ave',zout,"extrap");
 SP = zzwvars.uw_ave'.*(dzout*uav)+zzwvars.vw_ave'.*(dzout*vav);
 uw = zzwvars.uw_ave;
 vw = zzwvars.vw_ave;
 mkeflux = (uav.*uw'+vav.*vw');
 mkefdiv = -dzout*mkeflux;
 dmkedt = (dtmatrix*mke')';
 sfcidx = find(zout==0);
 work = uav(sfcidx,:).*zvars.ustr_t'+vav(sfcidx,:).*zvars.vstr_t';
 [tt,zz] = meshgrid(t/(24*3600),zout);
 ranges = [0,1,-.005,.005];
 pcranges = [ranges(1:2),-80,0];
 crange = [-.00001,.00001];
 subplot(4,1,1)
 pcolor(tt,zz,dmkedt); shading flat
 axis(pcranges); caxis([crange])
 subplot(4,1,2)
 mean(mean(SP))
 pcolor(tt,zz,SP); shading flat
 axis(pcranges); caxis([crange])
 subplot(4,1,3)
 pcolor(tt,zz,mkefdiv); shading flat
 axis(pcranges); caxis([crange])
 %axis(ranges)
 subplot(4,1,4)
 plot(t/(24*3600),work)
 %axis(ranges)
end%function
