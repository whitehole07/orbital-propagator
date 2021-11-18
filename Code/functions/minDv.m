function [departure, arrival, Dv] = minDv(departure, arrival, departure_planet, arrival_planet)
%MINDV Summary of this function goes here
%   Detailed explanation goes here  
    function Dv = toBeMinimized(times)
        P1 = departure_planet.ephemerides(times(1));
        P2 = arrival_planet.ephemerides(times(2));
        Dva = lambertTransfer(P1.r, P2.r, P1.v, P2.v, P2.t - P1.t, P1.body.mu);
        Dv = sum(Dva);
    end

    fun = @(times) toBeMinimized(times);
    X0 = [departure, arrival];

    [X, Dv] = fminunc(fun, X0);
    departure = X(1); arrival = X(2);
end

