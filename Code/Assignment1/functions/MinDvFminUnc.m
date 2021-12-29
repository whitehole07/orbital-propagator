function [dep, ga, arr, Dv] = MinDvFminUnc(guess_dep, guess_ga, guess_arr, ...
        dep_id, arr_id, ga_id, ga_mu, ga_Rlim, body_mu)
%MinDvFminUnc ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [Dv, v] = lambertTransfer(r1, r2, v1, v2, Dt, mu)
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
    toBeMinimized = @(T) ComputeDv(T(1), T(2), T(3), dep_id, ga_id, ga_mu, arr_id, body_mu, ga_Rlim);
    
    options = struct("Display", "off");
    [T, Dv] = fminunc(toBeMinimized, [guess_dep, guess_ga, guess_arr], options);
    dep = T(1); ga = T(2); arr = T(3);
end

