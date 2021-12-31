% Group ID: 2117
% Assignment 1: Interplanetary Explorer Mission
% 
% - Data -
% Departure Planet: Uranus
% FlyBy Planet: Jupiter
% Arrival Planet: Mercury
%
% Earlies Departure: 2030/01/01
% Latest Arrival: 2070/01/01
%

%% Cleaning up the workspace
clear; close all; clc;

%% Data
% Planets ID (for ephemerides)
dep_planet = celestialBody("Uranus");       % Departure Planet struct (Uranus)
ga_planet = celestialBody("Jupiter");       % FlyBy Planet struct (Jupiter)
arr_planet = celestialBody("Mercury");      % Arrival Planet struct (Mercury)

% Date Array to mjd2000
earliest_dep = date2mjd2000([2030 1 1 0 0 0]);    % Earliest Departure
latest_arr = date2mjd2000([2070 1 1 0 0 0]);      % Latest Arrival

% Central Body
central_body = celestialBody("Sun");  % Sun struct

%% Selecting time windows
% Initial choice for the time windows, justifying it based on the characteristics of the mission.
step = 240; % time step (days)

departures = date2mjd2000([2030 1 1 0 0 0]) : step : date2mjd2000([2040 1 1 0 0 0]);
ga_times = date2mjd2000([2040 1 1 0 0 0]) : step : date2mjd2000([2050 1 1 0 0 0]);
arrivals = date2mjd2000([2050 1 1 0 0 0]) : step : date2mjd2000([2070 1 1 0 0 0]);

% Defining the limit radius for fly by
% Additional constraints considered (such as minimum altitude of the closest approach during the flyby).
ga_Rlim = ga_planet.h_atm + ga_planet.R;  % Limit radius for flyby

% Compute Dvs
Dvs = DvsMatrix( ...
    departures, dep_planet.id, ...
    arrivals, arr_planet.id, ...
    ga_times, ga_planet.id, ga_planet.mu, ga_Rlim, ...
    central_body.mu ...
    );

% Find minimum and its position inside Dvs
[~, I] = findMin(Dvs);

% Initial guess values to find refined solution
init_dep = departures(I(1));
init_ga = ga_times(I(2));
init_arr = arrivals(I(3));

% Use fminunc to refine the solution
[min_dep, min_ga, min_arr, min_Dv] = MinDvFminUnc( ...
    init_dep, init_ga, init_arr, ...
    dep_planet.id, arr_planet.id, ga_planet.id, ...
    ga_planet.mu, ga_Rlim, central_body.mu ...
    );

% Plot Transfer
InterplanetaryPlot(departures, ga_times, arrivals, min_dep, min_ga, min_arr, ...
    dep_planet.name, ga_planet.name, arr_planet.name, central_body.name, ...
    "cenBodyScaleFactor", 50, "depBodyScaleFactor", 2.5e3, "flybyBodyScaleFactor", 1e3);

% FlyBy Plot
[~, vInfs] = ComputeDv(min_dep, min_ga, min_arr, dep_planet.id, ga_planet.id, ...
    ga_planet.mu, arr_planet.id, central_body.mu);

FlyByPlot(vInfs(:, 1), vInfs(:, 2), ga_planet.name)
