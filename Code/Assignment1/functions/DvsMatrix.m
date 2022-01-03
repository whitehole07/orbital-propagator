function Dvs = DvsMatrix(deps, dep_id, arrs, arr_id, ...
            gas, ga_id, ga_mu, ga_Rlim, body_mu)
%DvsMatrix: computation of Delta velocity matrix of dimensions mxn, with given a
% departure array of size mx1 and an arrival array of nx1 size. 
%Delta velocity matrix represents all mxn possibilities of interplanetary
% transfers given two planets, in the patched conics method approximation
%
% PROTOTYPE:
% Dvs = DvsMatrix(deps_array, dep_planet_id, arrs_array, arr_planet_id, body_mu, verbosity)
%
% INPUT:
% deps_array     [mx1]  Departure time array                                    [T]
% dep_planet_id  [1]    Departure planet identity number                        [-]
% arrs_array     [nx1]  Arrival time array                                      [T]
% arr_planet_id  [1]    Arrival planet identity number                          [-]
% body_mu        [1]    Gravitational parameter of the primary                  [L^3/T^2]
% verbosity      [1]    Input parameter to output different errors              [-]
%
% OUTPUT:
% Dvs  [mxn] Delta velocity matrix of departure and arrival dimensions  [L/T]
%
% CONTRIBUTORS:
% Daniele Agamennone, Farncesca Gargioli
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

