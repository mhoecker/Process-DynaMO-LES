function [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss,badStDr,badPTra,Szdag,fave] = DAGtkeprofiles(dagnc,trange,zrange)
 % Extract diagnostic profiles
 dag      = netcdf(dagnc,'r');
 tdag     = squeeze(dag{'time'}(:));
 if nargin()>1
  dagtidx = inclusiverange(tdag,trange);
 else
  dagtidx = 1:length(tdag);
 end%if
 % restict depth range
 zdag     = -squeeze(dag{'zzu'}(:));
 zwdag     = -squeeze(dag{'zzw'}(:));
 if nargin()>2
  dagzidx = inclusiverange(zdag,zrange);
 else
  dagzidx = 1:length(zdag);
 end%if
 tdag     = squeeze(dag{'time'}(dagtidx));
 zdag     = -squeeze(dag{'zzu'}(dagzidx));
 zwdag     = -squeeze(dag{'zzw'}(dagzidx));
 tkeavg   = squeeze(dag{'tke_ave'}(dagtidx,dagzidx,1,1));
 tkeAdve  = squeeze(dag{'a_ave'}(dagtidx,dagzidx,1,1));
 BuoyPr  = squeeze(dag{'b_ave'}(dagtidx,dagzidx,1,1));
 tkeSGTr  = squeeze(dag{'sg_ave'}(dagtidx,dagzidx,1,1));
 ShPr  = -squeeze(dag{'sp_ave'}(dagtidx,dagzidx,1,1));
 #
 badPTra  = squeeze(dag{'p_ave'}(dagtidx,dagzidx,1,1));
 badStDr  = squeeze(dag{'sd_ave'}(dagtidx,dagzidx,1,1));
 #
 S0  = squeeze(dag{'S_0'}(dagtidx,1,1,1));
 waveL  = squeeze(dag{'wave_l'}(dagtidx,1,1,1));
 [Sz,dUsdz] = StokesAtDepth(S0,waveL,zwdag');
 wave_a  = 2*pi*squeeze(dag{'w_angle'}(dagtidx,1,1,1))/180;
 uwave  = squeeze(dag{'uw_ave'}(dagtidx,dagzidx,1,1));
 vwave  = squeeze(dag{'vw_ave'}(dagtidx,dagzidx,1,1));
 StDr  = (uwave.*cos(wave_a)+vwave.*sin(wave_a)).*dUsdz;
 zidx = find(zdag==0,1);
 StDr = interp1(zwdag,StDr',zdag,"extrap")';
 [Szdag,dUsdzdag] = StokesAtDepth(S0,waveL,zdag');
 if(length(zidx)>0)
  StDr(:,zidx)=0;
 end%if
 fave = squeeze(dag{'uf_ave'}(dagtidx,dagzidx,1,1));
 fave = fave+squeeze(dag{'vf_ave'}(dagtidx,dagzidx,1,1));
 fave = fave+squeeze(dag{'wf_ave'}(dagtidx,dagzidx,1,1));
 #
 tkePTra  = badPTra+badStDr-StDr;
 Diss  = squeeze(dag{'disp_ave'}(dagtidx,dagzidx,1,1));
 # Correct for convolved terms
 tkeAdve = tkeAdve-ShPr;
 tkeSGTr = tkeSGTr-Diss;
 ncclose(dag);
end%function
