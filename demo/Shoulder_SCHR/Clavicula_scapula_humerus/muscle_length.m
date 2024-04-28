function [length,dir] = muscle_length(origin, insertion, O_pos, I_pos, q, obtaceni,data)
    SC_AC = data.SC_AC;
    c_COM = data.c_COM;
    AC_GH = data.AC_GH;
    s_COM = data.s_COM;
    h_COM = data.h_COM;
    TH_SCJ = [0.006325 0.00693 0.025465];
    if strcmp(origin, 'Thorax') & strcmp(insertion, 'Scapula') & obtaceni==0 | origin==1 & insertion==3 & obtaceni==0
        % jeste treba doplnit o offset SC vuci thoraxu
        O = R_x(-q(2))*T_x(-SC_AC(1))*T_y(-SC_AC(2))*T_z(-SC_AC(3))*R_x(-q(1))*T_x(-TH_SCJ(1))*T_y(-TH_SCJ(2))*T_z(-TH_SCJ(3))*position(O_pos(1),O_pos(2),O_pos(3));
        I = position(I_pos(1),I_pos(2),I_pos(3));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2 + (O(3) - I(3))^2);
        O_dir = O;
        I_dir = I;
        length_dir = length;
    elseif strcmp(origin, 'Thorax') & strcmp(insertion, 'Humerus') & obtaceni==0 | origin==1 & insertion==4 & obtaceni==0
        O = R_x(-q(2))*T_x(-SC_AC(1))*T_y(-SC_AC(2))*T_z(-SC_AC(3))*R_x(-q(1))*T_x(-TH_SCJ(1))*T_y(-TH_SCJ(2))*T_z(-TH_SCJ(3))*position(O_pos(1),O_pos(2),O_pos(3));
        I = T_x(AC_GH(1))*T_y(AC_GH(2))*T_z(AC_GH(3))*R_x(q(3))*position(I_pos(1),I_pos(2),I_pos(3));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2 + (O(3) - I(3))^2);
        O_dir = O;
        I_dir = I;
        length_dir = length;
    elseif strcmp(origin, 'Scapula') & strcmp(insertion, 'Humerus') & obtaceni==0 | origin==3 & insertion==4 & obtaceni==0
        O = position(O_pos(1),O_pos(2),O_pos(3));
        I = T_x(AC_GH(1))*T_y(AC_GH(2))*T_z(AC_GH(3))*R_x(q(3))*position(I_pos(1),I_pos(2),I_pos(3));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2 + (O(3) - I(3))^2);
        O_dir = O;
        I_dir = I;
        length_dir = length;
    elseif strcmp(origin, 'Thorax') & strcmp(insertion, 'Clavicula') & obtaceni==0 | origin==1 & insertion==2 & obtaceni==0
        O = R_x(-q(2))*T_x(-SC_AC(1))*T_y(-SC_AC(2))*T_z(-SC_AC(3))*R_x(-q(1))*T_x(-TH_SCJ(1))*T_y(-TH_SCJ(2))*T_z(-TH_SCJ(3))*position(O_pos(1),O_pos(2),O_pos(3));
        I = R_x(-q(2))*T_x(-SC_AC(1))*T_y(-SC_AC(2))*T_z(-SC_AC(3))*position(I_pos(1),I_pos(2),I_pos(3));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2 + (O(3) - I(3))^2);
        O_dir = O;
        I_dir = I;
        length_dir = length;
    elseif strcmp(origin, 'Clavicula') & strcmp(insertion, 'Humerus') & obtaceni==0 | origin==2 & insertion==4 & obtaceni==0
        O = R_x(-q(2))*T_x(-SC_AC(1))*T_y(-SC_AC(2))*T_z(-SC_AC(3))*position(O_pos(1),O_pos(2),O_pos(3));
        I = T_x(AC_GH(1))*T_y(AC_GH(2))*T_z(AC_GH(3))*R_x(q(3))*position(I_pos(1),I_pos(2),I_pos(3));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2 + (O(3) - I(3))^2);
        O_dir = O;
        I_dir = I;
        length_dir = length;
    elseif strcmp(origin, 'Scapula') & strcmp(insertion, 'Humerus') & obtaceni==1 | origin==3 & insertion==4 & obtaceni==1
        O = position(O_pos(1),O_pos(2),O_pos(3));
        I = T_x(AC_GH(1))*T_y(AC_GH(2))*T_z(AC_GH(3))*R_x(q(3))*position(I_pos(1),I_pos(2),I_pos(3));
        O_wrap = [O(3);O(2);1];
        I_wrap = [I(3);I(2);1];
        centre = [AC_GH(3),AC_GH(2),0];
        radius = 0.0275;
        length = muscle_length_wrap(O_wrap',I_wrap',centre,radius);
        % O_dir = O_wrap;
        % I_dir = wrap_point(O_wrap',centre,radius,-1);
        % length_dir = sqrt((O_dir(1) - I_dir(1))^2 + (O_dir(2) - I_dir(2))^2);
    end
    % dir = (I_dir-O_dir)/length_dir;
    dir = [0;0;0];
    

end

function trans_x = T_x(x)
    trans_x = [1,0,0,x;
               0,1,0,0;
               0,0,1,0;
               0,0,0,1];
end

function trans_y = T_y(y)
    trans_y = [1,0,0,0;
               0,1,0,y;
               0,0,1,0;
               0,0,0,1];
end

function trans_z = T_z(z)
    trans_z = [1,0,0,0;
               0,1,0,0;
               0,0,1,z;
               0,0,0,1];
end

function rot_phix = R_x(phix)
    rot_phix = [1,0        , 0        ,0;
                0,cos(phix),-sin(phix),0;
                0,sin(phix), cos(phix),0;
                0,0        , 0        ,1];
end

function rot_phiz = R_z(phiz)
    rot_phiz = [cos(phiz),-sin(phiz),0;
                sin(phiz), cos(phiz),0;
                0           ,0      ,1];
end

function r = position(x,y,z)
    r = [x;y;z;1];
end

function len = muscle_length_wrap(origin,insertion,centre,radius)
    wrap_len = wrap_angle(origin,insertion,centre,radius)*radius;
    I_pos = wrap_point(insertion,centre,radius,1);
    O_pos = wrap_point(origin,centre,radius,-1);
    O_len = vec_dist(O_pos,origin);
    I_len = vec_dist(I_pos,insertion);
    len = wrap_len+O_len+I_len;
end

function len = vec_dist(O,I)
    len = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2);
