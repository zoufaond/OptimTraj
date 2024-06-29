clc
clear all
data;
nx = 4;
ny = 4;
nu = 8;
nlobj = nlmpc(nx,ny,nu);
<<<<<<< HEAD:demo/Shoulder_SCHR/Scapula_humerus/main.m
Ts = 0.02;
p_hor = 120;
c_hor = 120;
=======
Ts = 0.04;
p_hor = 50;
c_hor = 50;
>>>>>>> 5237ac965e92ce230a5b5ab7ca1bc903b39becdb:demo/Shoulder_SCHR/Scapula_humerus/main_nlmpc.m
nlobj.Ts = Ts;
for i=1:8
nlobj.MV(i).Min = 0;
nlobj.MV(i).Max = 1;
end
nlobj.States(1).Min = x0(1)-0.01;
% nlobj.MV(7).Min = 0;
% nlobj.MV(7).Max = 0.01;
% nlobj.MV(8).Min = 0;
% nlobj.MV(8).Max = 0.01;
% sin_q1 = [(sin(linspace(0,pi,p)-pi/2)'+1)/2-pi/2];
% sin_q2 = [(sin(linspace(0,2*pi,p)-pi/2)'+1)/6];
% % sin_q2 = linspace(0,1,p)'.^2;
scale = 1.4;
traj = [(sin(linspace(0,pi,p_hor)-pi/2)'+1)*scale+x0(1)+x0(2)]; %+x0(1)+x0(2)
% traj1 = zeros(p_hor/2,1);
% traj = [traj1;traj2];
% nlobj.Weights.ManipulatedVariablesRate = [0,0];

nlobj.PredictionHorizon = p_hor;
nlobj.ControlHorizon = c_hor;
nlobj.Model.StateFcn = "optim_control_nlmpc";
% +(sum((X(10:p_hor,1)-0).^2)+sum((X(10:p_hor,2)-0.3).^2))*100
phi_timespan = 1:p_hor;
phi_bound = 15;
nlobj.Optimization.CustomCostFcn = @(X,U,e,data) 1*sum(sum(U(1:p_hor,:).^2))+sum((X(1:p_hor,1)+X(1:p_hor,2)-traj).^2)*10+sum((phi_react(X(phi_timespan,:),U(phi_timespan,:),data)*pi/180).^2);
nlobj.Optimization.ReplaceStandardCost = true;
nlobj.Optimization.SolverOptions.Display = "iter-detailed";
nlobj.Optimization.SolverOptions.MaxIterations = 1000;
nlobj.Optimization.SolverOptions.StepTolerance = 1e-9;
nlobj.Optimization.SolverOptions.ConstraintTolerance = 1e-9;
nlobj.Optimization.SolverOptions.Algorithm = "sqp";
% nlobj.Optimization.SolverOptions.EnableFeasibilityMode = true;
% nlobj.Optimization.CustomIneqConFcn = @(X,U,e,data) [phi_react(X(phi_timespan,:),U(phi_timespan,:),data)-phi_bound;-phi_react(X(phi_timespan,:),U(phi_timespan,:),data)-phi_bound];

initialConditions = x0;
u0 = [0;0;0;0;0;0;0;0];
validateFcns(nlobj,x0,u0);
[~,~,info] = nlmpcmove(nlobj,x0,u0);

figure
plot(info.Topt,info.Xopt(:,1)*180/pi,'red',info.Topt,info.Xopt(:,2)*180/pi,'blue',info.Topt,(info.Xopt(:,2)+info.Xopt(:,1))*180/pi,'green',info.Topt,[traj;0]*180/pi,'o')
title('Optimal rotations of scapula and in GHJ')
xlabel('Time [s]')
ylabel('Angle [°]')
legend('Scapula rotation','GHJ rotation','Humeral elevation ()','Prescribed humeral elevation','location','northwest')

figure
plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue',info.Topt,info.MVopt(:,3),'green',info.Topt,info.MVopt(:,4),'black',info.Topt,info.MVopt(:,5),'yellow',info.Topt,info.MVopt(:,6),'cyan',info.Topt,info.MVopt(:,7),'magenta',info.Topt,info.MVopt(:,8),'-')
title('Optimal muscle activations')
xlabel('Time [s]')
ylabel('Muscle activation [-]')
legend('Supraspin','DEL','TerMin','Trap1','Trap2','Trap3','Levator','Rhomb')

figure
react_angle = phi_react(info.Xopt,info.MVopt,0);
plot(info.Topt, react_angle)
title('Reaction force direction in GHJ')
xlabel('Time [s]')
ylabel('Angle [°]')
legend('Reaction force angle')

pre_end = 1;
inputData1 = timeseries(info.MVopt(1:end-pre_end,1),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData2 = timeseries(info.MVopt(1:end-pre_end,2),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData3 = timeseries(info.MVopt(1:end-pre_end,3),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData4 = timeseries(info.MVopt(1:end-pre_end,4),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData5 = timeseries(info.MVopt(1:end-pre_end,5),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData6 = timeseries(info.MVopt(1:end-pre_end,6),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData7 = timeseries(info.MVopt(1:end-pre_end,7),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
inputData8 = timeseries(info.MVopt(1:end-pre_end,8),info.Topt(1:end-pre_end));
save("inputData1.mat","inputData1","-v7.3");
reference_trajectory = timeseries([traj(1:end-pre_end+1)],info.Topt(1:end-pre_end));