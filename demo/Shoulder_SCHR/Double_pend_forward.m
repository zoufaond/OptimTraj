function xd = Double_pend_forward(t, x, m, l, g, c1, c2, k1, k2,F1,F2,F3)
% m = 1.0;
% l = 10.0;
% g = 9.81;
% c1 = 10;
% c2 = 10;
% k1 = 100;
% k2 = 100;

q1 = x(1);
q2 = x(2);
u1 = x(3);
u2 = x(4);

xd = zeros(4, 1);


mm = [
1, 0,                                      0,                           0;
0, 1,                                      0,                           0;
0, 0, l^2*m/4 + m*(l^2*cos(q2) + 5*l^2/4), m*(l^2*cos(q2)/2 + l^2/4);
0, 0,            m*(l^2*cos(q2)/2 + l^2/4),                    l^2*m/4];

fo = [
                                                                                                                                        u1;
                                                                                                                                        u2;
-c1*u1 - g*l*m*(-sin(q1)*sin(q2) + cos(q1)*cos(q2))/2 - 3*g*l*m*cos(q1)/2 - k1*q1 + l^2*m*(u1 + u2)^2*sin(q2)/2 - l^2*m*u1^2*sin(q2)/2;
                                                    -c2*u2 - g*l*m*(-sin(q1)*sin(q2) + cos(q1)*cos(q2))/2 - k2*q2 - l^2*m*u1^2*sin(q2)/2];

fe = [0;0;F1.*(5*(5 - 5*cos(q1)).*sin(q1) - 5*(15 - 5*sin(q1)).*cos(q1))./sqrt((5 - 5*cos(q1)).^2 + (15 - 5*sin(q1)).^2) + F2.*((10*sin(q1).*sin(q2) - 10*cos(q1).*cos(q2) - 20*cos(q1)).*(-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15)/2 + (10*sin(q1).*cos(q2) + 20*sin(q1) + 10*sin(q2).*cos(q1)).*(5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6)/2)./sqrt((5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6).^2 + (-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15).^2); F2.*((10*sin(q1).*sin(q2) - 10*cos(q1).*cos(q2)).*(-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15)/2 + (10*sin(q1).*cos(q2) + 10*sin(q2).*cos(q1)).*(5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6)/2)./sqrt((5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6).^2 + (-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15).^2) + F3.*(-5*(3 - 5*sin(q2)).*cos(q2) + 5*(-5*cos(q2) - 6).*sin(q2))./sqrt((3 - 5*sin(q2)).^2 + (-5*cos(q2) - 6).^2)];

R = mm\(fo+fe);

xd(1) = R(1);
xd(2) = R(2);
xd(3) = R(3);
xd(4) = R(4);