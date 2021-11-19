function PorkchopPlot(departures, arrivals, Dvs)
%PorkchopPlot ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [Dv, v] = lambertTransfer(r1, r2, v1, v2, Dt, mu)
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
        
    % Meshgrid
    [deps, arrs] = meshgrid(departures, arrivals);

    figure("name", "Porkchop", "numbertitle", "off");
    contour(deps, arrs, Dvs, min(min(Dvs)):min(min(Dvs)) + 5)
    colorbar
end

