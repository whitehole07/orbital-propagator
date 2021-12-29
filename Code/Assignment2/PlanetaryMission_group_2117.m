% Group ID: 2117
% Assignment 2: Planetary Explorer Mission
% 
% - Data -
% Central Planet: Earth
% 
% a  = 2.4501 * 1e4 km
% e  = 0.6665
% i  = 30.7205 deg
% hp = 1800.074 km
%
% Repeating GT ratio: 9:4 (k:m)
% 
% Perturbations: J2, MOON
%

%% Cleaning up the workspace
clear; close all; clc;

%% Data
% Planet mu
mu_earth = astroConstants(13);      % Central Planet mu (Earth)

% Initial state (keplerian elements)
a = 2.4501 * 1e4;      % Semi-major axis          [km]
e = 0.6665;            % Eccentricity             [-]
i = deg2rad(30.7205);  % Inclination              [rad]
OM = 0;                % RAAN                     [rad]
om = 0;                % Argument of pericentre   [rad]
f = 0;                 % True anomaly             [rad]

% To kep vector
kep0 = [a e i OM om f];

% Initial state (cartesian coordinates)
[r0, v0] = KeplerianToCartesian(kep0, mu_earth);

%% TEST (!!)
% Orbital period
T = 2*pi * sqrt(a^3 / mu_earth); % Orbital period [s]

% Physical parameters
R_earth = astroConstants(23);
J2_earth = astroConstants(9);
om_earth = 7.2916e-05;  % Earth's rotation speed

% - Propagating -
% Physical parameters for perturbations
params = odeParamStruct( ...
    "R", R_earth, ...
    "J2", J2_earth, ...
    "ThirdBody", "Moon", ...
    "initMjd2000", 0 ...
    );

% Cartesian propagation
t1 = 0; t2 = 1000 * 86400; tspan = linspace(t1, t2, 10);
[~, rr, vv] = OdeSolver("cartesian", [r0 v0], tspan, mu_earth, params);

% Keplerian propagation
% [~, kep] = OdeSolver("keplerian", kep0, [0 t2], mu_earth, params);

%% Plot the orbit
plotOrbit(rr); % default is Earth

