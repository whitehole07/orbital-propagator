function fig = PlotOrbit(r, R, fig)
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
    if nargin < 3
        fig = figure("name", "Orbit", "numbertitle", "off");

        [X, Y, Z] = sphere;
        X = X * R; Y = Y * R; Z = Z * R; % perfect sphere
        surf(X, Y, Z)
    else
        hold on
    end
    
    hold on
    if size(r, 2) == 1
        plot3(r(1), r(2), r(3), '.', 'MarkerSize', 30)
    else
        plot3(r(:,1), r(:,2), r(:,3), 'linewidth', 2)
    end
    hold off    

    title('Orbit view')
    xlabel('$x\>[km]$', 'Interpreter', 'latex')
    ylabel('$y\>[km]$', 'Interpreter', 'latex')
    zlabel('$z\>[km]$', 'Interpreter', 'latex')
    
    axis equal
    grid on
end

