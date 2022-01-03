function [dep, ga, arr, Dv] = MinDvFminCon(guess_dep, guess_ga, guess_arr, ...
        t_min, t_max, dep_id, arr_id, ga_id, ga_mu, ga_Rlim, body_mu)             
% INPUT:
% guess_dep        [nx1]     Departure date (guess) found with FindOptimumDv(Dvs)                   [T]
% guess_arr        [nx1]     Arrival date (guess) found with FindOptimumDv(Dvs)                     [T]
% dep_planet_id    [1]       Departure planet identity number                                       [-]
% arr_planet_id    [1]       Arrival planet identity number                                         [-]
% body_mu          [1]       Gravitational parameter of the primary body                            [L^3/T^2]
% t_min            [1]       Initial value of the departure array                                   [T]
% t_max            [1]       Final value of the arrival array                                       [T]
%
%
% OUTPUT:
% departure     [1] Minimum velocity departure state                                                [L]
% arrival       [1] Minimum velocity arrival state                                                  [L]
% Dv            [1] Minimum delta velocity for transfer                                             [L/T]
%
% CONTRIBUTORS:
% Davide Gianmoena,Daniele Agamennone,Francesca Gargioli
%
% VERSIONS
% 2022-1-2: First version

    toBeMinimized = @(T) ComputeDv(T(1), T(2), T(3), dep_id, ga_id, ga_mu, arr_id, body_mu, ga_Rlim);

    opt = optimset('Display', 'off');
    [T, Dv] = fmincon(toBeMinimized, [guess_dep, guess_ga, guess_arr],[],[],[],[], ...
        [t_min, t_min, t_min], [t_max, t_max, t_max], [], opt);

    dep = T(1); ga = T(2); arr = T(3);

end

