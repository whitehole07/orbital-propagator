function dy = CartesianEoM(t, y, mu, aps)
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
    % Evaluate perturbing acceleration
    ap = 0; for i = 1:length(aps); ap = ap + aps{i}(t, y); end
    
    % Position vector and velocity into single variables
    rv = y(1:3); vv = y(4:6); 
    
    % Derived parameter
    r = norm(rv);

    % Equations of motion
    dr = vv;
    dv = (-mu/r^3)*rv + ap;

    dy = [dr; dv];
end

