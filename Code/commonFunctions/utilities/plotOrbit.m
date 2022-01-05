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
        "interpreter", "", ...
        "axisUnit", "km", ...
        "scaleFactor", 1, ...
        "bodyName", "Earth", ...
        "bodyPos", [0 0 0], ...
        "evolution", [], ... % time vector to plot orbit evolution
        "velocity", [] ...   % velocity array to plot orbit evolution
        );

    para = variableArguments(optionsStruct, varargin, true);

    if ~isa(para.fig, 'matlab.ui.Figure')
        fig = figure("name", "Orbit", "numbertitle", "off", "position", [100 100 1300 800]);

        plotBody(para.bodyPos, para.bodyName, para.scaleFactor);
        
        if strcmpi(para.interpreter, "latex")
            title(para.title, para.subtitle, "interpreter", "latex", "FontSize", 15)
        else
            title(para.title, para.subtitle)
        end

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
        if ~isempty(para.evolution)
            if ~para.velocity; error("Vellocity array needed to plot orbit evolution"); end
            % Get celestial body
            body = celestialBody(para.bodyName);
            
            % Compute specific energy
            rn0 = norm(r(1, :)); vn0 = norm(para.velocity(1, :));
            E = vn0^2/2 - body.mu/rn0;
            
            % Compute semimajor axis and related period
            a = - body.mu / (2*E); t = para.evolution;
            T = 2*pi * sqrt(a^3 / body.mu);
            
            % Avoid patch first and last point problem
            r(end, :) = NaN; r(1, :) = NaN;

            % Plot
            patch(r(:, 1), r(:, 2), r(:, 3), t / T, 'facecolor', 'none', 'edgecolor', 'interp')
            
            % Colorbar
            cb = colorbar;
            caxis([1 ceil(t(end) / T) - 1])
            title(cb, "Periods");
        else
            plot3(r(:,1), r(:,2), r(:,3), 'linewidth', 2)
        end
    end
    hold off    
end

