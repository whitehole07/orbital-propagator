function PlotGroundTrack(lat, lon)
%PlotGroundTrack ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% PlotGroundTrack(lat, lon)
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
    figure("name", "Groundtrack", "numbertitle", "off", "position", [0 0 1200 600])
    
    xlim([-180 180])
    ylim([-90 90])
    
    i = imread("earth.jpg");
    image(xlim, flip(ylim), i);
    
    ax = gca;
    ax.YDir = 'normal';
    
    grid on
    hold on
    
    plot(lon, lat, 'g', 'linestyle', 'none', 'marker', '.')
    plot(lon(1), lat(1), 'go', 'markersize', 15, 'linewidth', 3)
    plot(lon(end), lat(end), 'gs', 'markersize', 15, 'linewidth', 3)
    
    xlabel('Longitude $[deg]$', 'Interpreter', 'latex')
    ylabel('Latitude $[deg]$', 'Interpreter', 'latex')
    legend("Ground track", "Start", "End")
    
    xticks(-180:30:180)
    yticks(-90:30:90)

    hold off
end

