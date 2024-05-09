% system parameters
x0 = [-0.03904,0.1411925,0,0];
params.c = 2;
params.ms = 2;
params.mh = 2;
params.Is = 0.02;
params.Ih = 0.02;
params.GHsx = 0.075;
params.GHsy = 0.0028;
params.GHhx = 0;
params.GHhy = 0.1;
params.g = 9.80665;
koef = [params.ms params.mh params.Is params.Ih params.g params.c];
coords = [params.GHsx params.GHsy params.GHhx params. GHhy];
akt = [0,1,0,0,0,0,0,0];
% akt = ones(1,8);
% % x1 = 0; dx1 = 0; ddx1 = 0; x2 = 0; dx2 = 0; ddx2 = 0; akt = [1,1]*0;
% % muscle_force_direction(1,origin(1),insertion(1),O_pos(1,:),I_pos(1,:),1,1,x1,x2,GHsx,GHsy,GHhx,GHhy)
% % reactions(x1,dx1,ddx1,x2,dx2,ddx2,GHsx,GHsy,GHhx,GHhy,g,mh,origin,insertion,O_pos,I_pos,l0m,force,akt)
% % ODE_sim(0,[0,0,0,0]',koef,coords,force,l0m,[1,1])

muscles_tab = readtable('Muscles_tab.xlsx');
muscles.names = table2array(muscles_tab(:,1));
muscles.F0M = str2double(table2array(muscles_tab(:,2)))*(-1);
muscles.L0M = str2double(table2array(muscles_tab(:,3)));
muscles.origin_body = table2array(muscles_tab(:,4));
muscles.origin = coords2arr(table2array(muscles_tab(:,5)));
muscles.insertion_body = table2array(muscles_tab(:,6));
muscles.insertion = coords2arr(table2array(muscles_tab(:,7)));
muscles.wrapping = table2array(muscles_tab(:,8));
function t = coords2arr(coords)
    t = zeros(length(coords),2);
    for i = 1:length(coords)
        t(i,:) = str2num(coords{i});
    end
end