function dx = optim_control_nlmpc(x,u)

akt = u';
params.c = 2;
params.ms = 2;
params.mh = 2;
params.Is = 0.02;
params.Ih = 0.02;
params.GHsx = 0.075;
params.GHsy = 0.0028;
params.GHhx = 0;
params.GHhy = 0.1;
params.g = 9.80665;
koef = [params.ms params.mh params.Is params.Ih params.g params.c];
coords = [params.GHsx params.GHsy params.GHhx params. GHhy];
force = [450.0;700.0;400.0;700.0;600.0;800.0;300.0;600.1]'*(-1);
l0m = [0.11;0.11;0.08;0.165;0.14;0.14;0.13;0.12]';
t = 0;

dx = zeros(4,1);
% dy = ODE_sim(t,y,koef,coords,force,l0m,akt);
mm = MM(t,x,koef,coords,force,l0m,akt);
fo = FO(t,x,koef,coords,force,l0m,akt);
fe = FE(t,x,koef,coords,force,l0m,akt);
dx = mm\(fo+fe);