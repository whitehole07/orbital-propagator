%% Cleaning up the workspace
clc; clear; close all;

%% Orbit propagation (from states to arc of an orbit)
% We must first define the initial and final states
% Let's say we want to propagate just half of an orbit
mu_earth = astroConstants(13);
R_earth = astroConstants(23);
J2_earth = astroConstants(9);
om_earth = 7.2916e-05;  % Earth's rotation speed

% - Initial state -
r = [26578.137; 0; 0];
v = [0; 2.221; 3.173];
t1 = 0;
[T, n, eps, h] = orbitProperties(r, v, mu_earth);

% - Final state -
t2 = T/2;

% - Propagating -
% Physical parameters for perturbations
params = odeParamStruct("R", R_earth, "J2", J2_earth); % Perturbing effect due to J2

% We need a very high number of points to plot the groundtrack
tspan = linspace(t1, t2, 10000);
[tt, rr, vv] = OdeSolver("cartesian", [r v], tspan, mu_earth, params);

%% Plot the orbit
plotOrbit(rr); % default is Earth

%% Plot the groundtrack
theta_g0 = 0;
[lat, lon] = GroundTrack(rr, om_earth, theta_g0, tt, t1);
PlotGroundTrack(lat, lon);
