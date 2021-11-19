%% Cleaning up useless variables...
clc; close all; clear;

%% Lambert Orbit transfer (Lab 3, Exercise 2)
% Define a new celestial body neglecting j2 effect
options = struct("J2", false);
earth = CelestialBody("Earth", options);

% Initial state
kep1 = [12500 0 deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(120)];
P1 = OrbitState("kep", kep1, "t", 0, "body", earth);

% Time of flight in seconds
Dt = 3300; 

% Final state
kep2 = [9500 0.3 deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(250)];
P2 = OrbitState("kep", kep2, "t", P1.t + Dt, "body", earth);

% Lambert Solver
% Outputs are Dv (manouvre costs), arc (OrbitPropagation object)
[Dv, arc] = P1.transferTo(P2);

% Propagate P1 and P2 to get their orbits
orbitP1 = P1.propagateTo();
orbitP2 = P2.propagateTo();

% Plot orbits and transfer arc in the same figure
fig = orbitP1.plot();
arc.plot(fig);
orbitP2.plot(fig);

% Plot initial and final positions, same figure again
P1.plot(fig);
P2.plot(fig);

legend("Earth", "Initial orbit", "Transfer orbit", "Final orbit", ...
       "Initial Position", "Final Position")

%% Porkchop Plot (Lab 3 Exercise 3)
clear; clc;

% Still to be implemented...
