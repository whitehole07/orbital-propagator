function A_GEO_to_RSW = geoToRSW(rr, vv)
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
    
    % RSW coordinates with respect to a cartesian reference frame
    r = rr / norm(rr);
    w = cross(rr, vv) / norm(cross(rr, vv));
    s = cross(w, r);
    
    % Rotation matrix (GEO -> RSW)
    A_GEO_to_RSW = [r s w]';
end

