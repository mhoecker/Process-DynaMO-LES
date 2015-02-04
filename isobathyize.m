function isoB = isobathyize(t,rho,z,U,V,SA,CT,z_cords)


 fields = {t,rho,U,V,CT,SA};
 changed = changevar2(t,z,fields,z_cords);
 isoB.t    = changed.x;
 isoB.z    = changed.z
 isoB.rho  = changed.fields{1};
 isoB.U    = changed.fields{2};
 isoB.V    = changed.fields{3};
 isoB.CT   = changed.fields{4};
 isoB.SA   = changed.fields{5};

end%function
