function xd = optim_control_nlmpc(x, u)

% F1 = u(1);
% F2 = u(2);

c1 = 1;
c2 = 1;
k1 = 0;
k2 = 0;
m = 1.0;
l = 10.0;
g = 9.80665;
koef = [l m g c1 c2 k1 k2];

xd = zeros(4, 1);

xd = ODE_sim(0,x,u,koef);