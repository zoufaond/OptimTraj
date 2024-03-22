


function trans_x = T_x(x)
    trans_x = [1,0,x;
               0,1,0;
               0,0,1;

end

function trans_y = T_y(y)
    trans_y = [1,0,0;
               0,1,y;
               0,0,1];
end

function rot_phiz = R_z(phiz)
    rot_phiz = [cos(phiz),-sin(phiz),0;
                sin(phiz), cos(phiz),0;
                0           ,0      ,1]'
end

function r = position(x,y,z)
    r = [x;y;1];
end