function a = aMoon(RF, y, t, init_mjd2000)
%OdeTwoBp ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% dy = OdeTwoBp(~, y, mu, R, J2)
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
    % Get mu's
    muMoon = astroConstants(20);
    muEarth = astroConstants(13);

    % Compute mjd2000
    mjd2000 = init_mjd2000 + (t / 86400);

    switch lower(RF)
        case "cartesian"
            % Extract position vector from state
            rr = y(1:3);
        
            % Earth to Moon vector (geocentric equatorial)
            [rrEarthMoon, ~] = ephMoon(mjd2000); rrEarthMoon = rrEarthMoon';
        
            % Spacecraft to Moon vector (geocentric equatorial)
            rrScMoon = rrEarthMoon - rr;
        
            % Derived parameters
            rEarthMoon = norm(rrEarthMoon); rScMoon = norm(rrScMoon);

            % aMoon expressed with respect to a cartesian reference frame
            a = muMoon * ((rrScMoon/(rScMoon^3)) - (rrEarthMoon/(rEarthMoon^3)));
        case "keplerian"
            % Keplerian to cartesian
            [rr, vv] = KeplerianToCartesian(y, muEarth);

            % Earth to Moon vector (geocentric equatorial)
            [rrEarthMoon, ~] = ephMoon(mjd2000); rrEarthMoon = rrEarthMoon';
        
            % Spacecraft to Moon vector (geocentric equatorial)
            rrScMoon = rrEarthMoon - rr;
        
            % Derived parameters
            rEarthMoon = norm(rrEarthMoon); rScMoon = norm(rrScMoon);
            
            % aMoon expressed with respect to a cartesian reference frame
            ac = muMoon * ((rrScMoon/(rScMoon^3)) - (rrEarthMoon/(rEarthMoon^3)));

            % Rotation Matrix to RSW reference frame
            A_GEO_to_RSW = geoToRSW(rr, vv);

            % aMoon expressed with respect to radial-transversal-out-of-plane reference frame
            a = A_GEO_to_RSW * ac;
        otherwise
            error("Supported references frame are: 'Cartesian' and 'Keplerian' (RSW).");
    end
end

