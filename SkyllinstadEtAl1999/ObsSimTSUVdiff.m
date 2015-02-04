function  ObsSimTSUVdiff(chmnc,adcpnc,sfxnc,dagnc,outdir)
 %figure 3
 % difference of Temperature, Salinity, and Velocity
 % between observations and model.
 abrev = "ObsSim";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir]=plotparam(outdir,abrev);
 trange = [t0sim,tfsim];
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
 % Calculate Mixed Layer Depth
 [MLD,MLI,drho,rho]=getMLD(Savgdag,Tavgdag,zdag);
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
 % Calculate Mixed Layer Depth
 [MLDchm,MLIchm,drhochm,rhochm]=getMLD(Schmi',Tchmi',zdag);
 # Calculate the difference
 Tdiff = Tchmi'-Tavgdag;
 Sdiff = Schmi'-Savgdag;
 udiff = uadcpi'-uavgdag;
 vdiff = vadcpi'-vavgdag;
 # calculate the dz
 dz = trapdiff(zdag)';
 # Fill NaN with zeros for summation
 vdnonan = vdiff.*dz;
 vdnonan(find(isnan(vdiff)))=0;
# vdnonan = isnan(vdiff);
 vdsum = backcumsum(vdnonan,2);
 udnonan = udiff.*dz;
 udnonan(find(isnan(udiff)))=0;
# udnonan = isnan(udiff);
 udsum = backcumsum(udnonan,2);
 Tdnonan = Tdiff.*dz;
 Tdnonan(find(isnan(Tdiff)))=0;
# Tdnonan = isnan(Tdiff);
 Tdsum = backcumsum(Tdnonan,2);
 Sdnonan = Sdiff.*dz;
 Sdnonan(find(isnan(Sdiff)))=0;
# Sdnonan = isnan(Sdiff);
 Sdsum = backcumsum(Sdnonan,2);
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
  binmatrix(tdag',zdag',Tdiff',[dir.dat abrev "Tdiff.dat"]);
  binmatrix(tdag',zdag',Sdiff',[dir.dat abrev "Sdiff.dat"]);
  binmatrix(tdag',zdag',Tdsum',[dir.dat abrev "Tdsum.dat"]);
  binmatrix(tdag',zdag',Sdsum',[dir.dat abrev "Sdsum.dat"]);
  # save U,V profiles
  binmatrix(tdag',zdag',udiff',[dir.dat abrev "udiff.dat"]);
  binmatrix(tdag',zdag',vdiff',[dir.dat abrev "vdiff.dat"]);
  binmatrix(tdag',zdag',udsum',[dir.dat abrev "udsum.dat"]);
  binmatrix(tdag',zdag',vdsum',[dir.dat abrev "vdsum.dat"]);
  # Mixed Layer Depth
  binarray(tdag',[MLD]',[dir.dat abrev "ML.dat"])
  binarray(tdag',[MLDchm]',[dir.dat abrev "MLchm.dat"])
  #Plot
  unix(["gnuplot " limitsfile " " dir.script abrev "TSUVdiff.plt"]);
  unix(["gnuplot " limitsfile " " dir.script abrev "TSUVdsum.plt"]);
 end%if
end%function
