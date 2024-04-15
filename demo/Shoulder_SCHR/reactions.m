function R = reactions(x1,dx1,ddx1,x2,dx2,ddx2,params,muscles,akt)
mh = params.mh;
ms = params.ms;
g = params.g;
GHsx = params.GHsx;
GHsy = params.GHsy;
GHhx = params.GHhx;
GHhy = params.GHhy;
O_pos = muscles.origin;
I_pos = muscles.insertion;
origin = [2,2];
insertion = [3,4];
l0m = muscles.L0M;
F0m = muscles.F0M;
Rx = g.*mh.*sin(x1) + mh.*(-GHhx.*(-ddx1.*sin(x1).*sin(x2) + ddx1.*cos(x1).*cos(x2) - ddx2.*sin(x1).*sin(x2) + ddx2.*cos(x1).*cos(x2) - dx1.^2.*sin(x1).*cos(x2) - dx1.^2.*sin(x2).*cos(x1) - 2*dx1.*dx2.*sin(x1).*cos(x2) - 2*dx1.*dx2.*sin(x2).*cos(x1) - dx2.^2.*sin(x1).*cos(x2) - dx2.^2.*sin(x2).*cos(x1)) - GHhy.*(-ddx1.*sin(x1).*cos(x2) - ddx1.*sin(x2).*cos(x1) - ddx2.*sin(x1).*cos(x2) - ddx2.*sin(x2).*cos(x1) + dx1.^2.*sin(x1).*sin(x2) - dx1.^2.*cos(x1).*cos(x2) + 2*dx1.*dx2.*sin(x1).*sin(x2) - 2*dx1.*dx2.*cos(x1).*cos(x2) + dx2.^2.*sin(x1).*sin(x2) - dx2.^2.*cos(x1).*cos(x2)) + GHsx.*ddx1.*cos(x1) - GHsx.*dx1.^2.*sin(x1) - GHsy.*ddx1.*sin(x1) - GHsy.*dx1.^2.*cos(x1)).*sin(x1) + mh.*(-GHhx.*(-ddx1.*sin(x1).*cos(x2) - ddx1.*sin(x2).*cos(x1) - ddx2.*sin(x1).*cos(x2) - ddx2.*sin(x2).*cos(x1) + dx1.^2.*sin(x1).*sin(x2) - dx1.^2.*cos(x1).*cos(x2) + 2*dx1.*dx2.*sin(x1).*sin(x2) - 2*dx1.*dx2.*cos(x1).*cos(x2) + dx2.^2.*sin(x1).*sin(x2) - dx2.^2.*cos(x1).*cos(x2)) - GHhy.*(ddx1.*sin(x1).*sin(x2) - ddx1.*cos(x1).*cos(x2) + ddx2.*sin(x1).*sin(x2) - ddx2.*cos(x1).*cos(x2) + dx1.^2.*sin(x1).*cos(x2) + dx1.^2.*sin(x2).*cos(x1) + 2*dx1.*dx2.*sin(x1).*cos(x2) + 2*dx1.*dx2.*sin(x2).*cos(x1) + dx2.^2.*sin(x1).*cos(x2) + dx2.^2.*sin(x2).*cos(x1)) - GHsx.*ddx1.*sin(x1) - GHsx.*dx1.^2.*cos(x1) - GHsy.*ddx1.*cos(x1) + GHsy.*dx1.^2.*sin(x1)).*cos(x1);
Ry = g.*mh.*cos(x1) + mh.*(-GHhx.*(-ddx1.*sin(x1).*sin(x2) + ddx1.*cos(x1).*cos(x2) - ddx2.*sin(x1).*sin(x2) + ddx2.*cos(x1).*cos(x2) - dx1.^2.*sin(x1).*cos(x2) - dx1.^2.*sin(x2).*cos(x1) - 2*dx1.*dx2.*sin(x1).*cos(x2) - 2*dx1.*dx2.*sin(x2).*cos(x1) - dx2.^2.*sin(x1).*cos(x2) - dx2.^2.*sin(x2).*cos(x1)) - GHhy.*(-ddx1.*sin(x1).*cos(x2) - ddx1.*sin(x2).*cos(x1) - ddx2.*sin(x1).*cos(x2) - ddx2.*sin(x2).*cos(x1) + dx1.^2.*sin(x1).*sin(x2) - dx1.^2.*cos(x1).*cos(x2) + 2*dx1.*dx2.*sin(x1).*sin(x2) - 2*dx1.*dx2.*cos(x1).*cos(x2) + dx2.^2.*sin(x1).*sin(x2) - dx2.^2.*cos(x1).*cos(x2)) + GHsx.*ddx1.*cos(x1) - GHsx.*dx1.^2.*sin(x1) - GHsy.*ddx1.*sin(x1) - GHsy.*dx1.^2.*cos(x1)).*cos(x1) - mh.*(-GHhx.*(-ddx1.*sin(x1).*cos(x2) - ddx1.*sin(x2).*cos(x1) - ddx2.*sin(x1).*cos(x2) - ddx2.*sin(x2).*cos(x1) + dx1.^2.*sin(x1).*sin(x2) - dx1.^2.*cos(x1).*cos(x2) + 2*dx1.*dx2.*sin(x1).*sin(x2) - 2*dx1.*dx2.*cos(x1).*cos(x2) + dx2.^2.*sin(x1).*sin(x2) - dx2.^2.*cos(x1).*cos(x2)) - GHhy.*(ddx1.*sin(x1).*sin(x2) - ddx1.*cos(x1).*cos(x2) + ddx2.*sin(x1).*sin(x2) - ddx2.*cos(x1).*cos(x2) + dx1.^2.*sin(x1).*cos(x2) + dx1.^2.*sin(x2).*cos(x1) + 2*dx1.*dx2.*sin(x1).*cos(x2) + 2*dx1.*dx2.*sin(x2).*cos(x1) + dx2.^2.*sin(x1).*cos(x2) + dx2.^2.*sin(x2).*cos(x1)) - GHsx.*ddx1.*sin(x1) - GHsx.*dx1.^2.*cos(x1) - GHsy.*ddx1.*cos(x1) + GHsy.*dx1.^2.*sin(x1)).*sin(x1);

R = [Rx;Ry;0];
for i=1:1
dir = muscle_force_direction(akt(i),origin(i),insertion(i),O_pos(i,:),I_pos(i,:),l0m(i),F0m(i),x1,x2,GHsx,GHsy,GHhx,GHhy);
R(1) = R(1)-dir(1);
R(2) = R(2)-dir(2);
end
% R = R*(1);


