function [Pb,N,khidx,khl,khun,khsort]= anularavg(Pin,kh,khun,khidx,N,nosort)
 if(nargin==6)
  khl=kh;
  Pl=Pin;
 else
  # kh needs to be sorted since unique sorts
  [khl,khsort] = sort(kh(:));
  Pl = Pin(khsort);
 end%if
 # Find unique k magnitudes
 if(nargin()<3)
  khun = unique(khl)';
 end%if
 # Calculate the indecies and number of points
 # with a given unique wavenumber
 if(nargin()<4)
  N = zeros(size(khun));
  khidx = {};
  for i=1:length(khun)
   khidx = {khidx{:},find(kh==khun(i))};
   N(i) = length(khidx{1,i});
  end%for
 end%if
 # Calculate the number of points
 # with a given unique wavenumber
 if(nargin()==4)
  N = zeros(size(khun));
  for i=1:length(khun)
   N(i) = length(khidx{1,i});
  end%for
 end%if
 Pb = zeros(size(khun));
  for j=1:length(khun)
   Pb(j) = sum(Pin(khidx{1,j}))/N(j);
   %Pb(j) = 2*pi*khun(j)*sum(Pin(khidx{1,j}))/N(j);
  end%for
end%function

