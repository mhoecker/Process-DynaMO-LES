function Heatfluxcompare(dagfile,sfxfile,outdir,wavespecHL)
#
#
# function Heatfluxcompare(dagfile,z,outfile)
# dagfile = source diagnostic file (netCDF)
# outloc = location of output data (binary array?)
# z = array of depths desired
 abrev = "jflxcomp";
 outfile = [outdir abrev];
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir]=plotparam(outdir,abrev);
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
 #
 # interpolate T and S onto zzu
 S = -ones(size(Z)).*ones(size(t));
 T = S;
 for i=1:length(t)
  S(i,:) = interp1(ZTS,TSvars.s_ave(i,:),Z,'linear','extrap');
  T(i,:) = interp1(ZTS,TSvars.t_ave(i,:),Z,'linear','extrap');
 end%for
 # get thermodynamic properties
 findgsw;
 P = gsw_p_from_z(Z,0);
 Cp = gsw_cp_t_exact(S,T,P);
 rho = gsw_rho(S,T,0);
 drhozs = 1000.*(rho.-min(rho,[],2));
 Tr = swradflux(Z);
 JswT = [Tr.*surfacevars.swf_top];
 JswA = [(1-Tr).*surfacevars.swf_top];
 Jsgs = rho.*Cp.*[internalvars.hf_ave];
 Jwt  = rho.*Cp.*[internalvars.wt_ave];
 # Get Honikker # from Observations
 [tsfx,stress,p,Jh,wdir,sst,SalTSG,SolarNet,cp,sigH,HoT,HoS,LaBflx,JhBflx,SaBflx] = DAGsfcflux(dagfile,(trange-t0sim)*24*3600);
 tsfx=t0sim+tsfx./(24*3600);
 Hosfx = HoT+HoS;
 Ho = interp1(Hosfx,tsfx,t);
 if(useoctplot==1)
  # Rescale
  scalefactor = .1
  Ho = inf2finite(Ho,scalefactor);
  HoS = inf2finite(HoS,scalefactor);
  HoT = inf2finite(HoT,scalefactor);
  #
  figure(1)
  plot(t,Ho,tsfx,HoT,tsfx,HoS)
  axis([min(tsfx),max(tsfx),-1,1])
  title("Honecker Number")
  shading flat
  print([outdir abrev "Ho.png"],"-dpng")
 else
  binarray(tsfx',[Jh,p]',[outfile "surf.dat"]);
#  binmatrix(t',Z',Jsgs',[outfile "Jsgs.dat"])
#  binmatrix(t',Z',Jwt',[outfile "Jwt.dat"])
#  binmatrix(t',Z',JswA',[outfile "JswA.dat"])
#  binmatrix(t',Z',JswT',[outfile "JswT.dat"])
  binarray(tsfx',[HoT,HoS,Hosfx]',[outfile "HoTS.dat"]);
  binarray(tsfx',[LaBflx,JhBflx,SaBflx]',[outfile "Bflx.dat"]);
  binmatrix(t',Z',drhozs',[outfile "drhosz.dat"]);
  unix(["gnuplot " limitsfile " " scriptdir abrev "tab.plt"]);
  unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"]);
end%if
end%function

function y = inf2finite(x,x0)
 y = x./(x0+abs(x));
end%function
