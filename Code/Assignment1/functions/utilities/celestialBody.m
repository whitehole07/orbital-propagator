function body = celestialBody(name)
%CELESTIALBODY Summary of this function goes here
%   Detailed explanation goes here
    body = struct("name", name);
    switch lower(name)
        case "sun"
            body.id = 10;
            body.mu = astroConstants(4);
            body.R = astroConstants(3);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 0;
            body.atm_color = NaN;
            body.color = "#ffb121";
        case "mercury"
            body.id = 1;
            body.mu = astroConstants(11);
            body.R = astroConstants(21);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 0;
            body.atm_color = NaN;
            body.color = "#808080";
        case "venus"
            body.id = 2;
            body.mu = astroConstants(12);
            body.R = astroConstants(22);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 250;
            body.atm_color = "yellow";
            body.color = "#d8ff17";
        case "earth"
            body.id = 3;
            body.mu = astroConstants(13);
            body.R = astroConstants(23);
            body.J2 = astroConstants(9);
            body.om = 7.2916e-05;
            body.h_atm = 100;
            body.atm_color = "blue";
            body.color = "#177cff";
        case "mars"
            body.id = 4;
            body.mu = astroConstants(14);
            body.R = astroConstants(24);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 88;
            body.atm_color = "red";
            body.color = "#ff4733";
        case "jupiter"
            body.id = 5;
            body.mu = astroConstants(15);
            body.R = astroConstants(25);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 0;
            body.atm_color = NaN;
            body.color = "#ff9633";
        case "saturn"
            body.id = 6;
            body.mu = astroConstants(16);
            body.R = astroConstants(26);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 0;
            body.atm_color = NaN;
            body.color = "#ff8945";
        case "uranus"
            body.id = 7;
            body.mu = astroConstants(17);
            body.R = astroConstants(27);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 0;
            body.atm_color = NaN;
            body.color = "#45d7ff";
        case "neptune"
            body.id = 8;
            body.mu = astroConstants(18);
            body.R = astroConstants(28);
            body.J2 = 0; % Undefined/Unnecessary
            body.om = NaN; % Undefined/Unnecessary
            body.h_atm = 0;
            body.atm_color = NaN;
            body.color = "#4570ff";
        otherwise
            error("Unknown specified celestial body.")
    end
end

