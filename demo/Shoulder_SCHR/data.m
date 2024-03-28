c = 1;
x0 = [-0.101861178,0.18177465,0,0];
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
l0m = [0.105,0.38,0.08,0.115,0.1];
force = [700,400,300,600,200]*(-1);
akt = [0,1,0,0,0]*1;
% x1 = 0; dx1 = 0; ddx1 = 0; x2 = 0; dx2 = 0; ddx2 = 0; akt = [1,1]*0;
% muscle_force_direction(1,origin(1),insertion(1),O_pos(1,:),I_pos(1,:),1,1,x1,x2,GHsx,GHsy,GHhx,GHhy)
% reactions(x1,dx1,ddx1,x2,dx2,ddx2,GHsx,GHsy,GHhx,GHhy,g,mh,origin,insertion,O_pos,I_pos,l0m,force,akt)
% ODE_sim(0,[0,0,0,0]',koef,coords,force,l0m,[1,1])