% First off, let's clean up your dirty workspace.
clear; close all; clc;

%% Create celestial body
% Simply store all the data you need as variables
mu_earth = astroConstants(13);
R_earth = astroConstants(23);
J2_earth = astroConstants(9);
om_earth = 7.2916e-05;  % Earth's rotation speed

%% Define a state using cartesian coordinates
% Let's first define a state
r = [26578.137; 0; 0];
v = [0; 2.221; 3.173];

kep = CartesianToKeplerian(r, v, mu_earth);

a = kep(1); e = kep(2); i = kep(3);
OM = kep(4); om = kep(5); f = kep(6);  % Messy, isn't it? :/

[T, n, eps, h] = OrbitProperties(r, v, mu_earth);

% That's what I'm doing inside OrbitState class, you don't have to care about 
% this if you use the OrbitState object

%% Let's clean the workspace up again
clc; clear state r v a e i OM om f T n eps h kep;

%% Define a state using keplerian elements
% The keplerian elements
kep = [8350 .19760 deg2rad(60) deg2rad(270) deg2rad(45) deg2rad(230)];
[a, e, i, OM, om, f] = unpack(kep);  % (here I'm converting the kep array into single variables using unpack)

% We need to convert them into cartesian coordinates to get orbit's
% properties
[r, v] = KeplerianToCartesian(kep, mu_earth);
[T, n, eps, h] = OrbitProperties(r, v, mu_earth);
