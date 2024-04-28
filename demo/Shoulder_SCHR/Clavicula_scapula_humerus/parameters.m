% clear all
x0 = [0.057625;-0.030753;-0.100369;0;0;0]*0;
data.SC_AC = [-0.0143,0.02,0.1355];
data.c_COM = [-0.0110972, 0.00637508, 0.0541825];
data.AC_GH = [-0.009,-0.034,0.009];
data.s_COM = [-0.0512948, -0.0367122, -0.0430756];
data.h_COM = [0.000389382, -0.116338, -0.00231072];
c = 1;
mc = 0.0370005*2;
ms = 0.12759*2;
mh = 2;
Ic = 0.01;
Is = 0.02;
Ih = 0.03;
g = 9.80665;
data.koef = [mc ms mh Ic Is Ih g c];
akt = zeros(1,13);
akt(2) = 0.2;
akt(4) = 0.15;
% akt(7) = 0.05;

muscles_tab = readtable('Muscles_tab.xlsx');
% muscles.names = table2array(muscles_tab(:,1));
muscles.F0M = str2double(table2array(muscles_tab(:,2)))*(-1);
muscles.L0M = str2double(table2array(muscles_tab(:,3)));
p.F0M = str2double(table2array(muscles_tab(:,2)))*(-1);
p.L0M = str2double(table2array(muscles_tab(:,3)));
muscles.origin_body = table2array(muscles_tab(:,4));
muscles.origin = coords2arr(table2array(muscles_tab(:,5)));
muscles.insertion_body = table2array(muscles_tab(:,6));
muscles.insertion = coords2arr(table2array(muscles_tab(:,7)));
muscles.wrapping = table2array(muscles_tab(:,8));


function t = coords2arr(coords)
    t = zeros(length(coords),3);
    for i = 1:length(coords)
        t(i,:) = str2num(coords{i});
    end
end