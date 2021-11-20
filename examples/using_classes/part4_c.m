%% Mission Express (Lab3, Exercise 4)
clc; close all; clear;

% Useful variables
dep_planet = CelestialBody("Earth");
body = CelestialBody("Sun");

%% Mercury
options = struct("step", 1, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2023 11 1 0 0 0]), ...
    Time("date", [2025 1 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Mercury");
arr_window = TimeWindow( ...
    Time("date", [2024 4 1 0 0 0]), ...
    Time("date", [2025 3 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
mercury = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    mercury.dep_planet.name, mercury.arr_planet.name, ...
    mercury.departure.toStr(), mercury.arrival.toStr(), mercury.Dv);

% Porkchop Plot
mercury.porkchopPlot("zlevel", 50, "zstep", 10, "clabel", false);

clear arr_planet dep_window arr_window options;

%% Venus
options = struct("step", 5, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2024 6 1 0 0 0]), ...
    Time("date", [2026 11 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Venus");
arr_window = TimeWindow( ...
    Time("date", [2024 12 1 0 0 0]), ...
    Time("date", [2027 6 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
venus = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("\n\n%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    venus.dep_planet.name, venus.arr_planet.name, ...
    venus.departure.toStr(), venus.arrival.toStr(), venus.Dv);

% Porkchop Plot
venus.porkchopPlot("zlevel", 50, "zstep", 10, "clabel", false);

clear arr_planet dep_window arr_window options;

%% Mars
options = struct("step", 10, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2025 8 1 0 0 0]), ...
    Time("date", [2031 1 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Mars");
arr_window = TimeWindow( ...
    Time("date", [2026 1 1 0 0 0]), ...
    Time("date", [2032 1 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
mars = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("\n\n%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    mars.dep_planet.name, mars.arr_planet.name, ...
    mars.departure.toStr(), mars.arrival.toStr(), mars.Dv);

% Porkchop Plot
mars.porkchopPlot("zlevel", 50, "zstep", 10, "clabel", false);

clear arr_planet dep_window arr_window options;

%% Jupiter
options = struct("step", 5, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2026 6 1 0 0 0]), ...
    Time("date", [2028 6 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Jupiter");
arr_window = TimeWindow( ...
    Time("date", [2028 6 1 0 0 0]), ...
    Time("date", [2034 1 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
jupiter = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("\n\n%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    jupiter.dep_planet.name, jupiter.arr_planet.name, ...
    jupiter.departure.toStr(), jupiter.arrival.toStr(), jupiter.Dv);

% Porkchop Plot
jupiter.porkchopPlot("zlevel", 50, "zstep", 5, "clabel", false);

clear arr_planet dep_window arr_window options;

%% Saturn
options = struct("step", 5, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2027 9 1 0 0 0]), ...
    Time("date", [2029 10 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Saturn");
arr_window = TimeWindow( ...
    Time("date", [2030 4 1 0 0 0]), ...
    Time("date", [2036 3 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
saturn = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("\n\n%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    saturn.dep_planet.name, saturn.arr_planet.name, ...
    saturn.departure.toStr(), saturn.arrival.toStr(), saturn.Dv);

% Porkchop Plot
saturn.porkchopPlot("zlevel", 50, "zstep", 5, "clabel", false);

clear arr_planet dep_window arr_window options;

%% Uranus
options = struct("step", 5, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2027 9 1 0 0 0]), ...
    Time("date", [2029 1 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Uranus");
arr_window = TimeWindow( ...
    Time("date", [2031 4 1 0 0 0]), ...
    Time("date", [2045 12 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
uranus = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("\n\n%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    uranus.dep_planet.name, uranus.arr_planet.name, ...
    uranus.departure.toStr(), uranus.arrival.toStr(), uranus.Dv);

% Porkchop Plot
uranus.porkchopPlot("zlevel", 50, "zstep", 5, "clabel", false);

clear arr_planet dep_window arr_window options;

%% Neptune
options = struct("step", 5, "verbosity", 0);  % days

% Departure
dep_window = TimeWindow( ...
    Time("date", [2025 1 1 0 0 0]), ...
    Time("date", [2026 10 1 0 0 0]) ...
    );

% Arrival
arr_planet = CelestialBody("Neptune");
arr_window = TimeWindow( ...
    Time("date", [2036 1 1 0 0 0]), ...
    Time("date", [2055 6 1 0 0 0]) ...
    );

% Interplanetary Transfer Object
neptune = InterplanetaryTransfer( ...
    dep_planet, arr_planet, dep_window, arr_window, body, options);

% Some printing
fprintf("\n\n%s to %s\n------------------\nDeparture: %s\nArrival: %s\n\nCost: %.4f km/s\n", ...
    neptune.dep_planet.name, neptune.arr_planet.name, ...
    neptune.departure.toStr(), neptune.arrival.toStr(), neptune.Dv);

% Porkchop Plot
neptune.porkchopPlot("zlevel", 50, "zstep", 5, "clabel", false);

clear arr_planet dep_window arr_window options;