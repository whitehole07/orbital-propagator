function PorkchopPlot(deps, arrs, Dvs)
%PorkchopPlot ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [Dv, v] = lambertTransfer(r1, r2, v1, v2, Dt, mu)
%
% INPUT:
% t   [1]    Time (can be omitted, as the system is autonomous)    [T]
% y   [6x1]  Cartesian state of the body (rx, ry, rz, vx, vy, vz)  [L, L/T]
% mu  [1]    Gravitational parameter of the primary                [L^3/T^2]
%
% OUTPUT:
% dy  [6x1] Derivative of the state  [L/T^2, L/T^3]
%
% CONTRIBUTORS:
% Daniele Agamennone
%
% VERSIONS
% 2021-10-20: First version
%   
    % mjd2000 To datenum
    departures = zeros(size(deps, 2), 1); for x = 1:size(deps, 2); departures(x, :) = datenum(mjd20002date(deps(x))); end
    arrivals = zeros(size(arrs, 2), 1); for x = 1:size(arrs, 2); arrivals(x, :) = datenum(mjd20002date(arrs(x))); end

    % Plot range
    min_Dv = ceil(min(min(Dvs)));
    range = min_Dv:min_Dv+5;

    % Find minimum value position inside the Dvs matrix
    [x, y] = find(Dvs == min(min(Dvs)));
    min_dep = departures(y);
    min_arr = arrivals(x);

    % Meshgrid
    [deps, arrs] = meshgrid(departures, arrivals);
    
    % Creating a new figure
    figure("name", "Porkchop Plot", "numbertitle", "off", "position", [100 100 900 700]);

    % Contour plot
    [C, h] = contour(deps, arrs, Dvs, range, 'LineWidth', 1.5);
    hold on
    grid on

    % Title and labels
    min_str = strcat(num2str(min(min(Dvs))), " \frac{km}{s}$]");
    title(strcat("$\Delta v(t_1, t_2)$ [$\Delta v_{min} = ", min_str), "interpreter", "latex", "FontSize", 15);
    xlabel("Departure date");
    ylabel("Arrival date");

    % Axis
    xtickangle(45);

    % Tick as date
    datetick('x', 'yyyy mmm dd', 'keeplimits');
    datetick('y', 'yyyy mmm dd', 'keeplimits');

    % Plot minimum point
    plot(min_dep, min_arr, '.', 'MarkerSize', 10);

    % Addind a colorbar
    caxis([min_Dv min_Dv+5])
    clabel(C, h, range);
    cb = colorbar;
    title(cb, "$\Delta v\,[\frac{km}{s}]$", "interpreter", "latex");
end

