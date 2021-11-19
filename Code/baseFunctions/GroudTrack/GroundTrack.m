function [lat, lon] = GroundTrack(rr, om, theta_g0, t, t0)
%GroundTrack ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [lat, lon] = GroundTrack(x, y, z, r, om, theta_g0, t, t0)
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

    x = rr(:, 1); y = rr(:, 2); z =  rr(:, 3); r = vecnorm(rr')';
    
    delta = asin(z ./ r); % delta, declination
    
    alpha = zeros(size(t, 1), 1);
    for i = 1 : size(t, 1)
        if y(i)/r(i) > 0
            alpha(i) = acos((x(i) / r(i)) / cos(delta(i)));
        else
            alpha(i) = 2*pi - acos((x(i) / r(i)) / cos(delta(i)));
        end
    end
    theta_g = @(t) theta_g0 + om * (t - t0);

    lat = rad2deg(delta);
    lon = rad2deg(wrapToPi(alpha - theta_g(t)));
end

