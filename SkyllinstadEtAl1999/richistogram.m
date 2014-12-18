function [SPcontour,pc] = richistogram(filename,outdir)
 if(nargin<1)
 filename = "/home/mhoecker/work/Dynamo/output/yellowstone12/dyn1024flxn_s_dag.nc"
 end%if
 if(nargin<2)
 outdir = "/home/mhoecker/work/Dynamo/plots/y12/"
 end%if
 %
 abrev = "richistogram";
 [useoctplot,t0sim,dsim,tfsim,limitsfile,dir] = plotparam(outdir,abrev);
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
 % dag version file
 t = t0sim+squeeze(nc{'time'}(:))./(24*3600);
 Z = -squeeze(nc{'zzu'}(:));
 U = squeeze(nc{'u_ave'}(:));
 V = squeeze(nc{'v_ave'}(:));
 T = squeeze(nc{'t_ave'}(:));
 S = squeeze(nc{'s_ave'}(:));
 Zw = -squeeze(nc{'zzw'}(:));
 uw = interp1(Zw,squeeze(nc{'uw_ave'}(:))',Z)';
 vw = interp1(Zw,squeeze(nc{'vw_ave'}(:))',Z)';
 #set surface value to 0
 uw(:,end)=0;
 vw(:,end)=0;
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
 rho = gsw_rho(SA,CT,P*0);
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
 %
 binmatrix(frac,Z,Rirank' ,[dir.dat "Rirank.dat"]);
 binmatrix(frac,Z,phirank',[dir.dat "phirank.dat"]);
 binmatrix(frac,Z,Ssqrank',[dir.dat "Ssqrank.dat"]);
 binmatrix(frac,Z,Nsqrank',[dir.dat "Nsqrank.dat"]);
 binmatrix(frac,Z,SPrank' ,[dir.dat "SPrank.dat"]);
 binmatrix(frac,Z,RiSPrank' ,[dir.dat "RiSPrank.dat"]);
 binmatrix(frac,Z,phiSPrank' ,[dir.dat "phiSPrank.dat"]);
 binarray(flatfrac,[SPflat,Ssqflat,Riflat,phiflat,RiSPflat,phiSPflat]',[dir.dat "flat.dat"]);
 % Histograms cutoff
 SPbins = 200;
 NH = floor(Nflat./SPbins);
 HRi = [];
 HLRi = [];
 Hphi = [];
 Nh = ceil(sqrt(NH));
 phirange = linspace(0,1,Nh);
 Rirange = linspace(0,+1,Nh);
 LRirange = linspace(-5,7,Nh);
 LRiSPflat = real(log(RiSPflat))./log(2);
 SPcutoff = [];
 SPcutval = [];
 for i=0:(SPbins-1)
  SPcutoff = [SPcutoff,i./SPbins];
  NHi = floor(i*NH)+1;
  NHf = floor((i+1)*NH);
  SPcutval = [SPcutval,SPflat(NHi)];
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
 cntrfile = [dir.plt "SPcntr.plt"];
 fid = fopen(cntrfile,"w");
 fprintf(fid,"set contour base \n");
 fprintf(fid,"unset surface\n");
 fprintf(fid,"unset pm3d\n");
 fprintf(fid,"unset logscale\n");
 fprintf(fid,"set autoscale\n");
 pc = 75;
 j = ceil(pc*SPbins/100);
 SPcontour = [dir.dat "SPcntr" num2str(pc,"%03i") ".dat"];
 fprintf(fid,"set table '%s'\n",SPcontour);
 fprintf(fid,"set cntrparam level discrete %+2.6e\n",SPcutval(j));
 fprintf(fid,"splot '%s' binary matrix \n",[dir.dat "SP.dat"]);
 fprintf(fid,"unset contour\n");
 fprintf(fid,"unset table\n");
 fclose(fid);
 %
 % Do some sums of lower percentiel and upper percentile
 % distributions of Ri and phi
 %
 Hphi80p = sum(Hphi(:,j:end),2);
 Hphi80m = sum(Hphi(:,1:j-1),2);
 Nphi80 = sum(Hphi80p)+sum(Hphi80m);
 Hphi80p = Hphi80p./Nphi80;
 Hphi80m = Hphi80m./Nphi80;
 binarray(phirange,[Hphi80p,Hphi80m]',[dir.dat "HphiPM.dat"]);
 %
 HLRi80p = sum(HLRi(:,j:end),2);
 HLRi80m = sum(HLRi(:,1:j-1),2);
 NLRi80 = sum(HLRi80p)+sum(HLRi80m);
 HLRi80p = HLRi80p./NLRi80;
 HLRi80m = HLRi80m./NLRi80;
 binarray(LRirange,[HLRi80p,HLRi80m]',[dir.dat "HLRiPM.dat"]);
 binmatrix(t,Z,SP',[dir.dat "SP.dat"])
 binmatrix(phirange,SPcutoff,Hphi',[dir.dat "Hphi.dat"]);
 binmatrix(Rirange,SPcutoff,HRi',[dir.dat "HRi.dat"]);
 binmatrix(LRirange,SPcutoff,HLRi',[dir.dat "HLRi.dat"]);
 unix(["gnuplot " limitsfile " " dir.plt "SPcntr.plt"])
 SPpcval = ['SPpc = ' num2str(pc) '\n'];
 unix(['echo "' SPpcval '">>' limitsfile]);
 unix(["gnuplot " limitsfile " " dir.script abrev ".plt"])
end

