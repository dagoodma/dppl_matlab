function [ m ] = angularMod(x,y)
%angularMod Modulo safe for angles.
%   Behaves as expected for angular quantities (negatives?).
   n = floor(x./y);
   m = x - n.*y;
end

