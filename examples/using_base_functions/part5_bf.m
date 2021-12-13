%% Cleaning up useless variables...
clc; close all; clear;

%% FlyBy (Lab 4, Exercise 1a)
% Variables from the pdf
mu_earth = astroConstants(13);
mu_sun = astroConstants(4);
AU = astroConstants(2);

vInfMinus = [15.1; 0; 0];
vInf = norm(vInfMinus); % ||vInf||

impactParam = 9200; % km
r_earth = [1; 0; 0] * AU;

% 2D Hyperbola, same for all
[a, e, ~, ~, ~, turnAngle] = TwoDHyperbola(mu_earth, "vInf", vInf, "impactParam", impactParam);

% Under the planet
u_under = [0; -1; 0];
vInfPlus_under = rotateRodrigues(vInfMinus, u_under, turnAngle);

% Behind the planet
u_behind = [0; 0; 1];
vInfPlus_behind = rotateRodrigues(vInfMinus, u_behind, turnAngle);

% In front of the planet
u_front = [0; 0; -1];
vInfPlus_front= rotateRodrigues(vInfMinus, u_front, turnAngle);

%% FlyBy fixed asymptote location (Lab 4, Exercise 1b)
% Same variables
impactParams = 9200:1000:13200;
n = size(impactParams, 2);

as = zeros(1, n); es = zeros(1, n);
rps = zeros(1, n); turnAngles = zeros(1, n); 
for i = 1:n
    % 2D Hyperbola
    [a, e, ~, ~, rp, turnAngle] = TwoDHyperbola(mu_earth, "vInf", vInf, "impactParam", impactParams(i));
    as(i) = a; es(i) = e; rps(i) = rp; turnAngles(i) = turnAngle;
end

%% Powered gravity assist (Lab 4, Exercise 2)
clear; close all; clc;

% Variables from the pdf
mu_earth = astroConstants(13);
mu_sun = astroConstants(4);
AU = astroConstants(2);

VMinus = [31.5; 4.69; 0];
VPlus = [38.58; 0; 0];

% Earth position and velocity
r_earth = [0; -1; 0] * AU;
v_earth = [sqrt(mu_sun/norm(r_earth)); 0; 0];

% Relative velocities
vInfMinus = VMinus - v_earth;
vInfPlus = VPlus - v_earth;

[turnAngle, rp, Dv, Dvp, a, e] = PoweredGravityAssist(vInfMinus, vInfPlus, mu_earth);

% Validity check
Rp = astroConstants(23);
h_atm = 100; % km (Karman line)

assert(rp > Rp + h_atm, "Radius of pericenter is not physically feasible.")

%% Plot FlyBy
% Keplerian to Cartesian at pericentre
i = 0; OM = 0; om = 0; 
angle = pi/2; % Angle to which the orbits are to be plotted

% States
[rrMinusS, vvMinusS] = KeplerianToCartesian([a(1) e(1) i OM om -angle], mu_earth); % Minus Hyperbola init point
[rrPlusS, vvPlusS] = KeplerianToCartesian([a(2) e(2) i OM om 0], mu_earth); % Pericentre and Plus Hyperbola init point

% - Propagating -
odeOptions = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);

% Minus propagation
tf = AngleToTimeHyperbola(a(1), e(1), mu_earth, angle);
[ttMinus, rrMinus, vvMinus] = OdeSolver(rrMinusS, vvMinusS, [0 tf], mu_earth, Rp, 0, odeOptions);

% Plus propagation
tf = AngleToTimeHyperbola(a(2), e(2), mu_earth, angle);
[ttPlus, rrPlus, vvPlus] = OdeSolver(rrPlusS, vvPlusS, [0 tf], mu_earth, Rp, 0, odeOptions);

% Plotting orbits
title = "Powered Gravity Assist";
% Minus arc and init figure
fig = PlotOrbit(rrMinus, "title", title, "bodyName", "Earth");
% Plus arc
PlotOrbit(rrPlus, "fig", fig);
% Pericentre
PlotOrbit(rrPlusS, "fig", fig);

% Legend
legend("Earth", "Atmosphere", "Incoming hyperbola", "Outcoming hyperbola", "Pericentre")

view(120, 30);

clear; clc;
