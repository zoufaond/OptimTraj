clear all
syms phi real
centre = [0,1,0];
orig = [-2,2,0];
insertion = [4,2,0];
insert = I_pos(phi,insertion,[0,0,0])';
radius = 1;

length = muscle_length_wrap(orig,insert,centre,radius);
assume(phi,'real')
length = (length);
len = (matlabFunction(length));
moment_arm = (diff(len,phi));
mom_arm = matlabFunction(moment_arm);
% phi_vec = linspace(0,0,100);
phi_vec = 0;
figure
plot(phi_vec,mom_arm(phi_vec),'o')
figure
plot(phi_vec,len(phi_vec),'o')


% % vectoangle = vecangle360(x_cyl,x_ax,side);
% figure;
% hold on
% plot (orig(1),orig(2),'x',pos1(1),pos1(2),'o');
% plot (insert(1),insert(2),'x',pos2(1),pos2(2),'o');
% circle(centre,radius);
% daspect([1,1,1])

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

function r = position(x,y)
    r = [x;y;1];
end

function pos = I_pos(phi,coords,centre)
    pos = T_x(centre(1))*T_y(centre(2))*R_z(phi)*position(coords(1),coords(2));
end

function h = circle(pos,r)
hold on
x = pos(1);
y = pos(2);
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off
end