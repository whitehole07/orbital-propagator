function [Dv, v] = lambertTransfer(r1, r2, v1, v2, Dt, mu)
%LAMBERTORBITTRANSFER Summary of this function goes here
%   Detailed explanation goes here
%   OUTPUTS: [Dv, arc, v]
    [~, ~, ~, err, v1l, v2l, ~, ~] = lambertMR(r1, r2, Dt, mu, 0, 0, 0);
    
    if ~err
        if nargout > 1
            v = [v1l; v2l];
        end
        
        Dv = [norm(v1l' - v1) norm(v2 - v2l')];
    else
        error("Some error encountered in lambertMR.m")
    end
end

