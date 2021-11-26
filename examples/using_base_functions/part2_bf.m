%% Cleaning up the workspace
clc; 
clear; 
close all;

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
[T, n, eps, h] = OrbitProperties(r, v, mu_earth);

% - Final state -
t2 = T/2;

% - Propagating -
% We need a very high number of points to plot the groundtrack
odeOptions = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);
[tt, rr, vv] = OdeSolver(r, v, linspace(t1, t2, 10000), mu_earth, R_earth, J2_earth, odeOptions);

%% Plot the orbit
PlotOrbit(rr, R_earth);

%% Plot the groundtrack
theta_g0 = 0;
[lat, lon] = GroundTrack(rr, om_earth, theta_g0, tt, t1);
PlotGroundTrack(lat, lon);