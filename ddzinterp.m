function [val,der,dsq] = ddzinterp(z,Z,order)
 # A matrix to calculate derrivatives on a new basis set
 if(nargin==1)
  Z=z;
 end%if
 if(nargin<3)
  order=4;
 end%if
 Nz = length(z);
 NZ = length(Z);
 if(order>Nz)
  order = min([3,Nz-1]) ;
 end%if
 diffz = bsxfun('minus',z(:),Z(:)');
 diffzsq = diffz.^2;
 A = zeros(order,order);
 val = zeros(length(Z),length(z));
 der = zeros(length(Z),length(z));
 dsq = zeros(length(Z),length(z));
 for i=1:length(Z)
   dzsq = diffzsq(:,i);
   [dzsq,idx]= sort(dzsq);
   for j=1:order
    for k=1:order
     A(j,k) = (1/factorial(k-1))*diffz(idx(j),i).^(k-1);
    end#for
   end#for
   ainv = inv(A');
   for j=1:order
    val(i,idx(j))  = ainv(j,1);
    der(i,idx(j)) = ainv(j,2);
    dsq(i,idx(j)) = ainv(j,3);
   end#for
  end#for
end#function
