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
% Central planet
cen_planet = celestialBody("Earth");  % Central Planet (Earth)

% Initial state (keplerian elements)
a = 2.4501 * 1e4;      % Semi-major axis          [km]
e = 0.6665;            % Eccentricity             [-]
i = deg2rad(30.7205);  % Inclination              [rad]
OM = 0;                % RAAN                     [rad]
om = 0;                % Argument of pericentre   [rad]
f = 0;                 % True anomaly             [rad]

% GT ratio
k = 9;
m = 4;

% To kep vector
kep0 = [a e i OM om f];

% Initial state (cartesian coordinates)
[r0, v0] = KeplerianToCartesian(kep0, cen_planet.mu);

%% Unperturbed Two-Body Problem
% Initial orbital period
T = 2*pi * sqrt(a^3 / cen_planet.mu); % Orbital period [s]

% - Propagating -
% Physical parameters for perturbations
params = odeParamStruct( ...
    "R", cen_planet.R, ...
    "J2", cen_planet.J2, ...
    "ThirdBody", "Moon", ...
    "initMjd2000", 0 ...
    );

% Time array
tt1T = linspace(0, 18*T, 10000)';          % 1 orbit
tt1D = linspace(0, 86400, 10000)';      % 1 day
tt10D = linspace(0, 10*86400, 50000)';  % 10 days

% Cartesian propagation (Unperturbed)
[~, rr1T, ~] = OdeSolver("cartesian", [r0 v0], tt1T, cen_planet.mu);    % 1 orbit
[~, rr1D, ~] = OdeSolver("cartesian", [r0 v0], tt1D, cen_planet.mu);    % 1 day
[~, rr10D, ~] = OdeSolver("cartesian", [r0 v0], tt10D, cen_planet.mu);  % 10 days

% Unperturbed orbit plot
% plotOrbit(rr1T);

% Unperturbed groundtrack
[lat1T, lon1T] = GroundTrack(rr1T, tt1T, cen_planet.name);      % 1 orbit
[lat1D, lon1D] = GroundTrack(rr1D, tt1D, cen_planet.name);      % 1day
[lat10D, lon10D] = GroundTrack(rr10D, tt10D, cen_planet.name);  % 10 days  

% Groundtrack plot
PlotGroundTrack(lat1T, lon1T, 1);
% PlotGroundTrack(lat1D, lon1D);
% PlotGroundTrack(lat10D, lon10D);

% Modified semi major axis
am = RepeatingGroundTrack(k, m, cen_planet.om, cen_planet.mu, a, e, i, cen_planet.J2, cen_planet.R);

% Initial orbital period
Tm = 2*pi * sqrt(am^3 / cen_planet.mu); % Orbital period [s]

tt1Tm = linspace(0, 18*Tm, 10000)';          % 1 orbit
kepm = kep0; kepm(1) = am;

[rm, vm] = KeplerianToCartesian(kepm, cen_planet.mu);

[~, rr1Tm, ~] = OdeSolver("cartesian", [rm vm], tt1Tm, cen_planet.mu);    % 1 orbit

[lat1Tm, lon1Tm] = GroundTrack(rr1Tm, tt1Tm, cen_planet.name);      % 1 orbit

PlotGroundTrack(lat1Tm, lon1Tm, 1);