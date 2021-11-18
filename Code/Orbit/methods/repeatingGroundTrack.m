function a = repeatingGroundTrack(k, m, om, mu, a, e, i, J2, R)
%REPEATINGGROUNDTRACK Summary of this function goes here
%   Detailed explanation goes here
arguments
    k (1, 1) double
    m (1, 1) double
    om (1, 1) double
    mu (1, 1) double
    a (1, 1) double = inf
    e (1, 1) double = inf
    i (1, 1) double = 1.0
    J2 (1, 1) double = 0.0
    R (1, 1) double = 0.0
end
    % Secular effects
    OM_dot = -((1.5 * sqrt(mu) * J2 * R^2)/((1-e^2)^2 * a^3.5)) * cos(i);
    om_dot = -((1.5 * sqrt(mu) * J2 * R^2)/((1-e^2)^2 * a^3.5)) * (2.5*sin(i)^2 - 2);
    M0_dot = ((1.5 * sqrt(mu) * J2 * R^2)/((1-e^2)^1.5 * a^3.5)) * (1 - 1.5*sin(i)^2);
    
    % Semi-major axis needed for repeating groundtrack
    a = (mu/((om - OM_dot)*(k/m) - om_dot - M0_dot)^2)^(1/3);
end

