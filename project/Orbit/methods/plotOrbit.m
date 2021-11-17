function fig = plotOrbit(r, R, fig)
%PLOT_ORBIT Summary of this function goes here
%   Detailed explanation goes here    
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

