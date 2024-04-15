clear all; clc;
% delt2 400->0
muscles_tab = readtable('Muscles_tab.xlsx');
muscles.names = table2array(muscles_tab(:,1));
muscles.F0M = str2double(table2array(muscles_tab(:,2)))*(-1);
muscles.L0M = str2double(table2array(muscles_tab(:,3)));
muscles.origin_body = table2array(muscles_tab(:,4));
muscles.origin = coords2arr(table2array(muscles_tab(:,5)));
muscles.insertion_body = table2array(muscles_tab(:,6));
muscles.insertion = coords2arr(table2array(muscles_tab(:,7)));
muscles.wrapping = table2array(muscles_tab(:,8));
syms  ms mh g c Is Ih GHsx GHsy GHhx GHhy qq1 qq2 uu1 uu2 ddq1 ddq2 t real
F_iso = sym('F_iso',[1 5]);
l0m = sym('l0m', [1 5]);
akt_sym = sym('akt_sym',[1 5]);
data_sym = sym('data_sym');
q = [qq1 qq2 uu1 uu2];
q_ID = [qq1 qq2 uu1 uu2 ddq1 ddq2];
koef_sym = [ms mh Is Ih g c];
coords_sym = [GHsx GHsy GHhx GHhy];
% [muscle_len_vec,dir_vec] = muscle_length(1,3,muscles.origin(2,:),muscles.insertion(2,:),[qq1,qq2],0);
for i=1:5
    [muscle_len_vec(i),dir_vec(i,:)] = muscle_length(muscles.origin_body{i},muscles.insertion_body{i},muscles.origin(i,:),muscles.insertion(i,:),[qq1,qq2],muscles.wrapping(i));
    muscle_force_vec(i) = muscle_force(muscle_len_vec(i),F_iso(i), akt_sym(i), l0m(i));
end
data;
jacob = simplify(jacobian(muscle_len_vec,[qq1,qq2])');
fe = [zeros(2,1);jacob*muscle_force_vec'];
mm = [1 0 0 0; 0 1 0 0; 0 0 Ih + Is + mh.*(GHhx.^2 - GHhx.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) + GHhy.^2 + GHhy.*(GHsx.*sin(qq2) - GHsy.*cos(qq2)) + GHsx.^2 + GHsx.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) + GHsy.^2 - GHsy.*(GHhx.*sin(qq2) + GHhy.*cos(qq2))) Ih + mh.*(GHhx.^2 + GHhy.^2 + GHsx.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - GHsy.*(GHhx.*sin(qq2) + GHhy.*cos(qq2))); 0 0 Ih + mh.*(GHhx.^2 - GHhx.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) + GHhy.^2 + GHhy.*(GHsx.*sin(qq2) - GHsy.*cos(qq2))) Ih + mh.*(GHhx.^2 + GHhy.^2)];
fo = [uu1; uu2; GHhx.*g.*mh.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2)) - GHhx.*mh.*(uu1 + uu2).^2.*(GHsx.*sin(qq2) - GHsy.*cos(qq2)) - GHhy.*g.*mh.*(sin(qq1).*cos(qq2) + sin(qq2).*cos(qq1)) - GHhy.*mh.*(uu1 + uu2).^2.*(GHsx.*cos(qq2) + GHsy.*sin(qq2)) - GHsx.*g.*mh.*cos(qq1) + GHsx.*mh.*uu1.^2.*(GHhx.*sin(qq2) + GHhy.*cos(qq2)) + GHsy.*g.*mh.*sin(qq1) + GHsy.*mh.*uu1.^2.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - c.*uu1; GHhx.*g.*mh.*(-sin(qq1).*sin(qq2) + cos(qq1).*cos(qq2)) - GHhy.*g.*mh.*(sin(qq1).*cos(qq2) + sin(qq2).*cos(qq1)) + GHsx.*mh.*uu1.^2.*(GHhx.*sin(qq2) + GHhy.*cos(qq2)) + GHsy.*mh.*uu1.^2.*(-GHhx.*cos(qq2) + GHhy.*sin(qq2)) - c.*uu2];
% % % dq = mm\(fo+fe);
% % % torque = mm(3:end,3:end)*[ddq1;ddq2]-fo(3:end)-fe(3:end);
react_angle = reaction_angle(q,akt_sym,params,muscles);

% 
matlabFunction(mm,'file','MM','vars',{t,q',koef_sym,coords_sym,F_iso,l0m,akt_sym})
matlabFunction(fo,'file','FO','vars',{t,q',koef_sym,coords_sym,F_iso,l0m,akt_sym})
matlabFunction(fe,'file','FE','vars',{t,q',koef_sym,coords_sym,F_iso,l0m,akt_sym})
matlabFunction(react_angle,'file','phi_react','vars',{q,akt_sym,data_sym})
% matlabFunction(dq,'file','ODE_sim','vars',{t,q',koef,coords,F_iso,l0m,akt})
% matlabFunction(torque,'file','Inverse_dyn','vars',{t,q_ID',koef,coords,F_iso,l0m,akt})

function t = coords2arr(coords)
    t = zeros(length(coords),2);
    for i = 1:length(coords)
        t(i,:) = str2num(coords{i});
    end
end