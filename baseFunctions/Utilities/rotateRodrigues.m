function [v_rotated] = rotateRodrigues(v, u, d)
%rotateRodrigues ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [v_rotated] = rotateRodrigues(v, u, d);
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
    if norm(u) ~= 1
        error("u must be a unit norm vector.");
    end

    v_rotated = v*cos(d) + cross(u, v)*sin(d) + u*dot(u, v)*(1 - cos(d));
end

