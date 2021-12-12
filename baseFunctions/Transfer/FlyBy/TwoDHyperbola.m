function [a, e, vInf, impactParam, rp, turnAngle] = TwoDHyperbola(mu, varargin)
%FlyBy2DHyperbola ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [a, e, rp, turnAngle] = FlyBy2DHyperbola(vInf, impactParam, mu);
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
    argumentsStruct = struct( ...
            "vInf", NaN, ...
            "impactParam", NaN, ...
            "rp", NaN, ...
            "turnAngle", NaN ...
            );
                          
    para = variableArguments(argumentsStruct, varargin, true);
    
    % Solve 2D Parabola
    if ~any(isnan([para.vInf para.impactParam]))
        vInf = para.vInf; impactParam = para.impactParam;

        a = -mu / para.vInf^2;
        turnAngle = 2 * atan(-a / para.impactParam);
        e = 1 / sin(turnAngle / 2);
        rp = a * (1 - e);
    elseif ~any(isnan([para.vInf para.rp]))
        vInf = para.vInf; rp = para.rp;

        a = -mu / para.vInf^2;
        e = 1 + (para.rp * para.vInf^2)/mu;
        turnAngle = 2 * asin(1 / e);
        impactParam = -a * e * cos(turnAngle / 2);
    else
        error("Not supported. Possible combinations: (vInf, impactParam), (vInf, rp).")
    end
end

