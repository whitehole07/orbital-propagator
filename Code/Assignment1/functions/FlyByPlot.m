function FlyByPlot(vInfMinus, vInfPlus, body)
%FLYBYPLOT Summary of this function goes here
%   Detailed explanation goes here

    % Get body
    body = celestialBody(body);

    % FlyBy Plot
    [turnAngle, rp, Dvfb, Dvga, a, e, i, OM, om] = PoweredGravityAssist(vInfMinus, vInfPlus, body.mu);
    
    %% Plot FlyBy
    % Keplerian to Cartesian at pericentre
    angle = pi/2; % Angle to which the orbits are to be plotted
    
    % States
    [rrMinusS, vvMinusS] = KeplerianToCartesian([a(1) e(1) i OM om -angle], body.mu); % Minus Hyperbola init state
    [rrPlusS, vvPlusS] = KeplerianToCartesian([a(2) e(2) i OM om 0], body.mu);        % Pericentre and Plus Hyperbola init state
    
    % - Propagating -
    % Neglect perturbing accelerations
    % Minus propagation
    tf = AngleToTimeHyperbola(a(1), e(1), angle, body.mu);
    [~, rrMinus, vvMinus] = OdeSolver("cartesian", [rrMinusS; vvMinusS], [0 tf], body.mu);
    
    % Plus propagation
    tf = AngleToTimeHyperbola(a(2), e(2), angle, body.mu);
    [~, rrPlus, vvPlus] = OdeSolver("cartesian", [rrPlusS; vvPlusS], [0 tf], body.mu);
    
    % Plotting orbits
    title = sprintf("%s - Powered Gravity Assist", body.name);
    subtitle = sprintf( ...
        "$\\delta = %.0f^{\\circ}$, $r_p = %.0f km$ ($R_{%s} = %d km$)\n\n" + ...
        "$\\Delta v_{ga} = %.2f \\frac{km}{s}$ " + ...
        "($\\Delta v_{fb} = %.2f \\frac{km}{s}$)", ...
        rad2deg(turnAngle), rp, body.name, body.R, Dvga, Dvfb);

    % Axis scaling
    rrMinus = rrMinus / body.R; rrPlus = rrPlus / body.R; rrPlusS = rrPlusS / body.R;

    % Minus arc and init figure
    fig = plotOrbit(rrMinus, "title", title, "subtitle", subtitle, ...
        "axisUnit", sprintf("R_{%s}", body.name), "scaleFactor", 1 / body.R, "bodyName", body.name);
    % Plus arc
    plotOrbit(rrPlus, "fig", fig);
    % Pericentre
    plotOrbit(rrPlusS, "fig", fig);

    % Quiver Dvp
    Dvp = vvPlus(1, :) - vvMinus(end, :);
    
    hold on
    quiver3(rrPlusS(1), rrPlusS(2), rrPlusS(3), Dvp(1), Dvp(2), Dvp(3), 'linewidth', 2, 'AutoScale', 'on', 'AutoScaleFactor', 1.5)
    
    % Legend
    if body.h_atm
        legend(body.name, "Atmosphere", "Incoming hyperbola", "Outcoming hyperbola", "Pericentre", "Delta velocity")
    else
        legend(body.name, "Incoming hyperbola", "Outcoming hyperbola", "Pericentre", "Delta GA")
    end
end