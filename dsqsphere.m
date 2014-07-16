function [dsq,dphi,dtheta,phi] = dsqsphere(loc1,loc2,R)
# Assumes locations are
#loc1=[lat,lon] in degrees
#loc2=[lat,lon] in degrees
 if(nargin()<3)
  Rsq = 40680159610000;
 end%if
# Convert angle to radians
 dphi = loc1(1)-loc2(1);
 dphi = smallerangle(dphi);
 phi = loc2(1)+dphi/2;
 dtheta = loc1(2)-loc2(2);
 dtheta = smallerangle(dtheta);
 dsq = Rsq*(pi/180)*(pi/180)*(dphi.^2+(cos(phi*pi/180).*dtheta).^2);
end

function sangle = smallerangle(angle)
 if(angle<-180)
  sangle=-360-angle;
 elseif(angle>180)
  sangle=360-angle;
 else
  sangle=angle;
 end
end%
