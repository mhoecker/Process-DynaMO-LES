#
#
# Plot Langmuir number as defined in
# Harcourt, R. R., and E. A. D’Asaro, 2008:
# Large-eddy simulation of langmuir turbulence in pure wind seas.
# J. Phys. Oceanogr.
wbyustar(x) = x>1 ? .64+3.5*exp(-2.69*x) : .398+.480*(x**(-.75))
