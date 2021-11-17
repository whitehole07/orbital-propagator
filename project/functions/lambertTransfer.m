function [arc, v, Dv] = lambertTransfer(orbit_state_i, orbit_state_f, Dt, out_arc)
%LAMBERTORBITTRANSFER Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 4
        out_arc = true;
    end

    body = orbit_state_i.body;
    [~, ~, ~, err, v1, v2, ~, ~] = lambertMR(orbit_state_i.r, orbit_state_f.r, ...
                                             Dt, body.mu, 0, 0, 0);
    
    if ~err
        if out_arc
          arc = OrbitPropagation( ...
              "orbit_state_i", OrbitState("r", orbit_state_i.r, "v", v1', "body", body), ...
              "Dt", Dt ...
              );
        else
            arc = NaN;
        end
        
        v = [v1 v2];
        Dv = [norm(v1' - orbit_state_i.v) norm(orbit_state_f.v - v2')];
    else
        error("Some error encountered in lambertMR.m")
    end
end

