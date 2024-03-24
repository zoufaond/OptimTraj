% clear all;clc
q = sym('q',[1 2]);
dq = sym('dq', [1 2]);
F_iso = sym('F_iso',[1 2]);
l0m = sym('l0m', [1 2]);
akt = sym('akt',[1 2]);
t = sym('t');
mus1_origin = [-0.01,0.01];
mus1_insertion = [0,0.01];
mus2_origin = [0,-0.02];
mus2_insertion = [0,-0.01];

muscle1_len = muscle_length('Thorax','Humerus',mus1_origin,mus1_insertion,q);
muscle2_len = muscle_length('Scapula','Humerus',mus2_origin,mus2_insertion,q);
muscle1_force = muscle_force(muscle1_len,F_iso(1), akt(1), l0m(1));
muscle2_force = muscle_force(muscle2_len,F_iso(2), akt(2), l0m(2));

lengths = [muscle1_len,muscle2_len];
forces = [muscle1_force,muscle2_force]';
fe = [zeros(2,1);jacobian(lengths,q)'*forces];

% matlabFunction(fe,'file','f_muscles','vars',{t,[q,dq],F_iso,l0m,akt});

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

