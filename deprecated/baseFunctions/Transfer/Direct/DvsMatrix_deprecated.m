function Dvs = DvsMatrix_deprecated(deps_array, dep_planet_id, arrs_array, arr_planet_id, body_mu, verbosity)
%DvsMatrix ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [rr, vv] = KeplerianToCartesian(a, e, i, OM, om, f, mu)
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
        deps_array double
        dep_planet_id (1, 1) double
        arrs_array double
        arr_planet_id (1, 1) double
        body_mu (1, 1) double
        verbosity (1, 1) double = 1
    end
    
    % Init variable
    Dvs = zeros(size(deps_array, 2), size(arrs_array, 2));

    for i = 1:size(deps_array, 2)
        % Initial state
        ti = deps_array(i) * 86400; % Total seconds
        % passed since January 1, 2000
        [kep_i, ~] = uplanet(deps_array(i), dep_planet_id);
        [ri, vi] = KeplerianToCartesian(kep_i, body_mu);
        
        for j = 1:size(arrs_array, 2)
            % Final state
            tf = arrs_array(j) * 86400; % Total seconds passed since January 1, 2000
            [kep_j, ~] = uplanet(arrs_array(j), arr_planet_id);
            [rf, vf] = KeplerianToCartesian(kep_j, body_mu);
            
            try
                % Lambert
                Dv = LambertTransfer(ri, rf, vi, vf, tf - ti, body_mu, verbosity);
            catch
                Dvs(i, j) = NaN;
                continue
            end
            
            % Updating output variables
            Dvs(i, j) = sum(Dv);
        end
    end

end