function [departure, arrival, Dv] = MinDvFminUnc_deprecated(guess_dep, guess_arr, ...
                                    dep_planet_id, arr_planet_id, body_mu)
%MinDvFminUnc ODE system for the two-body problem (Keplerian motion)
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
    arguments
        guess_dep (1, 1) double
        guess_arr (1, 1) double
        dep_planet_id (1, 1) double
        arr_planet_id (1, 1) double
        body_mu (1, 1) double
    end
    
    function Dv = toBeMinimized(times)
        % Initial state
        ti = times(1) * 86400; % Total seconds passed since January 1, 2000
        [kep_i, ~] = uplanet(times(1), dep_planet_id);
        [ri, vi] = KeplerianToCartesian(kep_i, body_mu);

        % Final state
        tf = times(2) * 86400; % Total seconds passed since January 1, 2000
        [kep_f, ~] = uplanet(times(2), arr_planet_id);
        [rf, vf] = KeplerianToCartesian(kep_f, body_mu);
        
        % Dv
        Dv = sum(LambertTransfer(ri, rf, vi, vf, tf - ti, body_mu));
    end
    
    options = struct("Display", "off");
    [X, Dv] = fminunc(@toBeMinimized, [guess_dep, guess_arr], options);
    departure = X(1); arrival = X(2);
end

