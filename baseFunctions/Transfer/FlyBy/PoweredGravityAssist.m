function [turnAngle, rp, Dv, Dvp] = PoweredGravityAssist(vInfMinus, vInfPlus, mu)
%POWEREDGRAVITYASSIST Summary of this function goes here
%   Detailed explanation goes here

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
    
    % 2D Hyperbolas
    [aMinus, ~] = TwoDHyperbola(mu, "vInf", norm(vInfMinus), "rp", rp);
    [aPlus, ~] = TwoDHyperbola(mu, "vInf", norm(vInfPlus), "rp", rp);

    % Compute Dvp
    vMinusP = sqrt(mu * (2/rp - 1/aMinus));
    vPlusP = sqrt(mu * (2/rp - 1/aPlus));

    Dvp = abs(vPlusP - vMinusP);

    % Compute Dv
    Dv = norm(vInfPlus - vInfMinus);
end
