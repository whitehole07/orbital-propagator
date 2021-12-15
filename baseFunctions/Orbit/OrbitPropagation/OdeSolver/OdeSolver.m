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
    % Variable Input arguments with default values
    if nargin < 5
        params = odeParamStruct();
    end

    % Select specified equations of motion
    switch lower(RF)
        case "cartesian"; EoM = @CartesianEoM;
        case "keplerian"; EoM = @KeplerianEoM;
        otherwise; error("Supported reference frames are: 'Cartesian' and 'Keplerian' (RSW).");
    end
    
    % Default perturbing acceleration function handle
    ap = @(t, y) 0;
    
    % Perturbing Accelerations
    if ~isnan(params.J2) % If J2 is not zero
        % Mandatory inputs check
        if isnan(params.R); error("Missing required input: R"); end

        % Adding acceleration due to J2 effect
        ap = @(t, y) aJ2(RF, y, params.J2, params.R, mu);
    end
    
    % Perturbed equations of motion
    PerturbedEoM = @(t, y) EoM(t, y, mu, ap);

    % Ode Solver
    odeOptions = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);
    [t, y] = params.OdeSolver(PerturbedEoM, tspan, y0, odeOptions);

    % To output
    if nargout == 3
        varargout{1} = y(:, 1:3); varargout{2} = y(:, 4:end); % rr, vv [vectors]
    else
        varargout{1} = y;                                     % kep [matrix]
    end

end

