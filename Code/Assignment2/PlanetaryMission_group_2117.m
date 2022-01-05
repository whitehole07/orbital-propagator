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

%% 2) Ground track
% 2.a) Unperturbed Two-Body Problem
% Unperturbed orbital period
T = 2*pi * sqrt(a^3 / cen_planet.mu); % Orbital period [s]

% Time array
tt1T = linspace(0, T, 10000)';          % 1 orbit
tt1D = linspace(0, 86400, 10000)';      % 1 day
tt10D = linspace(0, 10*86400, 50000)';  % 10 days
ttkT = linspace(0, k*T, 30000)';        % k orbits

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

% 2.b) Modified semimajor axis for repeating groundtrack
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

% Modified orbit propagation (Unperturbed)
[~, rrkTm, ~] = OdeSolver("cartesian", [rm; vm], ttkTm, cen_planet.mu);    % k orbits


% Modified orbit groundtracks
[latkTm, lonkTm] = GroundTrack(rrkTm, ttkTm, cen_planet.name);      % k orbits

% Plot modified groundtracks
% PlotGroundTrack(latkTm, lonkTm);

% 2.c) Plot adding assigned perturbations
% Physical parameters for perturbations
params = odeParamStruct( ...
    "R", cen_planet.R, ...
    "J2", cen_planet.J2, ...
    "ThirdBody", "Moon", ...
    "initMjd2000", 0 ...      % Initial MJD2000 for Moon ephemerides
);

% Nominal orbit propagation and groundtrack (Perturbed)
[~, rrkTp, ~] = OdeSolver("cartesian", [r0; v0], ttkT, cen_planet.mu, params);    % k orbits
[latkTp, lonkTp] = GroundTrack(rrkTp, ttkT, cen_planet.name);
% PlotGroundTrack(latkTp, lonkTp);

% Modified orbit propagation and groundtrack (Perturbed)
[~, rrkTmp, ~] = OdeSolver("cartesian", [rm; vm], ttkTm, cen_planet.mu, params);  % k orbits
[latkTmp, lonkTmp] = GroundTrack(rrkTmp, ttkTm, cen_planet.name);
% PlotGroundTrack(latkTmp, lonkTmp);

% The groundtrack clearly doesn't repeat itself anymore, but why is this
% happening?

%% 3) Introduce the assigned perturbations
% Assigned perturbations are: J2 and Moon
% They've been introduced in the previous section through 'params' variable

%% 4) Propagate the perturbed orbit
% Time array
n = 500;                            % Number of revolutions
ttnT = linspace(0, n*T, n*100)';    % n orbits

% Cartesian coordinates
[~, rrTpc, vvTpc] = OdeSolver("cartesian", [r0; v0], ttnT, cen_planet.mu, params);    % 1 orbit

% Keplerian elements (Gauss' equations)
[~, kep] = OdeSolver("keplerian", kep0, ttnT, cen_planet.mu, params);    % 1 orbit

%% 5) Plot the history of the Keplerian elements
% Converting cartesian to keplerian
kepc = zeros(length(ttnT), 6);
for i = 1:length(ttnT); kepc(i, :) = CartesianToKeplerian(rrTpc(i, :), vvTpc(i, :), cen_planet.mu); end

% Unwrap OM, om and f
kepc(:, 4:end) = unwrap(kepc(:, 4:end));

% Comparing both propagation methods (unfiltered)
KepHistoryPlot("a",  ttnT/T, kep(:, 1), kepc(:, 1))   % a
KepHistoryPlot("e",  ttnT/T, kep(:, 2), kepc(:, 2))   % e
KepHistoryPlot("i",  ttnT/T, kep(:, 3), kepc(:, 3))   % i
KepHistoryPlot("OM", ttnT/T, kep(:, 4), kepc(:, 4))   % OM
KepHistoryPlot("om", ttnT/T, kep(:, 5), kepc(:, 5))   % om
KepHistoryPlot("f",  ttnT/T, kep(:, 6), kepc(:, 6))   % f

%% 6) Represent the evolution of the orbit
% Perturbed orbit plot
plotOrbit( ...
    rrTpc, ...
    "evolution", ttnT, ...
    "velocity", vvTpc, ...
    "title", "Perturbed Orbit View", ...
    "subtitle", sprintf("%d Revolutions", n) ...
    );

legend("Earth", "Atmosphere", "Perturbed Orbit", 'location', 'southwest')

% Change view
view(75, 40)

