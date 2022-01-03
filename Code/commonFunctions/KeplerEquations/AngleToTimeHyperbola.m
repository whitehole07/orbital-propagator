function t = AngleToTimeHyperbola(a, e, f, mu)
%AngleToTimeHyperbola: computation of time of flight given hyperbola parameters
%
% PROTOTYPE:
% t = AngleToTimeHyperbola(a, e, f, mu)
%
% INPUT:
% a   [1] semimajor axis of hyperobla                  [L]
% e   [1] eccentricity of hyperbola                    [-]
% f   [1] true anomaly of body in hyperbolic path      [rad]
% mu  [1]    Gravitational parameter of the primary    [L^3/T^2]
%
% OUTPUT:
% t   [1] time of flight [T]
%
% CONTRIBUTORS:
% Daniele Agamennone, Francesca Gargioli
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

