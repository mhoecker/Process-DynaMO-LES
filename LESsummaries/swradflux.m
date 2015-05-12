function Trans=swradflux(z,p,k)
# Calculate the transmitted short wave radiation
# Constants used in Paulson & Simpson's (1977, JPO 7) penetrative
# solar flux profile:
#
# values taken from
# Pegau and Paulson, "The summertime evolution of an Arctic lead"
# p = 0.481, 0.194, 0.123, 0.202
# k = 0.18, 3.25, 27.5, 300.
# Parameters from DYNAMO experiment 2011 yeardays 328 to 330
#  p = 0.6854,1-0.6854
#  k = 1./1.116, 1./22.59
 if nargin()<2
  #p = [0.481, 0.194, 0.123, 0.202];
  #k = [0.18, 3.25, 27.5, 300.]';
   p = [0.6854,1-0.6854];
   k = [1./1.116, 1./22.59]';
  end%if
  Trans = p*exp(k.*z);
end%function
