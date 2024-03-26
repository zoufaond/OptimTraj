Ts = 0.02;
p_hor = 100;
c_hor = 100;
nlobj.Ts = Ts;
for i=1:4
nlobj.MV(i).Min = 0;
nlobj.MV(i).Max = 1;
end
t = linspace(0,pi,p_hor);
sin_q1 = [(sin(linspace(0,pi,p_hor)-pi/2)'+1)/4-0.1702428+0.21405146];
plot(t,sin_q1)
-0.1702428+0.21405146