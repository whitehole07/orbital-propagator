function InterplanetaryPlot(deps, gas, arrs, dep, ga, arr, ...
    dep_planet, ga_planet, arr_planet, central_body, varargin)
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
        "transfOrbitColor", '#77AC30', ...
        "timeWindow", false, ...
        "cenBodyScaleFactor", 1, ...
        "depBodyScaleFactor", 1, ...
        "flybyBodyScaleFactor", 1, ...
        "arrBodyScaleFactor", 1 ...
        );

    para = variableArguments(optionsStruct, varargin, true);

    % Get bodies
    dep_planet = celestialBody(dep_planet);
    ga_planet = celestialBody(ga_planet);
    arr_planet = celestialBody(arr_planet);
    central_body = celestialBody(central_body);

    % Time windows
    dep_from = deps(1); dep_to = deps(end);        % Departure
    ga_from = gas(1); ga_to = gas(end);            % FlyBy
    arr_from = arrs(1); arr_to = arrs(end);        % Arrivals

    figure("name", "Interplanetary Transfer", "numbertitle", "off", "position", [100 100 1300 700]);

    % Initial state
    [kep_di, ~] = uplanet(dep, dep_planet.id);  % Departure Planet
    [kep_ai, ~] = uplanet(dep, arr_planet.id);  % Arrival Planet

    [rdi, vdi] = KeplerianToCartesian(kep_di, central_body.mu);  % Position/Velocity departure planet
    [rai, vai] = KeplerianToCartesian(kep_ai, central_body.mu);  % Position/Velocity arrival planet

    % FlyBy state
    [kep_ga, ~] = uplanet(ga, ga_planet.id);                     % FlyBy Planet
    [rga, vga] = KeplerianToCartesian(kep_ga, central_body.mu);  % Position/Velocity flyby planet

    % Final state
    [kep_df, ~] = uplanet(arr, dep_planet.id);  % Departure Planet
    [kep_af, ~] = uplanet(arr, arr_planet.id);  % Arrival Planet
    
    [rdf, vdf] = KeplerianToCartesian(kep_df, central_body.mu);  % Position/Velocity departure planet
    [raf, vaf] = KeplerianToCartesian(kep_af, central_body.mu);  % Position/Velocity arrival planet

    % Time of transfer
    Dt1 = (ga - dep) * 86400; Dt2 = (arr - ga) * 86400; Dt = Dt1 + Dt2;

    % Compute Dv
    [Dv, ~, vls] = ComputeDv(dep, ga, arr, dep_planet.id, ga_planet.id, ga_planet.mu, arr_planet.id, central_body.mu);

    % Velocities
    v1l = vls(:, 1:2); v2l = vls(:, 3:4);

    % Neglect perturbing accelerations
    % Orbit propagation
    [~, rd, ~] = OdeSolver("cartesian", [rdi, vdi], [0 Dt], central_body.mu);         % Departure Orbit
    [~, rt1, ~] = OdeSolver("cartesian", [rdi, v1l(:, 1)], [0 Dt1], central_body.mu);  % Transfer Orbit 1
    [~, rt2, ~] = OdeSolver("cartesian", [rga, v2l(:, 1)], [0 Dt2], central_body.mu);  % Transfer Orbit 2
    [~, ra, ~] = OdeSolver("cartesian", [rai, vai], [0 Dt], central_body.mu);         % Arrival Orbit

    % Time Window
    if para.timeWindow
        [kep_dtwf, ~] = uplanet(dep_from, dep_planet.id);   % Departure Planet
        [kep_gatwf, ~] = uplanet(ga_from, ga_planet.id);    % FlyBy Planet
        [kep_atwf, ~] = uplanet(arr_from, arr_planet.id);   % Arrival Planet
    
        [rdtwf, vdtwf] = KeplerianToCartesian(kep_dtwf, central_body.mu);     % Position/Velocity departure planet
        [rgatwf, vgatwf] = KeplerianToCartesian(kep_gatwf, central_body.mu);  % Position/Velocity departure planet
        [ratwf, vatwf] = KeplerianToCartesian(kep_atwf, central_body.mu);     % Position/Velocity arrival planet
    
        twd = (dep_to - dep_from) * 86400;  % Departure window duration
        twga = (ga_to - ga_from) * 86400;   % FlyBy window duration
        twa = (arr_to - arr_from) * 86400;  % Arrival window duration

        [~, rdtw, ~] = OdeSolver("cartesian", [rdtwf, vdtwf], [0 twd], central_body.mu);      % Departure Orbit
        [~, rgatw, ~] = OdeSolver("cartesian", [rgatwf, vgatwf], [0 twga], central_body.mu);  % FlyBy Orbit
        [~, ratw, ~] = OdeSolver("cartesian", [ratwf, vatwf], [0 twa], central_body.mu);      % Arrival Orbit
    end

    % Orbit Properties
    [Td, ~, ~, ~] = orbitProperties(rdi, vdi, central_body.mu);   % Departure Planet Orbit Period
    [Tga, ~, ~, ~] = orbitProperties(rga, vga, central_body.mu);  % FlyBy Planet Orbit Period
    [Ta, ~, ~, ~] = orbitProperties(rai, vai, central_body.mu);   % Arrival Planet Orbit Period

    % rest of the orbit
    [~, rdr, ~] = OdeSolver("cartesian", [rdf, vdf], [0 Td-Dt], central_body.mu);    % Departure Orbit
    [~, rgar, ~] = OdeSolver("cartesian", [rga, vga], [0 Tga], central_body.mu);     % FlyBy Orbit (WHOLE ORBIT!)
    [~, rar, ~] = OdeSolver("cartesian", [raf, vaf], [0 Ta-Dt], central_body.mu);    % Arrival Orbit
    
    % Orbit arcs
    plot3(rd(:,1), rd(:,2), rd(:,3), 'linewidth', 3, 'Color', dep_planet.color)       % Departure Orbit
    hold on
    plot3(rt1(:,1), rt1(:,2), rt1(:,3), 'linewidth', 3, 'Color', para.transfOrbitColor) % Transfer Orbit 1
    plot3(rt2(:,1), rt2(:,2), rt2(:,3), 'linewidth', 3, 'Color', para.transfOrbitColor) % Transfer Orbit 2
    plot3(ra(:,1), ra(:,2), ra(:,3), 'linewidth', 3, 'Color', arr_planet.color)       % Arrival Orbit

    % Rest of the orbit
    plot3(rdr(:,1), rdr(:,2), rdr(:,3), '--', 'linewidth', 3, 'Color', dep_planet.color)
    plot3(rar(:,1), rar(:,2), rar(:,3), '--', 'linewidth', 3, 'Color', arr_planet.color)

    % Whole FlyBy Orbit
    plot3(rgar(:,1), rgar(:,2), rgar(:,3), '--', 'linewidth', 3, 'Color', ga_planet.color)

    % Time Window plot
    if para.timeWindow
        timeWindowOpacity = 0.2;
        dtw = plot3(rdtw(:,1), rdtw(:,2), rdtw(:,3), 'linewidth', 20, 'Color', dep_planet.color);      % Departure Orbit Time window
        gatw = plot3(rgatw(:,1), rgatw(:,2), rgatw(:,3), 'linewidth', 20, 'Color', ga_planet.color);  % FlyBy Orbit Time window
        atw = plot3(ratw(:,1), ratw(:,2), ratw(:,3), 'linewidth', 20, 'Color', arr_planet.color);      % Arrival Orbit Time window
        dtw.Color(4) = timeWindowOpacity; atw.Color(4) = timeWindowOpacity; gatw.Color(4) = timeWindowOpacity;
    end

    % Plot Bodies
    plotBody([0 0 0], central_body.name, para.cenBodyScaleFactor)   % Central Planet

    plotBody(rdi, dep_planet.name, para.depBodyScaleFactor) % Initial state departure planet
    plotBody(rdf, dep_planet.name, para.depBodyScaleFactor) % Final state departure planet

    plotBody(rga, ga_planet.name, para.flybyBodyScaleFactor)  % FlyBy state flyby planet

    plotBody(rai, arr_planet.name, para.arrBodyScaleFactor) % Initial state arrival planet
    plotBody(raf, arr_planet.name, para.arrBodyScaleFactor) % Final state arrival planet
    
    % Text
    min_str = strcat(num2str(Dv), " \frac{km}{s}$");
    dep_str = datestr(mjd20002date(dep));
    arr_str = datestr(mjd20002date(arr));
    title(sprintf("From %s to %s", dep_planet.name, arr_planet.name), ...
        sprintf("Departure: %s - Arrival: %s\n %s", dep_str, arr_str, ...
        strcat("$\Delta v_{min} = ", min_str)), "interpreter", "latex", "FontSize", 15);

    xlabel('$x\>[km]$', 'Interpreter', 'latex')
    ylabel('$y\>[km]$', 'Interpreter', 'latex')
    zlabel('$z\>[km]$', 'Interpreter', 'latex')
    
    if para.timeWindow
        legend(sprintf("%s motion during transfer", dep_planet.name), ...
               "Transfer arc", sprintf("%s motion during transfer", arr_planet.name), ...
               sprintf("%s orbit", dep_planet.name), sprintf("%s orbit", arr_planet.name), ...
               "Departure window", "Arrival window", 'Location', 'southeast')
    else
        legend(sprintf("%s motion during transfer", dep_planet.name), ...
               "Transfer arc", sprintf("%s motion during transfer", arr_planet.name), ...
               sprintf("%s orbit", dep_planet.name), sprintf("%s orbit", arr_planet.name), ...
               'Location', 'southeast')
    end
    
    axis equal
    grid on
end

