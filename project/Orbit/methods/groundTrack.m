function [lat, lon] = groundTrack(x, y, z, r, om, theta_g0, t, t0)
%GROUNDTRACK Summary of this function goes here
%   Detailed explanation goes here
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

