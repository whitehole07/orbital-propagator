function [turnAngle, rp, Dv, Dvp, a, e, i, OM, om] = PoweredGravityAssist(vInfMinus, vInfPlus, mu, Rlim)
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
% 2021-10-20: First version
%

    function value = rootFunction(rp)
        if rp > 0
            eSignFun = @(rp, vInf) 1 + (rp * vInf^2)/mu;
            turnAngleSignFun = @(rp, vInf) 2 * asin(1./eSignFun(rp, vInf));
            
            turnAngleFun = @(rp) .5 * ( ...
                turnAngleSignFun(rp, norm(vInfMinus)) + ...
                turnAngleSignFun(rp, norm(vInfPlus))) - turnAngle;
    
            value = turnAngleFun(rp);
        else
            value = 1;
        end
    end

    % Turning angle
    turnAngle = acos(dot(vInfMinus, vInfPlus)/(norm(vInfMinus) * norm(vInfPlus)));

    % Compute rp
    x0 = 0; % Initial guess
    rp = fzero(@rootFunction, x0);

    % Validity check
    if nargin >= 4; assert(rp > Rlim, "Radius of pericenter is not physically feasible."); end
    
    %% 2D Hyperbolas
    [aMinus, eMinus] = TwoDHyperbola(mu, "vInf", norm(vInfMinus), "rp", rp);
    [aPlus, ePlus] = TwoDHyperbola(mu, "vInf", norm(vInfPlus), "rp", rp);
    a = [aMinus, aPlus]; e = [eMinus, ePlus];

    %% 3D Hyperbolas
    I = [1; 0; 0];  % X axis direction
    J = [0; 1; 0];  % Y axis direction
    K = [0; 0; 1];  % Z axis direction
    
    u = cross(vInfMinus, vInfPlus) / norm(cross(vInfMinus, vInfPlus));                   % Rotation direction
    N = cross(K, u) / norm(cross(K, u));                                                 % Node line direction
    deltaMinus = 2 * asin(1 / e(1)); betaMinus = (pi - deltaMinus) / 2;                  % Turn angle first hyperbola
    al = rotateRodrigues(vInfMinus, u, betaMinus); al = al / norm(al);                   % Apse line direction

    % Plane coordinates
    % Inclination
    i = acos(dot(K, u));

    % Right ascension of the ascending node
    if i ~= 0 || i ~= pi/2
        cos_OM = dot(I,N);
        sin_OM = dot(J,N);
    
        if sin_OM >= 0
            OM = acos(cos_OM);
        else 
            OM = 2*pi - acos(cos_OM);
        end
    else % if i = 0 singularity
        OM = 0;
    end

    % Argument of periapsis
    if i ~= 0 || i ~= pi/2
        cos_om = dot(N, al);
        al_z = dot(K, al);
    
        if al_z >= 0
            om = acos(cos_om);
        else
            om = 2*pi-acos(cos_om);
        end
    else
        om = 0;
    end

    %% Compute Dvp
    vMinusP = sqrt(mu * (2/rp - 1/aMinus));
    vPlusP = sqrt(mu * (2/rp - 1/aPlus));

    Dvp = abs(vPlusP - vMinusP);

    % Compute Dv
    Dv = norm(vInfPlus - vInfMinus);
end
