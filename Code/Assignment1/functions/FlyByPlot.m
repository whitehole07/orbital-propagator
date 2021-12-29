function FlyByPlot(vInfMinus, vInfPlus, body)
%FLYBYPLOT Summary of this function goes here
%   Detailed explanation goes here

    % Get body
    body = celestialBody(body);

    % FlyBy Plot
    [~, ~, ~, ~, a, e, i, OM, om] = PoweredGravityAssist(vInfMinus, vInfPlus, body.mu);
    
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
    [~, rrMinus, ~] = OdeSolver("cartesian", [rrMinusS, vvMinusS], [0 tf], body.mu);
    
    % Plus propagation
    tf = AngleToTimeHyperbola(a(2), e(2), angle, body.mu);
    [~, rrPlus, ~] = OdeSolver("cartesian", [rrPlusS, vvPlusS], [0 tf], body.mu);
    
    % Plotting orbits
    title = "Powered Gravity Assist";
    % Minus arc and init figure
    fig = plotOrbit(rrMinus, "title", title, "bodyName", body.name);
    % Plus arc
    plotOrbit(rrPlus, "fig", fig);
    % Pericentre
    plotOrbit(rrPlusS, "fig", fig);
    
    % Legend
    if body.h_atm
        legend(body.name, "Atmosphere", "Incoming hyperbola", "Outcoming hyperbola", "Pericentre")
    else
        legend(body.name, "Incoming hyperbola", "Outcoming hyperbola", "Pericentre")
    end
end