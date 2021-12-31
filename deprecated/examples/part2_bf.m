%% Cleaning up the workspace
clc; clear; close all;

%% Orbit propagation (from states to arc of an orbit)
% We must first define the initial and final states
% Let's say we want to propagate just half of an orbit
cen_planet = celestialBody("Earth");

% Keplerian elements
kep = [26600 .74 deg2rad(63.4) deg2rad(50) deg2rad(280) 0];
[r, v] = KeplerianToCartesian(kep, cen_planet.mu);

T = 2*pi * sqrt(kep(1)^3 / cen_planet.mu); % Orbital period [s]

% - Initial state -
t1 = 0;

% - Final state -
t2 = 29*T;

% - Propagating -
% Physical parameters for perturbations
% params = odeParamStruct("R", R_earth, "J2", J2_earth); % Perturbing effect due to J2

% We need a very high number of points to plot the groundtrack
tspan = linspace(t1, t2, 100000);
[tt, rr, vv] = OdeSolver("cartesian", [r; v], tspan, cen_planet.mu);

%% Plot the orbit
plotOrbit(rr); % default is Earth

%% Plot the groundtrack
[lat, lon] = GroundTrack(rr, tt, "Earth");
PlotGroundTrack(lat, lon);
