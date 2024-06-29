function ref = reference_trajectory(t,t_final,x0)
    zero_to_pi = pi*t/t_final;
    ref = (sin(zero_to_pi-pi/2)+1)+x0(2);
end