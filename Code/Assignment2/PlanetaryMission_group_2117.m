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

%% 1) Nominal Orbit
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
k = 9;  % Revolutions of the satellite
m = 4;  % Rotations of the planet

% To kep vector
kep0 = [a e i OM om f];

% Initial state (cartesian coordinates)
[r0, v0] = KeplerianToCartesian(kep0, cen_planet.mu);

%% 2.a) Unperturbed Two-Body Problem
% Unperturbed orbital period
T = 2*pi * sqrt(a^3 / cen_planet.mu); % Orbital period [s]

% Time array
tt1T = linspace(0, T, 10000)';          % 1 orbit
tt1D = linspace(0, 86400, 10000)';      % 1 day
tt10D = linspace(0, 10*86400, 50000)';  % 10 days

% Cartesian propagation (Unperturbed)
[~, rr1T, ~] = OdeSolver("cartesian", [r0; v0], tt1T, cen_planet.mu);    % 1 orbit
[~, rr1D, ~] = OdeSolver("cartesian", [r0; v0], tt1D, cen_planet.mu);    % 1 day
[~, rr10D, ~] = OdeSolver("cartesian", [r0; v0], tt10D, cen_planet.mu);  % 10 days

% Unperturbed groundtracks
[lat1T, lon1T] = GroundTrack(rr1T, tt1T, cen_planet.name);      % 1 orbit
[lat1D, lon1D] = GroundTrack(rr1D, tt1D, cen_planet.name);      % 1 day
[lat10D, lon10D] = GroundTrack(rr10D, tt10D, cen_planet.name);  % 10 days  

% Groundtrack plot
% PlotGroundTrack(lat1T, lon1T);       % 1 orbit
% PlotGroundTrack(lat1D, lon1D);       % 1 day
% PlotGroundTrack(lat10D, lon10D);     % 10 days

% Modified semi major axis for repeating groundtrack (unperturbed)
am = RepeatingGroundTrack(k, m, cen_planet.om, cen_planet.mu, a, e, i);

% Modified orbital period
Tm = 2*pi * sqrt(am^3 / cen_planet.mu);   % Orbital period [s]

% New time array
ttkTm = linspace(0, k*Tm, 30000)';    % k orbits

% Modified keplerian elements
kepm = kep0; kepm(1) = am;
 
% Keplerian to Cartesian
[rm, vm] = KeplerianToCartesian(kepm, cen_planet.mu);

% Modified orbit propagation
[~, rrkTm, ~] = OdeSolver("cartesian", [rm; vm], ttkTm, cen_planet.mu);    % k orbits


% Modified orbit groundtracks
[latkTm, lonkTm] = GroundTrack(rrkTm, ttkTm, cen_planet.name);      % k orbits

% Plot modified groundtracks
% PlotGroundTrack(latkTm, lonkTm);

% % - Propagating -
% % Physical parameters for perturbations
% params = odeParamStruct( ...
%     "R", cen_planet.R, ...
%     "J2", cen_planet.J2, ...
%     "ThirdBody", "Moon", ...
%     "initMjd2000", 0 ...
%     );
