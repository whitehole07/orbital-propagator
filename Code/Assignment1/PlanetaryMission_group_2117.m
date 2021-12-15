% Group ID: 2117
% Assignment 1: Interplanetary Explorer Mission
% 
% - Data -
% Departure Planet: Uranus
% FlyBy Planet: Jupiter
% Arrival Planet: Mercury
%
% Earlies Departure: 2030/01/01
% Latest Arrival: 2070/01/01
%

%% Cleaning up the workspace
clear; close all; clc;

%% Data
% Planets ID
dep_planet = 7;      % Departure Planet ID (Uranus)
flyby_planet = 5;    % FlyBy Planet ID (Jupiter)
arr_planet = 1;      % Arrival Planet ID (Mercury)

% Date Array to mjd2000
earliest_dep = date2mjd2000([2030 1 1 0 0 0]);    % Earliest Departure
latest_arr = date2mjd2000([2030 1 1 0 0 0]);      % Latest Arrival

%% 