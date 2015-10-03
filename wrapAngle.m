function [ theta ] = wrapAngle( theta )
%wrapAngle Wraps an angle to 2*pi using angularMod.
%   Uses modulo function safe for angles.
    theta = angularMod(theta,2*pi);
end
