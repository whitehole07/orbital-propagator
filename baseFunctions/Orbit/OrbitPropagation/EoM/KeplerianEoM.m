function dy = KeplerianEoM(t, y, mu, ap)
%OdeTwoBp ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% dy = OdeTwoBp(~, y, mu, R, J2)
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
    % Unpack state and acceleration into single variables
    [a, e, i, ~, om, f] = unpack(y);
    [ar, as, aw] = unpack(ap(t, y));

    % Derived parameters
    p = a * (1 - e^2);
    h = sqrt(p * mu);
    r = p / (1 + e*cos(f));
    
    % Equations of motion
    da = (2*a^2)/h * (e*sin(f)*ar + as*p/r);
    de = 1/h * (p*sin(f)*ar + as*((p + r)*cos(f) + r*e));
    di = (aw*r*cos(f + om)) / h;
    dOM = (aw*r*sin(f + om)) / (h*sin(i));
    dom = (1/(h*e))*((p + r)*sin(f)*as - p*cos(f)*ar) - (aw*r*sin(f + om)*cos(i))/(h*sin(i));
    dof = h/r^2 + (1/(h*e))*(p*cos(f)*ar - (p + r)*sin(f)*as);
    
    dy = [da; de; di; dOM; dom; dof];
end
