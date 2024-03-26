function dx = optim_control_nlmpc(x,u)

akt = u';
c = 1;
ms = 0.5;
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
l0m = [0.105,0.9,0.115,0.1];
force = [700,100,400,200]*(-1);
t = 0;

dx = zeros(4,1);
% dy = ODE_sim(t,y,koef,coords,force,l0m,akt);
mm = MM(t,x,koef,coords,force,l0m,akt);
fo = FO(t,x,koef,coords,force,l0m,akt);
fe = FE(t,x,koef,coords,force,l0m,akt);
dx = mm\(fo+fe);