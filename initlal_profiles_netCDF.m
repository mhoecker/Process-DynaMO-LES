function [U, V, T, S, E] = initial_profile_netCDF(t,z,varfile,varname,tname,zname,zsign,order);
 # [U, V, T, S, E] = initial_profile_netCDF(tstart,tend,z,varfile,varname,tname,zname,zsign);
 #
 # t is the desired times in datenum format
 #
 # z is the desired depths in datenum format
 #
 # varfile is a cell array of the netCDF files with the variables
 #
 # varname (optional) is a cell array of the names of the variables in the netCDF files
 #                  default is {"u","v","T","S","eps"}
 #
 # tname (optional) is a cell array of the names of the time co-ordinate in the netCDF files
 #                  default is {"t","t","t","t","t"}
 #
 # zname (optional) is a cell array of the names of the depth co-ordinate in the netCDF files
 #                  default is {"z","z","z","z","z"}
 #
 # zsign (optional) multiply all depth values so that depth is <0
 #                  default is [1,1,1,1,1]
 #
 # order (optional) if 1 then depth first, else time first
 #                  default is [1,1,1,1,1]
 #
 # Assumes the variables are in the order U(z,t),V(z,t),T(z,t),S(z,t),epsilon(z,t)
 #
 #
  if(nargin<4)
   varname = {"u","v","T","S","eps"};
  end%if
  if(nargin<5)
   tname = {"t","t","t","t","t"};
  end%if
  if(nargin<6)
   zname = {"z","z","z","z","z"};
  end%if
  if(nargin<7)
   zsign = ones(1,5);
  end%if
  if(nargin<8)
   order = ones(1,5);
  end%if
  vars = {};
  [zz,tt] - meshgrid(z,t);
  zmin = min(z)-mean(diff(z));
  zmax = 0;
  % ingest the data files
  for i=1:5
   % open the file
   nc = netcdf(varfile{i},"r");
   % calculate the range of time
   ti = nc{tname{i}}(:);
   tidx = [find(ti<t,2,'last'),find(ti>t,2,'first')];
   % calculate the range of depths, and correct the sign
   zi = zsign(i)*nc{zname{i}}(:);
   zidx = find((zi>=zmin)*(zi<=zmax);
   %
   [zzi,tti] = meshgrid(zi,ti);
   % Extract the relecant values and place in (depth,time) order
   if(order(i)==1)
    vari = nc{varname{i}}(zidx,tidx);
   else
    vari = nc{varname{i}}(tidx,zidx)';
   end%if
   % interpolate onto the desired (depth,time) grid
   var = interp2(zzi,tti,vari,zz,tt,'spline');
   % fill the bottom and top with the closest interior point
   % Assumes all the NaNs are on the upper and lower edges!
   for j=1:length(t)
    badvar = isnan(var(:,j));
    badtop = find(badvar=0,1,'first')-1;
    badbot = find(badvar=1,1,'last');
    var(1:badtop,j) = var(badtop+1,j);
    var(badbot:end,j) = var(badbot-1,j);
   end%for
   if(i==5)
    var(find(var<1e-10))=1e-10;
   end%if
   vars = {vars{:}, var};
   ncclose(nc);
  end%for
  U = vars{1};
  V = vars{2};
  T = vars{3};
  S = vars{4};
  E = vars{5};
return
%% plot (comment out the preceding statement if you want to make these plots)
figure(21);clf
lw=1.5;
subplot(1,3,1)
plot(T,z,'r','linewidth',lw);
hold on
plot(S,z,'b','linewidth',lw)
ylabel('z [m]')
legend('T [^oC]','S [psu]','location','northwest'); legend boxoff
title(sprintf('day=%.4f',time_in));
xlabel('T [^oC], S [psu]')

subplot(1,3,2)
plot(U,z,'r','linewidth',lw)
hold on
plot(V,z,'b','linewidth',lw)
set(gca,'yticklabel','')
h=legend('U [m/s]','V [m/s]','location','northwest'); legend boxoff
plot([0 0],ylim,'k')
xlabel('U,V [m/s]')

subplot(1,3,3)
semilogx(E,z,'r','linewidth',lw);
set(gca,'yticklabel','')
xlabel('\epsilon [W/kg]')


