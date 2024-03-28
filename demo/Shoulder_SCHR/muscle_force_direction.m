function [forcedir] = muscle_force_direction(akt,origin,insertion, O_pos, I_pos,l0m,F0m,x1,x2,GHsx,GHsy,GHhx,GHhy)
[len,dir] = muscle_length(origin,insertion, O_pos, I_pos,x1,x2);
forcedir = dir*muscle_force(len,F0m,akt,l0m);
end

function [length,dir] = muscle_length(origin, insertion, O_pos, I_pos, x1,x2)
    GHsx = 0.075;
    GHsy = 0.0028;
    GHhx = 0;
    GHhy = 0.1;
    O = zeros(3,1);
    I = zeros(3,1);
    if origin==1 && insertion==2
        O = R_z(-x1)*position(O_pos(1),O_pos(2));
        I = position(I_pos(1),I_pos(2));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2);
    elseif origin==1 && insertion==3
        O = R_z(-x1)*position(O_pos(1),O_pos(2));
        I = T_x(GHsx)*T_y(GHsy)*R_z(x2)*T_x(-GHhx)*T_y(-GHhy)*position(I_pos(1),I_pos(2));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2);
    elseif origin==2 && insertion==3
        O = position(O_pos(1),O_pos(2));
        I = T_x(GHsx)*T_y(GHsy)*R_z(x2)*T_x(-GHhx)*T_y(-GHhy)*position(I_pos(1),I_pos(2));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2);
     elseif origin==2 && insertion==4
        O = position(O_pos(1),O_pos(2));
        I = T_x(GHsx)*T_y(GHsy)*R_z(x2)*T_x(-GHhx)*T_y(-GHhy)*position(I_pos(1),I_pos(2));
        length = sqrt((O(1) - I(1))^2 + (O(2) - I(2))^2);
    end
    
    % O = R_z(-x1)*position(O_pos(1),O_pos(2));
    % I = T_x(GHsx)*T_y(GHsy)*R_z(x2)*T_x(-GHhx)*T_y(-GHhy)*position(I_pos(1),I_pos(2));
    
    dir = (I-O)/length;

end

function force = muscle_force(length, F_iso, akt, l0m)
    f_gauss = 0.25;
    force = (((length / l0m)^3) * exp(8 * length / l0m - 12.9) + (exp(-(length / l0m - 1)^2 / f_gauss)) * akt) * F_iso;
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
    pos = T_x(centre(1))*T_y(centre(2))*R_z(angle)*[x;y;1];
end

function x_ax = att_frame(attach, centre, side)
    z_ax = (side-centre)/norm(side-centre);
    y_ax = cross(z_ax,attach-centre)/norm(cross(z_ax,attach-centre));
    x_ax = cross(y_ax,z_ax);
end