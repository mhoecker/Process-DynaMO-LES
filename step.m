function [xnew,budg,budg2] = step(xold,k,dx_dt,xpwpt,xpwpb,dz,dt,frac)
%
%   mix the profile xold in accordance with a 1-d diffusion operator
%   d/dz (k d/dz) + dx_dt, with k a specified diffusion profile and
%   dx_dt a specified source profile.
%
%   this routine steps the profile xold forward one timestep dt
%   to create the profile xnew. diffusion is handled via a
%   2nd-order implicit (crank-nicolson) scheme. the source term is
%    handled explicitly via a forward euler scheme which becomes a
%    second-order adams-bashforth scheme when the source is input
%    as 1.5*s(t)-0.5*s(t-dt).
%
%    spatial derivatives are second-order centered differences on a
%    staggered grid, with flux boundary conditions imposed at
%    z=z(1)+dz/2 and z=z(n)-dz/2.
%
%    inputs:  xold(nn) = original profile
%                k(nn) = diffusivity profile
%            dx_dt(nn) = source profile
%                xpwpt = flux at upper boundary
%                xpwpb = flux at lower boundary
%                dz,dt = height and time increments
%
%    outputs: xnew(nn) = updated profile
%              budg(5) = variance budget
%
%    diffusivity is assumed to be given between grid points, i.e.
%    k(n)=k(z(n)+dz/2). k(1) is not used.
%
%    the variance budget is given as
%               budg(1) = rate of change of variance
%               budg(2) = contribution from surface flux
%               budg(3) =      "        "   bottom flux
%               budg(4) =      "        "   dissipation
%               budg(5) =      "        "   source term
nn=length(xold);
%
%   record original variance
z=(.5:length(xold)-.5)'*dz;
zf=(1:length(xold)-1)'*dz;
b_xold=sum(xold)*dz;
b2_xold=sum(.5*xold.*xold)*dz;
%
%   set up the tridiagonal array "a"
% 
a(1,1)=-k(2);
a(1,2)=k(2);
for n=2:nn-1;
    a(n,n-1)=k(n);
    a(n,n)=-k(n)-k(n+1);
    a(n,n+1)=k(n+1);
end
a(nn,nn-1)=k(nn);
a(nn,nn)=-k(nn);
a=a/dz^2;

% combine to make "aa" and "bb" for Crank-Nicolson method
aa=eye(nn)/dt-a/2;
bb=eye(nn)/dt+a/2;

% make right-hand side
r=bb*xold;
r=r+dx_dt;
r(1)=r(1)-xpwpt/dz;
r(nn)=r(nn)+xpwpb/dz;
%
%   Solve the linear system to obtain the solution xnew
%
xnew=aa\r;
%
%   compute variance budget terms
%
xavg=.5*(xold+xnew);
b_xnew=sum(xnew)*dz;
budg(1)=(b_xnew-b_xold)/dt;
budg(2)=-xpwpt;
budg(3)=xpwpb;
budg(4)=frac*sum(dx_dt)*dz;
budg(5)=(1-frac)*sum(dx_dt)*dz;
budg(6)=(budg(1)-(budg(2)+budg(3)+budg(4)+budg(5)));

b2_xnew=sum(.5*xnew.*xnew)*dz;
budg2(1)=(b2_xnew-b2_xold)/dt;
budg2(2)=-xavg(1)*xpwpt;
budg2(3)=xavg(end)*xpwpb;
d_xavg=zf*0;d_xavg=(xavg(1:end-1)-xavg(2:end))/dz;
budg2(4)=-sum(k(1:end-1).*d_xavg.^2)*dz;
budg2(5)=frac*sum(xavg.*dx_dt)*dz;
budg2(6)=(1-frac)*sum(xavg.*dx_dt)*dz;
budg2(7)=budg2(1)-(budg2(2)+budg2(3)+budg2(4)+budg2(5)+budg2(6));
return