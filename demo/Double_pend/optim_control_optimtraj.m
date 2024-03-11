function xd = optim_control(x,u) %[ddq1,ddq2] 
m = 1.0;
l = 10.0;
g = 9.81;
c1 = 1;
c2 = 1;
k1 = 0;
k2 = 0;
F1 = u(1,:);
F2 = u(2,:);
% F3 = u;

qq1 = x(1,:);
qq2 = x(2,:);
uu1 = x(3,:);
uu2 = x(4,:);
q1 = qq1;
q2 = qq2;

xd = zeros(4, 1);


% mm = [1 0 0 0; 0 1 0 0; 0 0 l.^2.*m/4 + m.*(l.^2.*cos(qq2) + 5*l.^2/4) m.*(l.^2.*cos(qq2)/2 + l.^2/4); 0 0 m.*(l.^2.*cos(qq2)/2 + l.^2/4) l.^2.*m/4];

% fo = [uu1; uu2; -c1.*uu1 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - 3*g.*l.*m.*cos(qq1)/2 - k1.*qq1 - l.^2.*m.*uu1.^2.*sin(qq2)/2 + l.^2.*m.*(uu1 + uu2).^2.*sin(qq2)/2; -c2.*uu2 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - k2.*qq2 - l.^2.*m.*uu1.^2.*sin(qq2)/2];
% fo = [qq1;qq2;uu1;uu2];
% fe = [0;0;F1.*(5*(5 - 5*cos(q1)).*sin(q1) - 5*(15 - 5*sin(q1)).*cos(q1))./sqrt((5 - 5*cos(q1)).^2 + (15 - 5*sin(q1)).^2) + F2.*((10*sin(q1).*sin(q2) - 10*cos(q1).*cos(q2) - 20*cos(q1)).*(-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15)/2 + (10*sin(q1).*cos(q2) + 20*sin(q1) + 10*sin(q2).*cos(q1)).*(5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6)/2)./sqrt((5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6).^2 + (-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15).^2); F2.*((10*sin(q1).*sin(q2) - 10*cos(q1).*cos(q2)).*(-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15)/2 + (10*sin(q1).*cos(q2) + 10*sin(q2).*cos(q1)).*(5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6)/2)./sqrt((5*sin(q1).*sin(q2) - 5*cos(q1).*cos(q2) - 10*cos(q1) + 6).^2 + (-5*sin(q1).*cos(q2) - 10*sin(q1) - 5*sin(q2).*cos(q1) + 15).^2) + F3.*(-5*(3 - 5*sin(q2)).*cos(q2) + 5*(-5*cos(q2) - 6).*sin(q2))./sqrt((3 - 5*sin(q2)).^2 + (-5*cos(q2) - 6).^2)];

% R = mm\(fo+fe);
eoms = [uu1; uu2; (8*cos(qq2) + 4).*(F2 - c2.*uu2 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - k2.*qq2 - l.^2.*m.*uu1.^2.*sin(qq2)/2)./(4*l.^2.*m.*cos(qq2).^2 - 5*l.^2.*m) - 4*(F1 + F2 - c1.*uu1 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - 3*g.*l.*m.*cos(qq1)/2 - k1.*qq1 - l.^2.*m.*uu1.^2.*sin(qq2)/2 + l.^2.*m.*(uu1 + uu2).^2.*sin(qq2)/2)./(4*l.^2.*m.*cos(qq2).^2 - 5*l.^2.*m); (-16*cos(qq2) - 24).*(F2 - c2.*uu2 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - k2.*qq2 - l.^2.*m.*uu1.^2.*sin(qq2)/2)./(4*l.^2.*m.*cos(qq2).^2 - 5*l.^2.*m) + (8*cos(qq2) + 4).*(F1 + F2 - c1.*uu1 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - 3*g.*l.*m.*cos(qq1)/2 - k1.*qq1 - l.^2.*m.*uu1.^2.*sin(qq2)/2 + l.^2.*m.*(uu1 + uu2).^2.*sin(qq2)/2)./(4*l.^2.*m.*cos(qq2).^2 - 5*l.^2.*m)];

xd = [eoms(1,:);eoms(2,:);eoms(3,:);eoms(4,:)];
% xd = R;