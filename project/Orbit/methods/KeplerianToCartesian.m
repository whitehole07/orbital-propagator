function [rr, vv] = KeplerianToCartesian(a, e, i, OM, om, f, mu)
%KEPLERIANTOCARTESIAN Summary of this function goes here
%   Detailed explanation goes here

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

