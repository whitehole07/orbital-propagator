function dy = OdeTwoBp(~, y, mu, R, J2)
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

rv = y(1:3);
vv = y(4:6);

r = norm(rv);

x = rv(1);
y = rv(2);
z = rv(3);

aj2 = (3*J2*mu*(R^2))/(2*(r^4)) * [(x/r)*(5*(z^2/r^2) - 1) (y/r)*(5*(z^2/r^2) - 1) (z/r)*(5*(z^2/r^2) - 3)]';

dy = [
    vv
    (-mu/r^3)*rv + aj2
    ];

end

