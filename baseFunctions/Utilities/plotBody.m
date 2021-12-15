function plotBody(r, body_name)
%PLOTPLANET Summary of this function goes here
%   Detailed explanation goes here

    switch lower(body_name)
        case "sun"
            R = astroConstants(3); 
            body_image = "sun.jpg"; 
            h_atm = NaN;
        case "mercury"
            R = astroConstants(21); 
            body_image = "mercury.jpg"; 
            h_atm = NaN;
        case "venus" 
            R = astroConstants(22); 
            body_image = "venus.jpg"; 
            h_atm = 250; 
            atm_color = "yellow";
        case "earth" 
            R = astroConstants(23); 
            body_image = "earth.jpg"; 
            h_atm = 100; 
            atm_color = "blue";
        case "mars" 
            R = astroConstants(24); 
            body_image = "mars.jpg"; 
            h_atm = 88; 
            atm_color = "red";
        case "jupiter" 
            R = astroConstants(25); 
            body_image = "jupiter.jpg"; 
            h_atm = NaN;
        case "saturn" 
            R = astroConstants(26); 
            body_image = "saturn.jpg"; 
            h_atm = NaN;
        case "uranus" 
            R = astroConstants(27); 
            body_image = "uranus.jpg"; 
            h_atm = NaN;
        case "neptune" 
            R = astroConstants(28); 
            body_image = "neptune.jpg"; 
            h_atm = NaN;
        otherwise; error("Unknown specified celestial body.");
    end

    % Define the number of panels to be used to model the sphere 
    npanels = 180; 

    % Create a 3D meshgrid of the sphere points using the ellipsoid function
    [x, y, z] = ellipsoid(r(1), r(2), r(3), R, R, R, npanels);

    % Create the globe with the surf function
    globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 'none');

    % Atmosphere
    if ~isnan(h_atm)
        R_atm = R + h_atm;
        hold on
        [x_atm, y_atm, z_atm] = ellipsoid(r(1), r(2), r(3), R_atm, R_atm, R_atm, npanels);
        surf(x_atm, y_atm, z_atm, 'FaceColor', atm_color, 'FaceAlpha', .1, 'EdgeColor', 'none');
    end

    % Load Planet image for texture map
    cdata = imread(body_image);

    % Set the transparency of the globe: 1 = opaque, 0 = invisible
    alpha = 1;

    % Set the 'FaceColor' to 'texturemap' to apply an image on the globe, and
    % specify the image data using the 'CData' property with the data loaded 
    % from the image. Finally, set the transparency and remove the edges.
    set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');

    axis equal

end

