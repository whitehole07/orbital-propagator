function t = AngleToTimeHyperbola(a, e, f, mu)
%KeplerEquationHyperbola ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [t, f] = TrueAnomalyEllipse(a, e, mu, f0, tspan)
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
    a_bar = - a;
    cosh_H = (e + cos(f))./(1 + e*cos(f));
    sinh_H = (sqrt(e^2 - 1) * sin(f)) ./ (e*cos(f) + 1);
    
    H = atanh(sinh_H./cosh_H);
    t = sqrt(a_bar^3 / mu)*(e*sinh_H - H);
end

