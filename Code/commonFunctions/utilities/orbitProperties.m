function [T, n, eps, h] = orbitProperties(r, v, mu)
%OrbitProperties ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [T, n, eps, h] = OrbitProperties(r0, v0, mu)
%
% INPUT:
% t   [1]    Time (can be omitted, as the system is autonomous)    [T]
% y   [6x1]  Cartesian state of the body (rx, ry, rz, vx, vy, vz)  [L, L/T]
% mu  [1]    Gravitational parameter of the primary                [L^3/T^2]
%
% OUTPUT:
% dy  [6x1] Derivative of the state  [L/T^2, L/T^3]
%
% CONTRIBUTORS:
% Daniele Agamennone
%
% VERSIONS
% 2021-10-20: First version
%
    a = 1/(2/norm(r) - dot(v,v)/mu);
    
    T = 2*pi*sqrt(a^3/mu); % Orbital period [s]
    n = 2*pi / T;
    eps = - (mu/2*a);
    h = cross(r, v);
end

