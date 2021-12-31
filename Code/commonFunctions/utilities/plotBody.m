function plotBody(r, body_name, scale_factor)
%PLOTPLANET Summary of this function goes here
%   Detailed explanation goes here
    
    % Default value
    if nargin < 3; scale_factor = 1; end
    
    % Get Body
    body = celestialBody(body_name);
    
    % Body parameters
    R = body.R * scale_factor;
    body_image = strcat(lower(body_name), ".jpg");
    h_atm = body.h_atm * scale_factor;
    atm_color = body.atm_color;

    % Define the number of panels to be used to model the sphere 
    npanels = 180; 

    % Create a 3D meshgrid of the sphere points using the ellipsoid function
    [x, y, z] = ellipsoid(r(1), r(2), r(3), R, R, R, npanels);

    % Create the globe with the surf function
    globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 'none');

    % Atmosphere
    if h_atm
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