end

function angle = wrap_angle(origin,insertion,centre,radius)
    O_pos = wrap_point(origin,centre,radius,-1);
    I_pos = wrap_point(insertion,centre,radius,1);
    angle =  atan2(O_pos(2)-centre(2),O_pos(1)-centre(1))-atan2(I_pos(2)-centre(2),I_pos(1)-centre(1));
end

function pos = wrap_point(attach,centre,radius,direction)
    side = [0,0,1]+centre;
    attach_f = att_frame(attach, centre, side);
    base = norm(attach-centre);
    x = radius^2/base;
    y = direction*sqrt(radius^2-x^2);
    % angle = vecangle360(x_cyl,attach_f,side);
    angle = atan2(attach_f(2),attach_f(1));
    pos = T_x2D(centre(1))*T_y2D(centre(2))*R_z2D(angle)*[x;y;1];
end

function x_ax = att_frame(attach, centre, side)
    z_ax = (side-centre)/norm(side-centre);
    y_ax = cross(z_ax,attach-centre)/norm(cross(z_ax,attach-centre));
    x_ax = cross(y_ax,z_ax);
end

function trans_x = T_x2D(x)
    trans_x = [1,0,x;
               0,1,0;
               0,0,1];
end

function trans_y = T_y2D(y)
    trans_y = [1,0,0;
               0,1,y;
               0,0,1];
end


function rot_phiz = R_z2D(phiz)
    rot_phiz = [cos(phiz),-sin(phiz),0;
                sin(phiz), cos(phiz),0;
                0           ,0      ,1];
end