%% 7) Filtering of high frequencies 
% Moving Mean LPF
kepf = MovmeanLPF(ttnT, kepc, 20*T);

% Comparing both propagation methods (unfiltered and filtered)
KepHistoryPlot("a",  ttnT/T, kep(:, 1), kepc(:, 1), "filtered", kepf(:, 1), "errorPlot", true)   % a
KepHistoryPlot("e",  ttnT/T, kep(:, 2), kepc(:, 2), "filtered", kepf(:, 2), "errorPlot", true)   % e
KepHistoryPlot("i",  ttnT/T, kep(:, 3), kepc(:, 3), "filtered", kepf(:, 3), "errorPlot", true)   % i
KepHistoryPlot("OM", ttnT/T, kep(:, 4), kepc(:, 4), "filtered", kepf(:, 4), "errorPlot", true)   % OM
KepHistoryPlot("om", ttnT/T, kep(:, 5), kepc(:, 5), "filtered", kepf(:, 5), "errorPlot", true)   % om
KepHistoryPlot("f",  ttnT/T, kep(:, 6), kepc(:, 6), "filtered", kepf(:, 6), "errorPlot", true)   % f

%% 8) Comparison with real data
% Clear previous variables
clear; clc;

% Central planet
cen_planet = celestialBody("Earth");  % Central Planet (Earth)

% Load ephemerides of selected orbit
ephemerides = readtable('horizons_results.xlsx');

% Time span
timespan = jd2mjd2000(ephemerides{:, 'JDTDB'});       % MJD2000

% Initial orbital elements of selected orbit
a0 = ephemerides{1, 'A'};                             % Semi-major axis
e0 = ephemerides{1, 'EC'};                            % Eccentricity
i0 = deg2rad(ephemerides{1, 'IN'});                   % Inclination
OM0 = deg2rad(ephemerides{1, 'OM'});                  % RAAN
om0 = deg2rad(ephemerides{1, 'W'});                   % Argument of pericentre
f0 = deg2rad(ephemerides{1, 'TA'});                   % True Anomaly

kep0 = [a0 e0 i0 OM0 om0 f0];

% Initial orbital period
T = 2*pi * sqrt(a0^3 / cen_planet.mu); % Orbital period [s]

%% Our model
% Converting time span
tt = (timespan - timespan(1)) * 86400;  % days to seconds

% Introducing perturbations
params = odeParamStruct( ...
    "R", cen_planet.R, ...
    "J2", cen_planet.J2, ...
    "ThirdBody", "Moon", ...
    "initMjd2000", timespan(1) ...  % Initial MJD2000 for Moon ephemerides
);

% Orbit propagation through gauss equations
[~, kep_sim] = OdeSolver("keplerian", kep0, tt, cen_planet.mu, params);

%% Ephemerides
% Orbital elements
a = ephemerides{:, 'A'};                             % Semi-major axis
e = ephemerides{:, 'EC'};                            % Eccentricity
i = deg2rad(ephemerides{:, 'IN'});                   % Inclination
OM = deg2rad(ephemerides{:, 'OM'});                  % RAAN
om = deg2rad(ephemerides{:, 'W'});                   % Argument of pericentre
f = deg2rad(ephemerides{:, 'TA'});                   % True Anomaly

kep_eph = [a e i OM om f];

% Unwrap OM, om and f
kep_eph(:, 4:end) = unwrap(kep_eph(:, 4:end));

%% Comparison
% Comparing our model with real data
KepHistoryPlot("a",  tt/T, kep_sim(:, 1), kep_eph(:, 1), "errorPlot", true, "fName", "Simulated", "sName", "Real")   % a
KepHistoryPlot("e",  tt/T, kep_sim(:, 2), kep_eph(:, 2), "errorPlot", true, "fName", "Simulated", "sName", "Real")   % e
KepHistoryPlot("i",  tt/T, kep_sim(:, 3), kep_eph(:, 3), "errorPlot", true, "fName", "Simulated", "sName", "Real")   % i
KepHistoryPlot("OM", tt/T, kep_sim(:, 4), kep_eph(:, 4), "errorPlot", true, "fName", "Simulated", "sName", "Real")   % OM
KepHistoryPlot("om", tt/T, kep_sim(:, 5), kep_eph(:, 5), "errorPlot", true, "fName", "Simulated", "sName", "Real")   % om
KepHistoryPlot("f",  tt/T, kep_sim(:, 6), kep_eph(:, 6), "errorPlot", true, "fName", "Simulated", "sName", "Real")   % f

