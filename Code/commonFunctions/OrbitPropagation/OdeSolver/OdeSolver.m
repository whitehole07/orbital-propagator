function [t, varargout] = OdeSolver(RF, y0, tspan, mu, params)
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
    arguments
        RF string
        y0 (6, 1) double
        tspan double
        mu (1, 1) double
        params struct = odeParamStruct()
    end

    % Select specified equations of motion
    switch lower(RF)
        case "cartesian"; EoM = @CartesianEoM;
        case "keplerian"; EoM = @KeplerianEoM;
        otherwise; error("Supported reference frames are: 'Cartesian' and 'Keplerian' (RSW).");
    end
    
    % Perturbing Accelerations
    aps = {}; % cell array containing perturbing accelerations
    if ~isnan(params.J2) % If J2 is not NaN
        % Mandatory inputs check
        if isnan(params.R); error("Missing required input: R"); end

        % Adding acceleration due to J2 effect
        aps{end + 1} = @(t, y) aJ2(RF, y, params.J2, params.R, mu);
    end
    if isa(params.ThirdBody, 'string') % If ThirdBody is not NaN
        % Mandatory inputs check
        if isnan(params.initMjd2000); error("Missing required input: initMjd2000"); end

        switch lower(params.ThirdBody)
            case "moon"; af = @aMoon;
            otherwise; error("Supported third bodies are: Moon");
        end

        % Adding acceleration due to third body
        aps{end + 1} = @(t, y) af(RF, y, t, params.initMjd2000);
    end
    
    % Perturbed equations of motion
    PerturbedEoM = @(t, y) EoM(t, y, mu, aps);

    % Ode Solver
    odeOptions = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);
    [t, y] = params.OdeSolver(PerturbedEoM, tspan, y0, odeOptions);

    % To output
    switch lower(RF)
        case "cartesian"; varargout{1} = y(:, 1:3); varargout{2} = y(:, 4:end); % rr, vv [Nx3]
        case "keplerian"; varargout{1} = y;                                     % kep    [Nx6]
    end

%     if nargout >= 4
%         a = [];
%         for i = 1:length(t)
%             a = [a; aJ2(RF, y(i, :)', params.J2, params.R, mu)' aMoon(RF, y(i, :)', t(i), params.initMjd2000)'];
%         end
%         varargout{3} = a;
%     end

end

