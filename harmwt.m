function w = harmwt(dt,T,order)
 w=(1+sign(1-abs(2*dt/T))).*(cos(pi.*(dt./T))).^(order);
end%function
