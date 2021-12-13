function InterplanetaryPlot(dep_from, dep_to, arr_from, arr_to, dep, arr, ...
    dep_planet_id, arr_planet_id, body_mu, varargin)
%DvsMatrix ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [rr, vv] = KeplerianToCartesian(a, e, i, OM, om, f, mu)
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
% 2021-11-20: First version
%

    optionsStruct = struct( ...
        "depOrbitColor", '#419ad9', ...
        "depPlanetColor", '#419ad9', ...
        "arrOrbitColor", '#d96f41', ...
        "arrPlanetColor", '#d96f41', ...
        "cenPlanetColor", '#ebda42', ...
        "transfOrbitColor", '#77AC30', ...
        "depPlanetName", "Departure Planet", ...
        "arrPlanetName", "Arrival Planet", ...
        "timeWindow", false ...
        );

    para = variableArguments(optionsStruct, varargin, true);

    figure("name", "Interplanetary Transfer", "numbertitle", "off", "position", [100 100 1300 700]);

    % Initial state
    [kep_di, ~] = uplanet(dep, dep_planet_id);  % Departure Planet
    [kep_ai, ~] = uplanet(dep, arr_planet_id);  % Arrival Planet

    [rdi, vdi] = KeplerianToCartesian(kep_di, body_mu);  % Position/Velocity departure planet
    [rai, vai] = KeplerianToCartesian(kep_ai, body_mu);  % Position/Velocity arrival planet

    % Final state
    [kep_df, ~] = uplanet(arr, dep_planet_id);  % Departure Planet
    [kep_af, ~] = uplanet(arr, arr_planet_id);  % Arrival Planet
    
    [rdf, vdf] = KeplerianToCartesian(kep_df, body_mu);  % Position/Velocity departure planet
    [raf, vaf] = KeplerianToCartesian(kep_af, body_mu);  % Position/Velocity arrival planet

    % Time of transfer
    Dt = (arr - dep) * 86400;

    % Transfer arc
    [Dv, v] = LambertTransfer(rdi, raf, vdi, vaf, Dt, body_mu, 0);

    % Orbit propagation
    [~, rd, ~] = OdeSolver(rdi, vdi, [0 Dt], body_mu, 0, 0);  % Departure Orbit
    [~, rt, ~] = OdeSolver(rdi, v(1, :)', [0 Dt], body_mu, 0, 0);  % Transfer Orbit
    [~, ra, ~] = OdeSolver(rai, vai, [0 Dt], body_mu, 0, 0);  % Arrival Orbit

    % Time Window
    if para.timeWindow
        [kep_dtwf, ~] = uplanet(dep_from, dep_planet_id);  % Departure Planet
        [kep_atwf, ~] = uplanet(arr_from, arr_planet_id);  % Arrival Planet
    
        [rdtwf, vdtwf] = KeplerianToCartesian(kep_dtwf, body_mu);  % Position/Velocity departure planet
        [ratwf, vatwf] = KeplerianToCartesian(kep_atwf, body_mu);  % Position/Velocity arrival planet
    
        twd = (dep_to - dep_from) * 86400;  % Departure window duration
        twa = (arr_to - arr_from) * 86400;  % Arrival window duration

        [~, rdtw, ~] = OdeSolver(rdtwf, vdtwf, [0 twd], body_mu, 0, 0);  % Departure Orbit
        [~, ratw, ~] = OdeSolver(ratwf, vatwf, [0 twa], body_mu, 0, 0);  % Arrival Orbit
    end

    % Orbit Properties
    [Td, ~, ~, ~] = OrbitProperties(rdi, vdi, body_mu);  % Departure Planet Orbit Period
    [Ta, ~, ~, ~] = OrbitProperties(rai, vai, body_mu);  % Arrival Planet Orbit Period

    % rest of the orbit
    [~, rdr, ~] = OdeSolver(rdf, vdf, [0 Td-Dt], body_mu, 0, 0);  % Departure Orbit
    [~, rar, ~] = OdeSolver(raf, vaf, [0 Ta-Dt], body_mu, 0, 0);  % Arrival Orbit
    
    % 
    plot3(rd(:,1), rd(:,2), rd(:,3), 'linewidth', 3, 'Color', para.depOrbitColor)  % Departure Orbit
    hold on
    plot3(rt(:,1), rt(:,2), rt(:,3), 'linewidth', 3, 'Color', para.transfOrbitColor)
    plot3(ra(:,1), ra(:,2), ra(:,3), 'linewidth', 3, 'Color', para.arrOrbitColor)

    %
    plot3(rdr(:,1), rdr(:,2), rdr(:,3), '--', 'linewidth', 3, 'Color', para.depOrbitColor)
    plot3(rar(:,1), rar(:,2), rar(:,3), '--', 'linewidth', 3, 'Color', para.arrOrbitColor)

    %
    if para.timeWindow
        dtw = plot3(rdtw(:,1), rdtw(:,2), rdtw(:,3), 'linewidth', 20, 'Color', para.depOrbitColor);
        atw = plot3(ratw(:,1), ratw(:,2), ratw(:,3), 'linewidth', 20, 'Color', para.arrOrbitColor);
        dtw.Color(4) = 0.2; atw.Color(4) = 0.2;
    end

    % Plot Bodies
    plot3(0, 0, 0, '.', 'MarkerSize', 40, 'Color', para.cenPlanetColor)
    plot3(rdi(1), rdi(2), rdi(3), '.', 'MarkerSize', 40, 'Color', para.depPlanetColor)  % Departure Planet
    plot3(rdf(1), rdf(2), rdf(3), '.', 'MarkerSize', 40, 'Color', para.depPlanetColor)
    plot3(rai(1), rai(2), rai(3), '.', 'MarkerSize', 40, 'Color', para.arrPlanetColor)
    plot3(raf(1), raf(2), raf(3), '.', 'MarkerSize', 40, 'Color', para.arrPlanetColor)

    min_str = strcat(num2str(sum(Dv)), " \frac{km}{s}$");
    dep_str = datestr(mjd20002date(dep));
    arr_str = datestr(mjd20002date(arr));
    title(sprintf("From %s to %s", para.depPlanetName, para.arrPlanetName), ...
        sprintf("Departure: %s - Arrival: %s\n %s", dep_str, arr_str, ...
        strcat("$\Delta v_{min} = ", min_str)), "interpreter", "latex", "FontSize", 15);

    xlabel('$x\>[km]$', 'Interpreter', 'latex')
    ylabel('$y\>[km]$', 'Interpreter', 'latex')
    zlabel('$z\>[km]$', 'Interpreter', 'latex')
    
    if para.timeWindow
        legend(sprintf("%s motion during transfer", para.depPlanetName), ...
               "Transfer arc", sprintf("%s motion during transfer", para.arrPlanetName), ...
               sprintf("%s orbit", para.depPlanetName), sprintf("%s orbit", para.arrPlanetName), ...
               "Departure window", "Arrival window", 'Location', 'southeast')
    else
        legend(sprintf("%s motion during transfer", para.depPlanetName), ...
               "Transfer arc", sprintf("%s motion during transfer", para.arrPlanetName), ...
               sprintf("%s orbit", para.depPlanetName), sprintf("%s orbit", para.arrPlanetName), ...
               'Location', 'southeast')
    end
    
    axis equal
    grid on
end

