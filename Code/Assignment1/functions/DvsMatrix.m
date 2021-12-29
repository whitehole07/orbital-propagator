function Dvs = DvsMatrix(deps, dep_id, arrs, arr_id, ...
            gas, ga_id, ga_mu, ga_Rlim, body_mu)
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
    % Init variable
    Dvs = zeros(length(deps), length(gas), length(arrs));

    for i = 1:length(deps)
        for j = 1:length(gas)
            for k = 1:length(arrs)
                % Updating output variables
                Dvs(i, j, k) = ComputeDv( ...
                    deps(i), gas(j), arrs(k), ...
                    dep_id, ga_id, ga_mu, arr_id, ...
                    body_mu, ga_Rlim ...
                    );
            end
        end
    end
end

