function [Dv, v] = LambertTransfer(r1, r2, v1, v2, Dt, mu, verbosity)
%LambertTransfer ODE system for the two-body problem (Keplerian motion)
%
% PROTOTYPE:
% [Dv, v] = lambertTransfer(r1, r2, v1, v2, Dt, mu)
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
    if nargin < 7
        verbosity = 1;
    end

    [~, ~, ~, err, v1l, v2l, ~, ~] = lambertMR(r1, r2, Dt, mu, 0, 0, 0);
    
    
    if nargout > 1
        v = [v1l; v2l];
    end
    
    Dv = [norm(v1l' - v1) norm(v2 - v2l')];

    if err
        switch err
            case 1
                error("Routine failed to converge")
            case -1
                if verbosity; warning("180 degrees transfer"); end
            case 2
                if verbosity; warning("360 degrees transfer"); end      
            case 3
                error("the algorithm doesn't converge because the number of revolutions is bigger than Nrevmax for that TOF")
            case 4
                error("Routine failed to converge, maximum number of iterations exceeded.")
            otherwise
                error("Generic error.")
        end
    end
end

