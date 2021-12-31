function fig = plotOrbit(r, varargin)
%PlotOrbit ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% fig = PlotOrbit(r, R, fig)
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
        "fig", NaN, ...
        "title", "Orbit view", ...
        "subtitle", "", ...
        "axisUnit", "km", ...
        "scaleFactor", 1, ...
        "bodyName", "Earth", ...
        "bodyPos", [0 0 0] ...
        );

    para = variableArguments(optionsStruct, varargin, true);

    if ~isa(para.fig, 'matlab.ui.Figure')
        fig = figure("name", "Orbit", "numbertitle", "off", "position", [100 100 1300 800]);

        plotBody(para.bodyPos, para.bodyName, para.scaleFactor);

        title(para.title, para.subtitle, "interpreter", "latex", "FontSize", 15)
        xlabel(sprintf('$x\\>[%s]$', para.axisUnit), 'Interpreter', 'latex')
        ylabel(sprintf('$y\\>[%s]$', para.axisUnit), 'Interpreter', 'latex')
        zlabel(sprintf('$z\\>[%s]$', para.axisUnit), 'Interpreter', 'latex')

        axis equal
        grid on
    end
    
    hold on
    if size(r, 2) == 1
        plot3(r(1), r(2), r(3), '.', 'MarkerSize', 30)
    else
        plot3(r(:,1), r(:,2), r(:,3), 'linewidth', 2)
    end
    hold off    
end

