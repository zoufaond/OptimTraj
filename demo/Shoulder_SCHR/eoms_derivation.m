clear all;clc
syms ms mh g c Is Ih GHsx GHsy GHhx GHhy qq1 qq2 uu1 uu2 ddq1 ddq2 t real
F_iso = sym('F_iso',[1 4]);
l0m = sym('l0m', [1 4]);
akt = sym('akt',[1 4]);
q = [qq1 qq2 uu1 uu2];
q_ID = [qq1 qq2 uu1 uu2 ddq1 ddq2];
koef = [ms mh Is Ih g c];
coords = [GHsx GHsy GHhx GHhy];
mus1_origin = [-0.01,0.05];
mus1_insertion = [0.02,0.1];
mus2_origin = [0,-0.03];
mus2_insertion = [0,0.08];
mus3_origin = [-0.08,0.08];
mus3_insertion = [0.05,0.02];
mus4_origin = [-0.12,-0.02];
mus4_insertion = [-0.08,-0.15];

muscle1_len = muscle_length('Thorax','Humerus',mus1_origin,mus1_insertion,[qq1,qq2]);
muscle2_len = muscle_length('Scapula','Humerus',mus2_origin,mus2_insertion,[qq1,qq2]);
muscle3_len = muscle_length('Thorax','Scapula',mus3_origin,mus3_insertion,[qq1,qq2]);
muscle4_len = muscle_length('Thorax','Scapula',mus4_origin,mus4_insertion,[qq1,qq2]);
muscle1_force = muscle_force(muscle1_len,F_iso(1), akt(1), l0m(1));
muscle2_force = muscle_force(muscle2_len,F_iso(2), akt(2), l0m(2));
muscle3_force = muscle_force(muscle3_len,F_iso(3), akt(3), l0m(3));
muscle4_force = muscle_force(muscle4_len,F_iso(4), akt(4), l0m(4));
% 
lengths = [muscle1_len,muscle2_len,muscle3_len,muscle4_len];
forces = [muscle1_force,muscle2_force,muscle3_force,muscle4_force]';
fe = [zeros(2,1);jacobian(lengths,[qq1,qq2])'*forces];
mm = [1 0 0 0; 0 1 0 0; 0 0 Ih + Is + mh.*(GHhx.^2 - GHhx.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) + GHhy.^2 + GHhy.*(GHsx.*sin(qq2) - GHsy.*cos(qq2)) + GHsx.^2 + GHsx.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) + GHsy.^2 - GHsy.*(GHhx.*sin(qq2) + GHhy.*cos(qq2))) Ih + mh.*(GHhx.^2 + GHhy.^2 + GHsx.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - GHsy.*(GHhx.*sin(qq2) + GHhy.*cos(qq2))); 0 0 Ih + mh.*(GHhx.^2 - GHhx.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) + GHhy.^2 + GHhy.*(GHsx.*sin(qq2) - GHsy.*cos(qq2))) Ih + mh.*(GHhx.^2 + GHhy.^2)];
fo = [uu1; uu2; GHhx.*g.*mh.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2)) - GHhx.*mh.*(uu1 + uu2).^2.*(GHsx.*sin(qq2) - GHsy.*cos(qq2)) - GHhy.*g.*mh.*(sin(qq1).*cos(qq2) + sin(qq2).*cos(qq1)) - GHhy.*mh.*(uu1 + uu2).^2.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) - GHsx.*g.*mh.*cos(qq1) + GHsx.*mh.*uu1.^2.*(GHhx.*sin(qq2) + GHhy.*cos(qq2)) + GHsy.*g.*mh.*sin(qq1) + GHsy.*mh.*uu1.^2.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - c.*uu1; GHhx.*g.*mh.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2)) - GHhy.*g.*mh.*(sin(qq1).*cos(qq2) + sin(qq2).*cos(qq1)) + GHsx.*mh.*uu1.^2.*(GHhx.*sin(qq2) + GHhy.*cos(qq2)) + GHsy.*mh.*uu1.^2.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - c.*uu2];
dq = mm\(fo+fe);
torque = mm(3:end,3:end)*[ddq1;ddq2]-fo(3:end)-fe(3:end);


matlabFunction(mm,'file','MM','vars',{t,q',koef,coords,F_iso,l0m,akt})
matlabFunction(fo,'file','FO','vars',{t,q',koef,coords,F_iso,l0m,akt})
matlabFunction(fe,'file','FE','vars',{t,q',koef,coords,F_iso,l0m,akt})
% matlabFunction(dq,'file','ODE_sim','vars',{t,q',koef,coords,F_iso,l0m,akt})
% matlabFunction(torque,'file','Inverse_dyn','vars',{t,q_ID',koef,coords,F_iso,l0m,akt})

function force = muscle_force(length, F_iso, akt, l0m)
    f_gauss = 0.25;
    force = (((length / l0m)^3) * exp(8 * length / l0m - 12.9) + (exp(-(length / l0m - 1)^2 / f_gauss)) * akt) * F_iso;
end

function length = muscle_length(origin, insertion, O_pos, I_pos, q)
    GHsx = 0.075;
    GHsy = 0.0028;
    GHhx = 0;
    GHhy = 0.1;
    if strcmp(origin, 'Thorax') && strcmp(insertion, 'Scapula')
        O = R_z(-q(1))*position(O_pos(1),O_pos(2));
        I = position(I_pos(1),I_pos(2));
    elseif strcmp(origin, 'Thorax') && strcmp(insertion, 'Humerus')
        O = R_z(-q(1))*position(O_pos(1),O_pos(2));
        I = T_x(GHsx)*T_y(GHsy)*R_z(q(2))*T_x(-GHhx)*T_y(-GHhy)*position(I_pos(1),I_pos(2));
    elseif strcmp(origin, 'Scapula') && strcmp(insertion, 'Humerus')
        O = position(O_pos(1),O_pos(2));
        I = T_x(GHsx)*T_y(GHsy)*R_z(q(2))*T_x(-GHhx)*T_y(-GHhy)*position(I_pos(1),I_pos(2));
    end
    length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2);

end

function trans_x = T_x(x)
    trans_x = [1,0,x;
               0,1,0;
               0,0,1];
end

function trans_y = T_y(y)
    trans_y = [1,0,0;
               0,1,y;
               0,0,1];
end


function rot_phiz = R_z(phiz)
    rot_phiz = [cos(phiz),-sin(phiz),0;
                sin(phiz), cos(phiz),0;
                0           ,0      ,1];
end

function r = position(x,y)
    r = [x;y;1];
end