function dy = odeTwoBp(~ , y, mu, Re, j2)
%ODE_2BP Summary of this function goes here
%   Detailed explanation goes here
rv = y(1:3);
vv = y(4:6);

r = norm(rv);

x = rv(1);
y = rv(2);
z = rv(3);

aj2 = (3*j2*mu*(Re^2))/(2*(r^4)) * [(x/r)*(5*(z^2/r^2) - 1) (y/r)*(5*(z^2/r^2) - 1) (z/r)*(5*(z^2/r^2) - 3)]';

dy = [
    vv
    (-mu/r^3)*rv + aj2
    ];

end

