function [T, n, eps, h] = OrbitProperties(r0, v0, mu)
%ORBITPROPERTIES Summary of this function goes here
%   Detailed explanation goes here
    a = 1/(2/norm(r0) - dot(v0,v0)/mu);
    
    T = 2*pi*sqrt(a^3/mu); % Orbital period [1/s]
    n = 2*pi / T;
    eps = - (mu/2*a);
    h = cross(r0, v0);
end

