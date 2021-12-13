function [t, r, v] = OdeSolver(r0, v0, tspan, mu, R, J2)
%OdeSolver ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [t, r, v] = OdeSolver(r0, v0, tspan, mu, R, J2, odeOptions)
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
     
    odeOptions = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);
    [t, y] = ode113(@(t,y) OdeTwoBp(t, y, mu, R, J2), ...
                    tspan, [r0 v0], odeOptions);
    
    r = y(:, 1:3);
    v = y(:, 4:end);

end

