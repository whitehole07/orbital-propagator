function [deps, arrs, Dvs] = getDvs(departure_window, departure_planet, arrival_window, arrival_planet, step)
%COST Summary of this function goes here
%   Detailed explanation goes here
    arguments
        departure_window TimeWindow
        departure_planet CelestialBody
        arrival_window TimeWindow
        arrival_planet CelestialBody
        step (1, 1) double = 5  % days
    end
    
    % Get iterator
    departure = departure_window.getIteratorRaw(step);
    arrival = arrival_window.getIteratorRaw(step);

    [deps, arrs] = meshgrid(departure, arrival);
    
    % Init variables
    Dvs = zeros(size(arrival, 2), size(departure, 2));

    for j = 1:size(departure, 2)
        % Initial state
        P1 = departure_planet.ephemerides(departure(j));
        
        for i = 1:size(arrival, 2)
            % Final state
            P2 = arrival_planet.ephemerides(arrival(i));
            
            % Lambert
            Dv = lambertTransfer(P1.r, P2.r, P1.v, P2.v, P2.t - P1.t, P1.body.mu);
            
            % Updating output variables
            Dvs(i, j) = sum(Dv);
        end
    end

end

