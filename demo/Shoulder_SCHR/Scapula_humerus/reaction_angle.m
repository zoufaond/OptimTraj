function phi = reaction_angle(x,u,params,muscles)
akt = u;

R = reactions(x(1),x(3),0,x(2),x(4),0,params,muscles,akt);
phi = atan(R(2)/R(1))*180/pi;
end