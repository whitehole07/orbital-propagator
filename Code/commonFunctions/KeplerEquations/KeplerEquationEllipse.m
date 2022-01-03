function [t, f] = KeplerEquationEllipse(a, e, mu, f0, tspan)
%TrueAnomalyEllipse ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE: 
% [t, f] = KeplerEquationEllipse(a, e, mu, f0, tspan)
%
% INPUT:
% a      [1]    Semimajor axis of the hyperobla                                         [L]
% e      [1]    Eccentricity of the hyperbola                                           [-]
% mu     [1]    Gravitational parameter of the primary                                  [L^3/T^2]
% f0     [1]    True anomaly of body in hyperbolic path                                 [rad]
% tspan  [nx1]  Time array to evaluate a set of n true anomalies along hyperbolic path  [T]
%
% OUTPUT:
% t  [nx1] time of flight of body in hyperbolic path   [T]
% f  [nx1] true anomalies computed in hyperbolic path  [rad]
%
% CONTRIBUTORS:
% Daniele Agamennone, Francesca Gargioli
%
% VERSIONS
% 2021-10-20: First version
% 
    t0 = tspan(1);
    if size(tspan, 1) == 2
        t = linspace(t0, tspan(end), 1000)';
    elseif size(tspan, 1) < 2
        error("tspan length must be greater than 1");
    else
        t = tspan;
    end

    cos_E0 = (e + cos(f0))/(1 + e*cos(f0));
    sin_E0 = sqrt((1-e)/(1+e)) * tan(f0/2) * (1 + cos_E0);
    
    E0 = mod(atan2(sin_E0, cos_E0), 2*pi);
    M0 = E0 - e * sin_E0;
    
    M = M0 + sqrt(mu/a^3) * (t - t0);
    
    M_bar = wrapTo2Pi(M);
    k = ceil((M - M_bar) / (2*pi));
    
    fun = @(E) M_bar - E + e*sin(E);
    
    E_guess = M_bar + ((e*sin(M_bar))./(1 - sin(M_bar+e) + sin(M_bar)));
    
    options = optimset('Display', 'off');
    E = fsolve(fun, E_guess, options);
    
    cos_f = (cos(E) - e)./(1 - e*cos(E));
    sin_f = sqrt((1+e)/(1-e)) * (tan(E/2) .* (1 + cos_f));
    
    f = mod(atan2(sin_f, cos_f), 2*pi) + k * 2*pi;
end

