clc
clear all
parameters;
nx = 6;
ny = 6;
nu = 15;
nlobj = nlmpc(nx,ny,nu);
Ts = 0.02;
p_hor = 50;
c_hor = 50;
nlobj.Ts = Ts;
for i=1:15
nlobj.MV(i).Min = 0;
nlobj.MV(i).Max = 1;
end

% for i=10:12
% nlobj.MV(i).Min = 0;
% nlobj.MV(i).Max = 0.001;
% end
nlobj.States(1).Max = x0(1);
nlobj.States(2).Max = x0(2);

% sin_q1 = [(sin(linspace(0,pi,p)-pi/2)'+1)/2-pi/2];
% sin_q2 = [(sin(linspace(0,2*pi,p)-pi/2)'+1)/6];
% % sin_q2 = linspace(0,1,p)'.^2;
scale = 0.8;
traj = -(sin(linspace(0,pi,p_hor)-pi/2)'+1)*scale+x0(1)+x0(2)+x0(3); %+x0(1)+x0(2)
% traj1 = zeros(p_hor/2,1);
% traj = [traj1;traj2];
% nlobj.Weights.ManipulatedVariablesRate = [0,0];

nlobj.PredictionHorizon = p_hor;
nlobj.ControlHorizon = c_hor;
nlobj.Model.StateFcn = "optim_control_nlmpc";
% +(sum((X(10:p_hor,1)-0).^2)+sum((X(10:p_hor,2)-0.3).^2))*100
nlobj.Optimization.CustomCostFcn = @(X,U,e,data) 1*sum(sum(U(1:p_hor,:).^2))+sum((X(1:p_hor,1)+X(1:p_hor,2)+X(1:p_hor,3)-traj).^2)*10; %
nlobj.Optimization.ReplaceStandardCost = true;
nlobj.Optimization.SolverOptions.Display = "iter-detailed";
nlobj.Optimization.SolverOptions.MaxIterations = 1000;
nlobj.Optimization.SolverOptions.StepTolerance = 1e-10;
nlobj.Optimization.SolverOptions.OptimalityTolerance = 1e-10;
nlobj.Optimization.SolverOptions.ConstraintTolerance = 1e-10;
nlobj.Optimization.SolverOptions.FunctionTolerance = 1e-10;
% phi_timespan = 1:p_hor;
% phi_bound = 8;
% nlobj.Optimization.CustomIneqConFcn = @(X,U,e,data) [phi_react(X(phi_timespan,:),U(phi_timespan,:),data)-phi_bound;-phi_react(X(phi_timespan,:),U(phi_timespan,:),data)-phi_bound]; %phi_react(X(50:70,1:4),U(50:70,1:2),data)-50
% nlobj.Optimization.CustomEqConFcn = @(X,U,data) X(end,1)+X(end,2)-140/180*pi;

initialConditions = x0;
u0 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
validateFcns(nlobj,x0,u0);
[~,~,info] = nlmpcmove(nlobj,x0,u0);

% figure
% plot(info.Topt,info.Xopt(:,1)*180/pi,'red',info.Topt,info.Xopt(:,2)*180/pi,'blue',info.Topt,info.Xopt(:,3)*180/pi,'yellow',info.Topt,(info.Xopt(:,3)+info.Xopt(:,2)+info.Xopt(:,1))*180/pi,'green',info.Topt,[traj;0]*180/pi,'o')
% legend('1','2','3','1+2+3','prescribed')
% 
% figure
% plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue',info.Topt,info.MVopt(:,3),'green',info.Topt,info.MVopt(:,4),'black',info.Topt,info.MVopt(:,5),'yellow',info.Topt,info.MVopt(:,6),'cyan')
% legend('Supraspin','DEL','TerMin','Trap1','Trap2','Trap3')
% 
% figure
% plot(info.Topt,info.MVopt(:,7),'red',info.Topt,info.MVopt(:,8),'blue',info.Topt,info.MVopt(:,9),'green',info.Topt,info.MVopt(:,10),'black',info.Topt,info.MVopt(:,11),'yellow',info.Topt,info.MVopt(:,12),'cyan',info.Topt,info.MVopt(:,13),'magenta')
% legend('Trap4','levator','Rhomb','PECM1','PECM2','PECM3','Serr1')
% 
% figure
% plot(info.Topt,info.MVopt(:,14),'red',info.Topt,info.MVopt(:,15),'green')
% legend('Serr2','Serr3')
% 
% % figure
% % plot(out.tout,out.react_ang.signals.values)
% % legend('Reaction Angle')
% 
% % pre_end = 1;
% % inputData = timeseries(info.MVopt(1:end-pre_end,:),info.Topt(1:end-pre_end));
% % save("inputData.mat","inputData","-v7.3");