syms l m g c1 c2 k1 k2 F1 F2 qq1 qq2 uu1 uu2 ddq1 ddq2 t real

q = [qq1 qq2 uu1 uu2];
q_ID = [qq1 qq2 uu1 uu2 ddq1 ddq2];
koef = [l m g c1 c2 k1 k2];
forces = [F1 F2];

mm = [1 0 0 0; 0 1 0 0; 0 0 l.^2.*m/4 + m.*(l.^2.*cos(qq2) + 5*l.^2/4) m.*(l.^2.*cos(qq2)/2 + l.^2/4); 0 0 m.*(l.^2.*cos(qq2)/2 + l.^2/4) l.^2.*m/4];
fo = [uu1; uu2; F1 - c1.*uu1 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - 3*g.*l.*m.*cos(qq1)/2 - k1.*qq1 - l.^2.*m.*uu1.^2.*sin(qq2)/2 + l.^2.*m.*(uu1 + uu2).^2.*sin(qq2)/2; F2 - c2.*uu2 - g.*l.*m.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2))/2 - k2.*qq2 - l.^2.*m.*uu1.^2.*sin(qq2)/2];

dq = mm\fo;
torque = mm(3:end,3:end)*[ddq1;ddq2]-fo(3:end);

matlabFunction(dq,'file','ODE_sim','vars',{t,q',forces',koef})
matlabFunction(torque,'file','Inverse_dyn','vars',{t,q_ID',forces,koef})