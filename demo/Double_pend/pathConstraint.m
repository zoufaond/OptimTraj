function [c, ceq] = pathConstraint(x)

ceq = [x(2,ceil(end/2)-1)];
c = [];

end