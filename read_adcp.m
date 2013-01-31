function [z,t,u,v,dudz,dvdz,rmsshear] = read_adcp(filename,zmin,maxshipspeed)
	Ntmax = 2000;
	load(filename)
#	who
#	fieldnames(adcp)
	z = -adcp.depth;
	if(nargin<2)
		zmin=min(z);
	endif
	Zidx = find(z>=zmin);
	z = z(Zidx);
#
	dzmatrix = ddz(z);
#
	t = adcp.time;
	shipspeed = sqrt(adcp.uship.^2+adcp.vship.^2);
	u = adcp.u(Zidx,:);
	v = adcp.v(Zidx,:);
	currentspeed = sqrt(u.^2+v.^2);
	if(nargin<2)
		maxshipspeed = max(currentspeed)-mean(currentspeed);
	endif
	
#	Tidx = find((sign(shipspeed-maxshipspeed)<0)||(sign(sum(isnan(u)))==0)||(sign(sum(isnan(v)))==0));
#	Tidx = find((sign(shipspeed-maxshipspeed)<0)||(sign(sum(isnan(u)))==0)||(sign(sum(isnan(v)))==0));
	Tidx = find((shipspeed+sum(isnan(u))+sum(isnan(v))>maxshipspeed));
	length(Tidx)
	size(Tidx)
	figure(1)
	subplot(3,1,1)
	plot(t,shipspeed-maxshipspeed);
	subplot(3,1,2)
	plot(t,sum(isnan(u)));
	subplot(3,1,3)
	plot(t,sum(isnan(v)));
	Tstart = find(shipspeed<=maxshipspeed,1);
	dudz = dzmatrix*u;
	dvdz = dzmatrix*v;
	rmsshear = sqrt(dudz.^2+dvdz.^2);
	u(:,Tidx) = 0;
	v(:,Tidx) = 0;
	dudz(:,Tidx) = 0;
	dvdz(:,Tidx) = 0;
	rmsshear(:,Tidx) = 0;
	if(length(t)-Tstart<Ntmax)
		Ntmax = length(Ntmax)-Tstart;
	endif
	Tplot = Tstart:Tstart+Ntmax;
	Zplot = 2:length(z);
	trange = [min(t(Tplot)),max(t(Tplot))];
	[tt,zz] = meshgrid(t(Tplot),z(Zplot));
	figure(2)
	subplot(3,1,1); pcolor(tt,zz,u(Zplot,Tplot)); shading flat; colorbar; title("E/W velocity"); axis(trange)
	subplot(3,1,2); pcolor(tt,zz,v(Zplot,Tplot)); shading flat; colorbar; title("N/S velocity"); axis(trange)
	subplot(3,1,3); pcolor(tt,zz,currentspeed(Zplot,Tplot)); shading flat; colorbar; title("Speed"); axis(trange)
	figure(3)
	subplot(3,1,1); pcolor(tt,zz,dudz(Zplot,Tplot)); shading flat; colorbar; title("E/W shear"); axis(trange)
	subplot(3,1,2); pcolor(tt,zz,dvdz(Zplot,Tplot)); shading flat; colorbar; title("N/S shear"); axis(trange)
	subplot(3,1,3); pcolor(tt,zz,rmsshear(Zplot,Tplot)); shading flat; colorbar; title("Shear"); axis(trange)

endfunction
