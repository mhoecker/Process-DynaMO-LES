function [tdag,zdag,tkeavg,tkePTra,tkeAdve,BuoyPr,tkeSGTr,ShPr,StDr,Diss] = DAGtkeprofiles(dagnc,trange,zrange)
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
 if nargin()>2
  dagzidx = inclusiverange(zdag,zrange);
 else
  dagzidx = 1:length(zdag);
 end%if
 tdag     = squeeze(dag{'time'}(dagtidx));
 zdag     = -squeeze(dag{'zzu'}(dagzidx));
 tkeavg   = squeeze(dag{'tke_ave'}(dagtidx,dagzidx,1,1));
 tkeAdve  = squeeze(dag{'a_ave'}(dagtidx,dagzidx,1,1));
 BuoyPr  = squeeze(dag{'b_ave'}(dagtidx,dagzidx,1,1));
 tkeSGTr  = squeeze(dag{'sg_ave'}(dagtidx,dagzidx,1,1));
 ShPr  = -squeeze(dag{'sp_ave'}(dagtidx,dagzidx,1,1));
 #
 tkePTra  = squeeze(dag{'p_ave'}(dagtidx,dagzidx,1,1));
 badStDr  = squeeze(dag{'sd_ave'}(dagtidx,dagzidx,1,1));
 #
 S0  = squeeze(dag{'S_0'}(dagtidx,1,1,1));
 waveL  = squeeze(dag{'wave_l'}(dagtidx,1,1,1));
 [Sz,dUsdz] = StokesAtDepth(S0,waveL,zdag);
 wave_a  = 2*pi*squeeze(dag{'w_angle'}(dagtidx,1,1,1))/180;
 uwave  = squeeze(dag{'uw_ave'}(dagtidx,dagzidx,1,1));
 vwave  = squeeze(dag{'vw_ave'}(dagtidx,dagzidx,1,1));
 StDr  = (uwave.*cos(wave_a)+vwave.*sin(wave_a)).*dUsdz;
 #
 tkePTra  = tkePTra-badStDr+StDr;
 Diss  = squeeze(dag{'disp_ave'}(dagtidx,dagzidx,1,1));
 ncclose(dag);
end%function
