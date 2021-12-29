function a = aJ2(RF, y, J2, R, mu)
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
    switch lower(RF)
        case "cartesian"
            % Unpack position vector into cartesian coordinates
            rr = y(1:3); [x, y, z] = unpack(rr);
        
            % Derived parameter
            r = norm(rr);
            
            % a_J2 expressed with respect to cartesian reference frame
            a = (3*J2*mu*(R^2))/(2*(r^4)) * [(x/r)*(5*(z^2/r^2) - 1); (y/r)*(5*(z^2/r^2) - 1); (z/r)*(5*(z^2/r^2) - 3)];
        case "keplerian"
            % Unpack state into single variables
            [a, e, i, ~, om, f] = unpack(y);
        
            % Derived parameters
            p = a * (1 - e^2);
            r = p / (1 + e*cos(f));
            
            % a_J2 expressed with respect to rsw reference frame
            a = -1.5 * (J2*mu*(R^2))/(r^4) * [1 - 3*(sin(i)^2)*(sin(f + om)^2); (sin(i)^2)*sin(2*(f + om)); sin(2*i)*sin(f + om)];
        otherwise
            error("Supported references frame are: 'Cartesian' and 'Keplerian' (RSW).");
    end
end

