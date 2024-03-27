function phi = reaction_angle(x,u,data)
akt = u;
c = 1;
x0 = [-0.103496,0.20666,0,0];
ms = 2;
mh = 2;
Is = 0.02;
Ih = 0.02;
GHsx = 0.075;
GHsy = 0.0028;
GHhx = 0;
GHhy = 0.1;
g = 9.80665;
koef = [ms mh Is Ih g c];
coords = [GHsx GHsy GHhx GHhy];
origin = [1,2];
insertion = [3,3];
O_pos = [-0.01,0.02;0,-0.03];
I_pos = [0.02,0.1;0,0.08];
l0m = [0.105,0.08,0.115,0.1];
force = [700,300,600,200]*(-1);

R = reactions(x(1),x(3),0,x(2),x(4),0,GHsx,GHsy,GHhx,GHhy,g,mh,origin,insertion, O_pos, I_pos,l0m,force,akt);
phi = atan(R(2)/R(1))*180/pi;
end