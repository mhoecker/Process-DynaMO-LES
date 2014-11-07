function [Z,Rirank,Ssqrank,Nsqrank,frac,phirank] = richistogram(filename,filetype)
 nargin
 if(nargin<1)
 filename = "/home/mhoecker/work/Dynamo/output/yellowstone10/dyn1024flx_s_dag.nc"
% filename = "/home/mhoecker/work/Dynamo/output/yellowstone6/d1024_1_dag.nc"
 filetype = "dag"
 end%if
 % load gibbs sea water
 findgsw;
 g = gsw_grav(0);
 % load raw data
 % resultant matricies are 2D
 % The first dimension is the z variable
 % the second dimension depends on the type of file
 %
 % filetype="dag" variables are A(Z,T)
 %
 % filetype="slb" variables are A(Z,X) or A(Z,Y)
 %
 % filetype="rst" variables are A(Z,XY)
 % where the horizontal indecies have been flattened
 %
 nc = netcdf(filename,'r');
 switch(filetype)
 %Load mean values from dag file
 % dimensions z,t
 % velocities u,v
 % state S,T
  case{"dag"}
   % dag version file
   t = squeeze(nc{'time'}(:))./3600;
   Z = -squeeze(nc{'zzu'}(:));
   U = squeeze(nc{'u_ave'}(:));
   V = squeeze(nc{'v_ave'}(:));
   T = squeeze(nc{'t_ave'}(:));
   S = squeeze(nc{'s_ave'}(:));
   Zw = -squeeze(nc{'zzw'}(:));
   uw = interp1(Zw,squeeze(nc{'uw_ave'}(:))',Z)';
   vw = interp1(Zw,squeeze(nc{'vw_ave'}(:))',Z)';
   uw(:,end)=0;
   vw(:,end)=0;
  case{"slb"}
   % slb version
   % calculate statistics for each slab in the horizontal dimension(s)
  case{"rst"}
   % rst version
   %Calculate statistics for each restart file in the horizontal dimensions
 end%switch
 ncclose(nc);
 % Calculate derivative matrix
 dzmat = ddz(Z,3);
 % Calculate pressure
 P = gsw_p_from_z(Z,0);
 % Calculate Absolute Salinity
 SA = gsw_SA_from_SP(S,P,0,0);
 % Calculate Conservative Temperature
 CT = gsw_CT_from_t(SA,T,P);
 % Calculate density(S,T,Z)
 rho = gsw_rho(SA,CT,P);
 % Calculate Buoyancy frquency
 Nsq = -g*(rho*dzmat')./rho;
 Nsqrank = sort(Nsq,1);
 % Calculate Shear and Shear Production
 Uz = U*dzmat';
 Vz = V*dzmat';
 SP = abs(uw.*Uz)+abs(vw.*Vz);
 [SPrank,SPidx] = sort(SP,1);
 [SPflat,SPflatidx] = sort(SP(:));
 Ssq = Uz.^2+Vz.^2;
 Ssqrank = sort(Ssq,1);
 Ssqflat = sort(Ssq(:));
 % Calculate Richardson number
 Ri = Nsq./Ssq;
 Rirank = sort(Ri,1);
 Riflat = sort(Ri(:));
 frac = (1:length(Rirank(:,1)))./length(Rirank(:,1));
 Nflat = length(Riflat(:,1));
 flatfrac = (1:Nflat)./Nflat;
 phirank = Rirank./(.25+abs(Rirank));
 phiflat = Riflat./(.25+abs(Riflat));
 RiSPrank = Ri(SPidx);
 phiSPrank = RiSPrank./(.25+abs(RiSPrank));
 RiSPflat = Ri(SPflatidx);
 phiSPflat = RiSPflat./(.25+abs(RiSPflat));
 %plot(phi(:,1),frac)
 datdir = "/home/mhoecker/tmp/";
 abrev = "richistogram";
 binmatrix(frac,Z,Rirank' ,[datdir "Rirank.dat"]);
 binmatrix(frac,Z,phirank',[datdir "phirank.dat"]);
 binmatrix(frac,Z,Ssqrank',[datdir "Ssqrank.dat"]);
 binmatrix(frac,Z,Nsqrank',[datdir "Nsqrank.dat"]);
 binmatrix(frac,Z,SPrank' ,[datdir "SPrank.dat"]);
 binmatrix(frac,Z,SPrank' ,[datdir "RiSPrank.dat"]);
 binmatrix(frac,Z,SPrank' ,[datdir "phiSPrank.dat"]);
 binarray(flatfrac,[SPflat,Ssqflat,Riflat,phiflat,RiSPflat,phiSPflat]',[datdir "flat.dat"]);
 % Histograms cutoff
 SPbins = 200;
 NH = floor(Nflat./SPbins);
 HRi = [];
 HLRi = [];
 Hphi = [];
 Nh = ceil(sqrt(NH));
 phirange = linspace(0,1,Nh);
 Rirange = linspace(0,1,Nh);
 LRirange = linspace(-5,7,Nh);
 LRiSPflat = real(log(RiSPflat))./log(2);
 semilogy(Rirange)
 SPcutoff = [];
 SPcutval = [];
 for i=0:(SPbins-1)
  SPcutoff = [SPcutoff,i./SPbins];
  NHi = floor(i*NH)+1;
  SPcutval = [SPcutval,SPflat(NHi)];
  NHf = floor((i+1)*NH);
  HRii = histc(RiSPflat(NHi:NHf),Rirange);
  HRii = HRii./sum(HRii);
  HRi = [HRi,HRii];
  HLRii = histc(LRiSPflat(NHi:NHf),LRirange);
  HLRii = HLRii./sum(HLRii);
  HLRi = [HLRi,HLRii];
  Hphii = histc(phiSPflat(NHi:NHf),phirange);
  Hphii = Hphii./sum(Hphii);
  Hphi = [Hphi,Hphii];
 end%for
 [useoctplot,t0sim,dsim,tfsim,limitsfile,scriptdir] = plotparam(datdir,datdir,abrev);
 cntrfile = [datdir "SPcntr.plt"];
 fid = fopen(cntrfile,"w");
 fprintf(fid,"set contour base \n");
 fprintf(fid,"unset surface\n");
 fprintf(fid,"unset pm3d\n");
 fprintf(fid,"unset logscale\n");
 fprintf(fid,"set autoscale\n");
 pc = [60,70,80,90,95,99];
 for i=1:length(pc)
  j = ceil(pc(i)*SPbins/100);
  fprintf(fid,"set table '%s'\n",[datdir "SPcntr" num2str(pc(i),"%03i") ".dat"]);
  fprintf(fid,"set cntrparam level discrete %+2.6e\n",SPcutval(j));
  fprintf(fid,"splot '%s' binary matrix \n",[datdir "SP.dat"]);
 end%for
 fprintf(fid,"unset contour\n");
 fprintf(fid,"unset table\n");
 fclose(fid);
 binmatrix(t,Z,SP',[datdir "SP.dat"])
 unix(["gnuplot " limitsfile " " datdir "SPcntr.plt"])
 binmatrix(phirange,SPcutoff,Hphi',[datdir "Hphi.dat"]);
 binmatrix(Rirange,SPcutoff,HRi',[datdir "HRi.dat"]);
 binmatrix(LRirange,SPcutoff,HLRi',[datdir "HLRi.dat"]);
 unix(["gnuplot " limitsfile " " scriptdir abrev ".plt"])
end

