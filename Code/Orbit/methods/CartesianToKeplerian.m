function [a, e, i, OM, om, f] = CartesianToKeplerian(rr, vv, mu)
%CARTESIANTOKEPLERIAN Summary of this function goes here
%   Detailed explanation goes here
    I = [1; 0; 0];
    J = [0; 1; 0];
    K = [0; 0; 1];

    % Necessary quantities
    % 1
    r = norm(rr); v = norm(vv);
    % 2
    E = v^2/2 - mu/r;
    % 3
    hh = cross(rr,vv); h = norm(hh);
    % 4
    ee = cross(vv,hh)/mu - rr/r;
    % 5
    N = cross(K,hh)/norm(cross(K,hh));

    % 1 - Semimajor axis
    a = -mu/(2*E);

    % 2 - Eccentricity
    e = norm(ee);

    % 3 - Inclination
    cos_i = dot(K,hh)/h;

    i = acos(cos_i);

    % 4 - Right ascension of the ascending node
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

    % 5 - Argument of periapsis
    if i ~= 0 || i ~= pi/2
        cos_om = dot(N,ee)/e;
        e_z = dot(K,ee);
    
        if e_z >= 0
            om = acos(cos_om);
        else
            om = 2*pi-acos(cos_om);
        end
    else
        om = 0;
    end

    % 6 - True anomaly
    cos_f = dot(rr,ee)/(r*e);
    rdr = dot(rr,vv);

    if rdr >= 0
        f = acos(cos_f);
    else
        f = 2*pi-acos(cos_f);
    end

end