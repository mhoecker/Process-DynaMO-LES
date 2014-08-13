function tdx = trapdiff(x)
 N = length(x);
 M = zeros(N,N-1);
 M(1,1) = .5;
 M(N,N-1) = .5;
 for i=2:N-1
  M(i,i-1) = .5;
  M(i,i) = .5;
 end%for
 tdx = M*diff(x)(:);
end%function
