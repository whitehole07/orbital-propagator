function am = RepeatingGroundTrack(k, m, om, mu, a, e, i, J2, R)
%RepeatingGroundTrack ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% a = RepeatingGroundTrack(k, m, om, mu, a, e, i, J2, R)
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
arguments
    k (1, 1) double
    m (1, 1) double
    om (1, 1) double
    mu (1, 1) double
    a (1, 1) double = inf
    e (1, 1) double = inf
    i (1, 1) double = 1.0
    J2 (1, 1) double = 0.0
    R (1, 1) double = 0.0
end
    % Secular effects
    OM_dot = -((1.5 * sqrt(mu) * J2 * (R^2))/(((1 - (e^2))^2) * (a^3.5))) * cos(i);
    om_dot = -((1.5 * sqrt(mu) * J2 * (R^2))/(((1 - (e^2))^2) * (a^3.5))) * (2.5*(sin(i)^2) - 2);
    M0_dot = ((1.5 * sqrt(mu) * J2 * (R^2))/(((1 - (e^2))^1.5) * (a^3.5))) * (1 - 1.5*(sin(i)^2));
    
    % Semi-major axis needed for repeating groundtrack
    am = (mu/((om - OM_dot)*(k/m) - om_dot - M0_dot)^2)^(1/3);
end

