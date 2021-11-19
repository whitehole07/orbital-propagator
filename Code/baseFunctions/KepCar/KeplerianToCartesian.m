function [rr, vv] = KeplerianToCartesian(kep, mu)
%KeplerianToCartesian ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [rr, vv] = KeplerianToCartesian(a, e, i, OM, om, f, mu)
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
    [a, e, i, OM, om, f] = unpack(kep);
    
    % 1 - Position and velocity in perifocal
    p = a*(1-e^2);
    r = p/(1+e*cos(f));
    
    rr_PF = [r*cos(f); r*sin(f); 0];
    vv_PF = sqrt(mu/p)*[-sin(f); e+cos(f); 0];
    
    % 2 - Rotation matrix
    R_OM = [cos(OM) sin(OM) 0; -sin(OM) cos(OM) 0; 0 0 1];
    R_i = [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)];
    R_om = [cos(om) sin(om) 0; -sin(om) cos(om) 0; 0 0 1];
    
    R_PF = R_om*R_i*R_OM;
    
    R_GE = transpose(R_PF);
    
    % 3 - Position and velocity in geocentric equatorial
    rr = R_GE*rr_PF;
    vv = R_GE*vv_PF;

end

