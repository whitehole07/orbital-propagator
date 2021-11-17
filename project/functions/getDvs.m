function [departure, arrival, Dvs] = getDvs(departure_window, departure_planet, arrival_window, arrival_planet, step)
%COST Summary of this function goes here
%   Detailed explanation goes here
    arguments
        departure_window TimeWindow
        departure_planet CelestialBody
        arrival_window TimeWindow
        arrival_planet CelestialBody
        step (1, 1) double = 0.1  % days
    end
    
    % Get iterator
    departure = departure_window.getIterator(step);
    arrival = arrival_window.getIterator(step);
    
    % Init variables
    Dvs = zeros(size(departure, 2), size(arrival, 2));

    for i = 1:size(departure, 2)
        % Initial state
        P1 = departure_planet.ephemerides(departure(i).mjd2000);
        
        for j = 1:size(arrival, 2)
            % Final state
            P2 = arrival_planet.ephemerides(arrival(j).mjd2000);
            
            % Lambert
            [~, ~, Dv] = lambertTransfer(P1, P2, P2.t - P1.t, false);
            
            % Updating output variables
            Dvs(i, j) = sum(Dv);
            % states_arcs(i, j) = struct("P1", P1, "P2", P2, "arc", arc);
        end
    end

end

