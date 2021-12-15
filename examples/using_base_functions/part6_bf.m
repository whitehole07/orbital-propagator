%% Cleaning up useless variables...
clc; close all; clear;

%% Orbit propagation with Gauss Equations (Lab 5, Exercise 1.1)
% Data
mu_earth = astroConstants(13);
R_earth = astroConstants(23);
J2_earth = astroConstants(9);

% Initial state
kep0 = [7571 0.01 deg2rad(87.9) pi pi 0];                  % Keplerian elements
[r0, v0] = KeplerianToCartesian(kep0, mu_earth);           % Cartesian coordinates

% Propagation time
N = 100;                            % Number of revolutions
S = 10000;                          % Number of steps
T = 2*pi*sqrt(kep0(1)^3/mu_earth);  % Orbital period [s]
tspan = linspace(0, N*T, S);

% - Propagating -
% Physical parameters for perturbations
params = odeParamStruct("R", R_earth, "J2", J2_earth); % Perturbing effect due to J2

% Keplerian propagation
% Ode solver
[~, kep] = OdeSolver("keplerian", kep0, tspan, mu_earth, params);

% Cartesian propagation
% Ode solver
[~, rr, vv] = OdeSolver("cartesian", [r0 v0], tspan, mu_earth, params);

%% Cartesian coordinates to Keplerian elements
kep_from_cart = zeros(S, 6);
rev = 0; prev = 0; % We need these to unwrap the true anomaly
for i = 1:S
    kep_from_cart(i, :) = CartesianToKeplerian(rr(i, :), vv(i, :), mu_earth);
    kep_from_cart(i, end) = kep_from_cart(i, end) + rev * 2*pi;
    if kep_from_cart(i, end) < prev
        rev = rev + 1;
        kep_from_cart(i, end) = kep_from_cart(i, end) + 2*pi;
    end
    prev = kep_from_cart(i, end);
end

%% (Absolute) Error plots
errorPlot(tspan/T, kep(:, 1), kep_from_cart(:, 1), "a", "Semi-major axis", "km")           % a
errorPlot(tspan/T, kep(:, 2), kep_from_cart(:, 2), "e", "Eccentricity", "-")               % e
errorPlot(tspan/T, kep(:, 3), kep_from_cart(:, 3), "i", "Inclination", "rad")              % i
errorPlot(tspan/T, kep(:, 4), kep_from_cart(:, 4), "OM", "RAAN", "rad")                    % OM
errorPlot(tspan/T, kep(:, 5), kep_from_cart(:, 5), "om", "Argument of Periapsis", "rad")   % om
errorPlot(tspan/T, kep(:, 6), kep_from_cart(:, 6), "f", "True Anomaly", "rad")             % f

clear; clc;