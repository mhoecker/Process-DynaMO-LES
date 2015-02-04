function X = nanimag(Y)
% Convert any number with an imaginary component to NaN
%
 idximag = find(imag(Y)!=0);
 X = real(Y);
 X(idximag) = NaN;
end%function
