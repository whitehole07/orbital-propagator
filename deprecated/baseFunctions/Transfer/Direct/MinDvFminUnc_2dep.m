function [dep, ga, arr, Dv] = MinDvFminUnc_2dep(guess_dep, guess_ga, guess_arr, ...
        dep_id, arr_id, ga_id, ga_mu, ga_Rlim, body_mu)
%MinDvFminUnc:  minimization function for a set of different departure and
%arrival times 
%
% PROTOTYPE:
% [departure, arrival, Dv] = MinDvFminUnc(guess_dep, guess_arr, ...
%                                  dep_planet_id, arr_planet_id, body_mu)
%
% INPUT:
% guess_dep       [nx1]   departure time array                                                   [T]
% guess_arr        [nx1]   arrival time array                                                        [T]
% dep_planet_id  [1]   Departure planet identity number                                 [-]
% arr_planet_id   [1]   Arrival planet identity number                                      [-]
% body_mu         [1]   Gravitational parameter of the primary body             [L^3/T^2]
%
% OUTPUT:
% departure  [1] Minimum velocity departure state  [L]
% arrival       [1] Minimum velocity arrival state [L]
% Dv            [1] Minimum delta velocity for transfer [L/T]
%
% CONTRIBUTORS:
% Daniele Agamennone, Francesca Gargioli
%
% VERSIONS
% 2021-10-20: First version
%
    toBeMinimized = @(T) ComputeDv(T(1), T(2), T(3), dep_id, ga_id, ga_mu, arr_id, body_mu, ga_Rlim);
    
    options = struct("Display", "off");
    [T, Dv] = fminunc(toBeMinimized, [guess_dep, guess_ga, guess_arr], options);
    dep = T(1); ga = T(2); arr = T(3);
end

