clear all
centre = [0,0,0];
side = [0,0,1];
attach = [-10,1,0];
radius = 1;
x_cyl = [1,0,0];

pos1 = wrap_point_thesis(attach, centre, side, radius)
pos2 = wrap_point_moje(attach, centre, side, radius)
x_ax = att_frame(attach, centre, side);
arccos = acos(dot(x_cyl,x_ax));
artan2 = atan2(x_ax(2),x_ax(1));
vectoangle = vecangle360(x_cyl,x_ax,side);



% function [x,y] = point_in_cylinder(attach, centre, side,radius)
% 
% end
function pos = wrap_point_thesis(attach, centre, side,radius)
    % vychazi stejne, ale asi lepsi
    x_cyl = [1,0,0];
    attach_f = att_frame(attach, centre, side);
    base = norm(attach-centre);
    x = radius^2/base;
    y = -sqrt(radius^2-x^2);
    % angle = vecangle360(x_cyl,attach_f,side);
    angle = atan2(attach_f(2),attach_f(1));
    pos = R_z(angle)*[x;y;1];
end

function pos = wrap_point_moje(attach, centre, side,radius)
    x_cyl = [1,0,0];
    attach_f = att_frame(attach, centre, side);
    base = norm(attach-centre);
    angle = vecangle360(x_cyl,attach_f,side);
    alfa = acos(radius/base);
    y = -sin(alfa)*radius;
    x = sqrt(radius^2-y^2);
    pos = R_z(angle)*[x;y;1];
    % pos = [x,y,1];

end

function a = vecangle360(v1,v2,n)
    x = cross(v1,v2);
    c = sign(dot(x,n)) * norm(x);
    a = atan2(c,dot(v1,v2));
end

function x_ax = att_frame(attach, centre, side)
    z_ax = (side-centre)/norm(side-centre);
    y_ax = cross(z_ax,attach-centre)/norm(cross(z_ax,attach-centre));
    x_ax = cross(y_ax,z_ax);
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