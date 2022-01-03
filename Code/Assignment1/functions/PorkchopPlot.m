function PorkchopPlot(deps, arrs, Dvs, varargin)
%PorkchopPlot of a set of interplanetary transfers for the two-body problem (patched
%conics approximation) and detection of minimum Delta V transfer inside the
%plot
%
% PROTOTYPE:
% PorkchopPlot(deps, arrs, Dvs, varargin)
%
% INPUT:
% deps      [nx1]  Array of departure times                              [T]
% arrs      [mx1]  Array of arrival times                                [T]
% Dvs       [nxm]  Matrix of DeltaV for interplanetary transfers         [L/T]
% varargin  [nx1]  Array of variables for variableArguments.m            [various]
%
% 
%
% CONTRIBUTORS:
% Daniele Agamennone, Francesca Gargioli
%
% VERSIONS
% 2021-10-20: First version
%   
    optionsStruct = struct( ...
            "minDv", min(Dvs, [], 'all'), ...
            "title", "", ...
            "zlevel", 5, ...
            "zstep", 1, ...
            "clabel", true ...
            );

    para = variableArguments(optionsStruct, varargin, true);
    
    % Transpose Dvs
    Dvs = Dvs';

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

