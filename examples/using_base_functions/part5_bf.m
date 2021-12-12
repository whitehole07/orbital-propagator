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

[turnAngle, rp, Dv, Dvp] = PoweredGravityAssist(vInfMinus, vInfPlus, mu_earth);

clear AU mu_earth mu_sun r_earth v_earth vInfPlus vInfMinus VPlus VMinus;
