function plotGroundTrack(lat, lon)
%PLOTGROUNDTRACK Summary of this function goes here
%   Detailed explanation goes here
    figure("name", "Groundtrack", "numbertitle", "off", "position", [0 0 1200 600])
    
    xlim([-180 180])
    ylim([-90 90])
    
    i = imread("earth.jpg");
    image(xlim, ylim, i);
    
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

