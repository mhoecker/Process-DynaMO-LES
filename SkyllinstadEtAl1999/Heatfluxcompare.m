function Heatfluxcompare(dagfile,outdir)
#
#
# function Heatfluxcompare(dagfile,z,outfile)
# dagfile = source diagnostic file (netCDF)
# outloc = location of output data (binary array?)
# z = array of depths desired
 findgsw;
 g = gsw_grav(0);
 abrev = "jflxcomp";
 outfile = [outdir abrev];
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 trange = [t0sim,tfsim];
 trange = (trange-t0sim)*24*3600;
 zrange = [0,-dsim];
 #
 # get surface fields
 surfacefields  = ['time';'z'];
 #co-ordinates
 surfacefields  = [surfacefields ; 'hf_top';'lhf_top';'q';'rain'];
 #Surface Heat Flux
 surfacefields  = [surfacefields ; 'swf_top'];
 # Penatrating Heat flux
 surfacefields  = [surfacefields ; 'u_star';'wave_l';'S_0'];
 # Stokes Drift Parameters
 #
 surfacevars = dagvars(dagfile,surfacefields,trange,zrange);
 #
 # calculate time in days
 t = t0sim+surfacevars.time./(24*3600);
 #
 # Save Surface forcing
 Jhf0 = surfacevars.hf_top+surfacevars.lhf_top;
 #
 internalfields = ['time';'zzw';'hf_ave';'wt_ave'];
 TSfields       = ['time';'zzu';'s_ave';'t_ave'];
 internalvars = dagvars(dagfile,internalfields,trange,zrange);
 TSvars = dagvars(dagfile,TSfields,trange,zrange);
 Z = -internalvars.zzw';
 ZTS = -TSvars.zzu';
 # Calculate the scale of Surface Buoyancy Flux
 # from  Langmuir Turbulence
 SBusq = surfacevars.u_star.^2;
 Sz = StokesAtDepth(surfacevars.S_0,surfacevars.wave_l,Z);
 SBusq = Sz.*SBusq;
 SBusq = 2.*pi.*SBusq./surfacevars.wave_l;
 #
 # interpolate T and S onto zzu
 S = -ones(size(Z)).*ones(size(t));
 T = S;
 for i=1:length(t)
  S(i,:) = interp1(ZTS,TSvars.s_ave(i,:),Z,'linear','extrap');
  T(i,:) = interp1(ZTS,TSvars.t_ave(i,:),Z,'linear','extrap');
 end%for
 # get thermodynamic properties
 P = gsw_p_from_z(Z,0);
 alpha = gsw_alpha(S,T,P);
 Cp = gsw_cp_t_exact(S,T,P);
 rho = gsw_rho(S,T,0);
 drhozs = 1000.*(rho.-rho(:,end));
 Tr = swradflux(Z);
 JswT = [Tr.*surfacevars.swf_top];
 JswA = [(1-Tr).*surfacevars.swf_top];
 Jsgs = rho.*Cp.*[internalvars.hf_ave];
 Jwt  = rho.*Cp.*[internalvars.wt_ave];
 Ho = (-alpha.*g.*(Jhf0+JswA)./(rho.*Cp.*SBusq));
 #useoctplot = 1;
 if(useoctplot==1)
  #grids for octave pcolor plotting
  zz = Z.*ones(size(t));
  tt = t.*ones(size(Z));
  #
  figure(1)
  pcolor(tt,zz,Ho)
  caxis([-2,2]);
  title("Honecker Number")
  colorbar
  shading flat
  print([outdir abrev "Ho.png"],"-dpng")
 else
  binarray(t',[surfacevars.hf_top,surfacevars.lhf_top,surfacevars.q,surfacevars.swf_top,surfacevars.rain]',[outfile "surf.dat"]);
  binmatrix(t',Z',Jsgs',[outfile "Jsgs.dat"])
  binmatrix(t',Z',Jwt',[outfile "Jwt.dat"])
  binmatrix(t',Z',JswA',[outfile "JswA.dat"])
  binmatrix(t',Z',JswT',[outfile "JswT.dat"])
  binmatrix(t',Z',Ho',[outfile "Ho.dat"])
  binmatrix(t',Z',drhozs',[outfile "drhosz.dat"])
  unix(["gnuplot " limitsfile " " scriptdir abrev "tab.plt"]);
  unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
end%if
end%function

