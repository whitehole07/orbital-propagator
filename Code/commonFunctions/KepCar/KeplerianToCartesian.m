function [rr, vv] = KeplerianToCartesian(kep, mu)
%KeplerianToCartesian: conversion from keplerian to cartesian orbit
%parameters. 
%
% PROTOTYPE:
% [rr, vv] = KeplerianToCartesian(kep mu)
%
% INPUT:
% kep  [6x1]  Keplerian parameters of orbit (a, e, i, OM, om, th)    [L, -, rad, rad, rad, rad]
% mu   [1]    Gravitational parameter of the primary                 [L^3/T^2]
%
% OUTPUT:
% rr   [3x1]   Position of the body in inertial frame (rx, ry, rz)    [L]
% vv   [3x1]   Velocity of the body in inertial frame (vx, vy, vz)    [L/T]
%
% CONTRIBUTORS:
% Daniele Agamennone, Francesca Gargioli
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

