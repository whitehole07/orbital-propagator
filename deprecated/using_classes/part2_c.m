%% Cleaning up the workspace
clc; clear; close all;

%% Orbit propagation (from states to arc of an orbit)
% We must first define the initial and final states
% Let's say we want to propagate just half of an orbit
earth = CelestialBody("Earth");

% - Initial state -
state1 = OrbitState( ...
    "r", [26578.137; 0; 0], ...
    "v", [0; 2.221; 3.173], ...
    "t", 0, ...  % default value
    "body", earth ...
    );

% - Final state and propagation -
% 3 ways

% 1st - defining the final state explicitly
kep = state1.getKep();
state2 = OrbitState("kep", [kep(1:5) pi], "t", state1.T/2, "body", earth);
arc = state1.propagateTo("state_f", state2);  % propagateTo() returns an OrbitPropagation object

% 2nd - defining the final time
tf = state1.T/2;
arc = state1.propagateTo("tf", tf);

% 3rd - defining the delta time
Dt = state1.T/2 - 0;
arc = state1.propagateTo("Dt", Dt);

% NOTE: if you want to plot the entire orbit just don't pass any input
orbit = state1.propagateTo();

%% Plot the orbit
arc.plot();  % to plot the entire orbit: orbit.plot();

%% Plot the groundtrack
arc.groundtrack();
% you can also set N, which is the number of revolutions to plot
% arc.groundtrack(N), default is theta_g0 = 0