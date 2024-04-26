function dx = optim_control_nlmpc(x,u)

akt = u';
SC_AC = [-0.0143,0.02,0.1355];
c_COM = [-0.0110972, 0.00637508, 0.0541825];
AC_GH = [-0.009,-0.034,0.009];
s_COM = [-0.0512948, -0.0367122, -0.0430756];
h_COM = [0.000389382, -0.116338, -0.00231072];
c = 1;
mc = 1;
ms = 2;
mh = 3;
Ic = 0.1;
Is = 0.2;
Ih = 0.3;
g = 9.80665;
koef = [mc ms mh Ic Is Ih g c];
F0M = [500.0,900.0,400.0,800.0,700.0,600.0,800.0,300.0,600.0]*(-1);
L0M = [0.3,0.11,0.07,0.135,0.12,0.11,0.13,0.1,0.06];
t = 0;

dx = zeros(6,1);
mm = MM(t,x,koef,SC_AC,c_COM,AC_GH,s_COM,h_COM);
fo = FO(t,x,koef,SC_AC,c_COM,AC_GH,s_COM,h_COM);
fe = FE(t,x,F0M,L0M,akt);
dx = mm\(fo+fe);