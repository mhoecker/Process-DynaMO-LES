function  fig3diff(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %figure 3
 % difference of Temperature, Salinity, and Velocity
 % between observations and model.
 [useoctplot,t0sim,dsim] = plotparam(outdir);
 trange = [t0sim,t0sim+1];
 zrange = sort([0,-dsim]);
 # Extract Chameleon data
 [tchm,zchm,epschm,Tchm,Schm]=ChameleonProfiles(chmnc,trange,zrange);
 # Convert Chameleon Salinity from absolute to practical
 findgsw; # Check to make sure Gibbs Sea Water is in the path
 Pchm = gsw_p_from_z(zchm,0);
 Schm = gsw_SP_from_SA(Schm,Pchm,80.5,0);
 # extract ADCP data
 [tadcp,zadcp,ulpadcp,vlpadcp] = ADCPprofiles(adcpnc,trange,zrange);
 # Extract simulation data
 [tdag,zdag,Tavgdag,Savgdag] = DAGTSprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 [tdag,zdag,uavgdag,vavgdag] = DAGvelprofiles(dagnc,(trange-t0sim)*24*3600,zrange);
 # convert to yearday
 tdag = t0sim+tdag/(24*3600);
 # interpolate observations onto the computational grid
 # This will be slow!
 # Make co-ordinate 2-D arrays from lists
 [tt,zz] = meshgrid(tdag,zdag);
 Tchmi=interp2(zchm,tchm,Tchm,zz,tt);
 Schmi=interp2(zchm,tchm,Schm,zz,tt);
 uadcpi=interp2(zadcp,tadcp,ulpadcp,zz,tt);
 vadcpi=interp2(zadcp,tadcp,vlpadcp,zz,tt);
 # Calculate the difference
 Tdiff = Tchmi'-Tavgdag;
 Sdiff = Schmi'-Savgdag;
 udiff = uadcpi'-uavgdag;
 vdiff = vadcpi'-vavgdag;
 if(useoctplot==1)
  # Picture time!
  figure(3)
  subplot(4,1,1)
  pcolor(tt,zz,Tdiff')
  shading flat
  axis([trange])
  subplot(4,1,2)
  pcolor(tt,zz,Sdiff')
  shading flat
  subplot(4,1,3)
  pcolor(tt,zz,udiff')
  shading flat
  axis([trange])
  subplot(4,1,4)
  pcolor(tt,zz,vdiff')
  shading flat
  print([outdir 'fig3diff.png'],'-dpng')
 else
  # Save T,S profiles
  binmatrix(tdag',zdag',Tdiff',[outdir "fig3Tdiff.dat"]);
  binmatrix(tdag',zdag',Sdiff',[outdir "fig3Sdiff.dat"]);
  # save U,V profiles
  binmatrix(tdag',zdag',udiff',[outdir "fig3udiff.dat"]);
  binmatrix(tdag',zdag',vdiff',[outdir "fig3vdiff.dat"]);
  unix("gnuplot /home/mhoecker/work/Dynamo/octavescripts/SkyllinstadEtAl1999/fig3diff.plt");
 end%if
end%function