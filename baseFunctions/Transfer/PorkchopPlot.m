function PorkchopPlot(deps, arrs, Dvs, varargin)
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
    optionsStruct = struct( ...
            "minDv", min(min(Dvs)), ...
            "title", "", ...
            "zlevel", 5, ...
            "zstep", 1, ...
            "clabel", true ...
            );

    para = variableArguments(optionsStruct, varargin, true);

    % mjd2000 To datenum
    departures = zeros(size(deps, 2), 1); for x = 1:size(deps, 2); departures(x, :) = datenum(mjd20002date(deps(x))); end
    arrivals = zeros(size(arrs, 2), 1); for x = 1:size(arrs, 2); arrivals(x, :) = datenum(mjd20002date(arrs(x))); end

    % Plot range
    minDv_int = floor(para.minDv);
    range = minDv_int:para.zstep:minDv_int+para.zlevel;

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
    min_str = strcat(num2str(para.minDv), " \frac{km}{s}$]");
    title(para.title, strcat("$\Delta v(t_1, t_2)$ [$\Delta v_{min} = ", min_str), "interpreter", "latex", "FontSize", 15);
    xlabel("Departure date");
    ylabel("Arrival date");

    % Axis
    xtickangle(45);

    % Tick as date
    datetick('x', 'yyyy mmm dd', 'keepticks');
    datetick('y', 'yyyy mmm dd', 'keepticks');

    % Plot minimum point
    plot(min_dep, min_arr, 'xr', 'MarkerSize', 10);

    % Addind a colorbar
    caxis([minDv_int minDv_int+para.zlevel])
    if para.clabel; clabel(C, h, range); end
    cb = colorbar;
    title(cb, "$\Delta v\,[\frac{km}{s}]$", "interpreter", "latex");
end

