function xd = optim_control_optimtraj(x,u,params) %[ddq1,ddq2]

xd = zeros(4,1);
koef = [params.ms params.mh params.Is params.Ih params.g params.c];
coords = [params.GHsx params.GHsy params.GHhx params. GHhy];
force = [450.0;700.0;400.0;700.0;600.0;800.0;300.0;600.1]'*(-1);
l0m = [0.11;0.11;0.08;0.165;0.14;0.14;0.13;0.12]';
t = 0;


nTime = length(x(1,:));
for i=1:nTime
    mm = MM(t,x(:,i),koef,coords,force,l0m,u(:,i));
    fo = FO(t,x(:,i),koef,coords,force,l0m,u(:,i));
    fe = FE(t,x(:,i),koef,coords,force,l0m,u(:,i));
    xd(:,i) = mm\(fo+fe);
end


% xd = ODE_sim(t,x,koef,coords,force,l0m,u);

end