% First off, let's clean up your dirty workspace.
clear; close all; clc;

%% Create celestial body
% You can create a celestial body instance using the following syntax, 
% the object embeds all the information related to the body.
% So far the implemented bodies are: "Earth", "Mars", "Sun".
% If you want to have fun implementing more of them, you're very welcome.
% For more details: CelestialBody.m
earth = CelestialBody("Earth");

% Run this section and look at your command window to see the body's
% properties
disp(earth);

%% Define a state using cartesian coordinates
% Let's first define a state
r = [26578.137; 0; 0];
v = [0; 2.221; 3.173];

% You can always define a state manually (good luck :)) but if you're lazy
% a convinient way to do it using the cartesian coordinates 
% is the following
state = OrbitState("r", r, "v", v, "body", earth);

% Again the object embeds many useful properties, take a look at them in
% the command window
disp(state);

%% Let's clean the workspace up again
clc; clear state r v a e i OM om f T n eps h kep;

%% Define a state using keplerian elements
% The keplerian elements
kep = [8350 .19760 deg2rad(60) deg2rad(270) deg2rad(45) deg2rad(230)];
[a, e, i, OM, om, f] = unpack(kep);  % (here I'm converting the kep array into single variables using unpack)

% There are two ways to define a state using keplerian elements:
state = OrbitState("a", a, "e", e, "i", i, "OM", OM, "om", om, "f", f, "body", earth);

% or
state = OrbitState("kep", kep, "body", earth);
