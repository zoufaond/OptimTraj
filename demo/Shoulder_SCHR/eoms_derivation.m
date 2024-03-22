syms ms mh g c Is Ih GHsx GHsy GHhx GHhy qq1 qq2 uu1 uu2 ddq1 ddq2 t real

q = [qq1 qq2 uu1 uu2];
q_ID = [qq1 qq2 uu1 uu2 ddq1 ddq2];
koef = [ms mh Is Ih g c];
coords = [GHsx GHsy GHhx GHhy];

mm = [1 0 0 0; 0 1 0 0; 0 0 Ih + Is + mh.*(GHhx.^2 - GHhx.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) + GHhy.^2 + GHhy.*(GHsx.*sin(qq2) - GHsy.*cos(qq2)) + GHsx.^2 + GHsx.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) + GHsy.^2 - GHsy.*(GHhx.*sin(qq2) + GHhy.*cos(qq2))) Ih + mh.*(GHhx.^2 + GHhy.^2 + GHsx.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - GHsy.*(GHhx.*sin(qq2) + GHhy.*cos(qq2))); 0 0 Ih + mh.*(GHhx.^2 - GHhx.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) + GHhy.^2 + GHhy.*(GHsx.*sin(qq2) - GHsy.*cos(qq2))) Ih + mh.*(GHhx.^2 + GHhy.^2)];
fo = [uu1; uu2; GHhx.*g.*mh.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2)) - GHhx.*mh.*(uu1 + uu2).^2.*(GHsx.*sin(qq2) - GHsy.*cos(qq2)) - GHhy.*g.*mh.*(sin(qq1).*cos(qq2) + sin(qq2).*cos(qq1)) - GHhy.*mh.*(uu1 + uu2).^2.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) - GHsx.*g.*mh.*cos(qq1) + GHsx.*mh.*uu1.^2.*(GHhx.*sin(qq2) + GHhy.*cos(qq2)) + GHsy.*g.*mh.*sin(qq1) + GHsy.*mh.*uu1.^2.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - c.*uu1; GHhx.*g.*mh.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2)) - GHhy.*g.*mh.*(sin(qq1).*cos(qq2) + sin(qq2).*cos(qq1)) + GHsx.*mh.*uu1.^2.*(GHhx.*sin(qq2) + GHhy.*cos(qq2)) + GHsy.*mh.*uu1.^2.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - c.*uu2];

dq = mm\fo;
torque = mm(3:end,3:end)*[ddq1;ddq2]-fo(3:end);


matlabFunction(dq,'file','ODE_sim','vars',{t,q',koef,coords})
matlabFunction(torque,'file','Inverse_dyn','vars',{t,q_ID',koef,coords})