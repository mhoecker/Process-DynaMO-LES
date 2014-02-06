function [zj] = Heatfluxcompare(dagfile,outdir)
#
#
# function Heatfluxcompare(dagfile,z,outfile)
# dagfile = source diagnostic file (netCDF)
# outloc = location of output data (binary array?)
# z = array of depths desired
 findgsw;
 g = gsw_grav(0);
 abrev = "Jflxcomp";
 outfile = [outdir abrev];
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,outdir,abrev);
 trange = [t0sim,tfsim];
 trange = (trange-t0sim)*24*3600;
 zrange = [0,-dsim];
 #
 # get surface fields
 surfacefields  = ['time';'z'];
 #co-ordinates
 surfacefields  = [surfacefields ; 'hf_top';'lhf_top'];
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
 # Calculate the scale of Surface Buoyancy Flux
 # from  Langmuir Turbulence
 SBusq = surfacevars.u_star.^2;
 SBusq = surfacevars.S_0.*SBusq;
 SBusq = 2.*pi.*SBusq./surfacevars.wave_l;
 #
 # Save Surface forcing
 Jhf0 = surfacevars.hf_top+surfacevars.lhf_top;
 binarray(t',[surfacevars.hf_top,surfacevars.lhf_top,Jhf0]',[outfile "surf.dat"])
 #
 internalfields = ['time';'zzw';'hf_ave';'wt_ave'];
 TSfields       = ['time';'zzu';'s_ave';'t_ave'];
 internalvars = dagvars(dagfile,internalfields,trange,zrange);
 TSvars = dagvars(dagfile,TSfields,trange,zrange);
 Z = -internalvars.zzw';
 ZTS = -TSvars.zzu';
 # interpolate T and S onto zzu
 #
 zz = Z.*ones(size(t));
 zzTS = ZTS.*ones(size(t));
 tt = t.*ones(size(Z));
 ttTS = t.*ones(size(ZTS));
 #
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
 rho = gsw_rho(S,T,P);
 Tr = swradflux(Z);
 JswT = [Tr.*surfacevars.swf_top];
 JswA = [(1-Tr).*surfacevars.swf_top];
 Jsgs = rho.*Cp.*[internalvars.hf_ave];
 Jwt  = rho.*Cp.*[internalvars.wt_ave];
 Ho = -alpha.*g.*(Jhf0+JswA)./(rho.*Cp.*SBusq);
 binmatrix(t',Z',Jsgs',[outfile "Jsgs.dat"])
 binmatrix(t',Z',Jwt',[outfile "Jwt.dat"])
 binmatrix(t',Z',JswA',[outfile "JswA.dat"])
 binmatrix(t',Z',JswT',[outfile "JswT.dat"])
 binmatrix(t',Z',Ho',[outfile "Ho.dat"])
end%function

