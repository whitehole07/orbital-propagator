%% Cleaning up useless variables...
clc; close all; clear;

%% Lambert Orbit transfer (Lab 3, Exercise 2)
% Some constants
mu_earth = astroConstants(13);
R_earth = astroConstants(23);

% Initial state
kep1 = [12500 0 deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(120)];

% Final state
kep2 = [9500 0.3 deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(250)];

% Time of flight in seconds
Dt = 3300; 

% We'll need those states expressed as cartesian coordinates
[r1, v1] = KeplerianToCartesian(kep1, mu_earth);
[r2, v2] = KeplerianToCartesian(kep2, mu_earth);

% Lambert solver
[Dv, vl] = LambertTransfer(r1, r2, v1, v2, Dt, mu_earth);

% To plot the orbits
% Initial Orbit
[T1, ~, ~, ~] = OrbitProperties(r1, v1, mu_earth);

[~, rr1, ~] = OdeSolver(r1, v1, linspace(0, T1, 1000), mu_earth, R_earth, 0);
fig = PlotOrbit(rr1);

% Transfer Orbit
[Ta, ~, ~, ~] = OrbitProperties(r1, vl(1, :), mu_earth);

[~, rra, ~] = OdeSolver(r1, vl(1, :)', linspace(0, Dt, 1000), mu_earth, R_earth, 0);
PlotOrbit(rra, "fig", fig);

% Final Orbit
[T2, ~, ~, ~] = OrbitProperties(r2, v2, mu_earth);

[~, rr2, ~] = OdeSolver(r2, v2, linspace(0, T2, 1000), mu_earth, R_earth, 0);
PlotOrbit(rr2, "fig", fig);

% Initial and final state
PlotOrbit(r1, "fig", fig);
PlotOrbit(r2, "fig", fig);

legend("Earth", "Atmosphere", "Initial orbit", "Transfer orbit", "Final orbit", ...
       "Initial Position", "Final Position")

%% Porkchop Plot (Lab 3 Exercise 3)
clear; clc;

% Departure
deps_from = date2mjd2000([2003 4 1 0 0 0]); 
deps_to =  date2mjd2000([2003 8 1 0 0 0]);
dep_planet_id = 3;  % Earth

% Arrival
arrs_from = date2mjd2000([2003 9 1 0 0 0]);
arrs_to = date2mjd2000([2004 3 1 0 0 0]);
arr_planet_id = 4;  % Mars

% Other parameters
central_body_mu = astroConstants(4);
step = .5; % days (WARNING: small step size means long execution time)

% Make array for departures and arrivals
deps = deps_from:step:deps_to;
arrs = arrs_from:step:arrs_to;

% Compute the Dvs matrix
Dvs = DvsMatrix(deps, dep_planet_id, arrs, arr_planet_id, central_body_mu);

% Find minimum value position inside the Dvs matrix
[x, y] = find(Dvs == min(min(Dvs)));
init_dep = deps(y);
init_arr = arrs(x);

% Use fminunc to refine the solution
[min_dep, min_arr, min_Dv] = MinDvFminUnc(init_dep, init_arr, ...
                            dep_planet_id, arr_planet_id, central_body_mu);

% Porkchop Plot
PorkchopPlot(deps, arrs, Dvs, "minDv", min_Dv, "title", "Porkchop Plot: Earth to Mars");

% Plot Transfer
InterplanetaryPlot(deps_from, deps_to, arrs_from, arrs_to, min_dep, min_arr, ...
                   dep_planet_id, arr_planet_id, central_body_mu, ...
                   "depPlanetName", "Earth", "arrPlanetName", "Mars", "timeWindow", true);
