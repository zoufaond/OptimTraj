clc
clear all
data;
nx = 4;
ny = 4;
nu = 4;
nlobj = nlmpc(nx,ny,nu);
Ts = 0.04;
p_hor = 50;
c_hor = 50;
nlobj.Ts = Ts;
for i=1:4
nlobj.MV(i).Min = 0;
nlobj.MV(i).Max = 1;
end
% sin_q1 = [(sin(linspace(0,pi,p)-pi/2)'+1)/2-pi/2];
% sin_q2 = [(sin(linspace(0,2*pi,p)-pi/2)'+1)/6];
% % sin_q2 = linspace(0,1,p)'.^2;
scale = 1.5;
traj = [(sin(linspace(0,pi,p_hor)-pi/2)'+1)/scale+x0(1)+x0(2)];
% nlobj.Weights.ManipulatedVariablesRate = [0,0];

nlobj.PredictionHorizon = p_hor;
nlobj.ControlHorizon = c_hor;
nlobj.Model.StateFcn = "optim_control_nlmpc";
nlobj.Optimization.CustomCostFcn = @(X,U,e,data) 1*sum(sum(U(1:p_hor,:).^2)) +(sum((X(10:p_hor,1)-0).^2)+sum((X(10:p_hor,2)-0.3).^2))*100; %+sum((X(1:p_hor,1)+X(1:p_hor,2)-traj).^2)%+sum(reaction_angle(X(2:p_hor,1:4)',U(2:p_hor,1:2)',e,data).^2)*1e-8
nlobj.Optimization.ReplaceStandardCost = true;
% nlobj.Optimization.CustomEqConFcn = @(X,U,data) [(X(1:p_hor,1)+X(1:p_hor,2)-traj)]; %X(end,1)+X(end,2)-pi/2  U(1,:)' - [0;0;0] [X(1:p,1)-sin_time;X(1:p,2)-0.3]
% nlobj.Optimization.CustomIneqConFcn = @(X,U,data) reaction_angle(X(10,1:4),U(10,1:2))-40*pi/180;
% nlobj.Optimization.CustomEqConFcn = @(X,U,data) [reaction_angle(X(25,1:4)',U(25,1:2)',data);reaction_angle(X(20,1:4)',U(20,1:2)',data)];
% 

initialConditions = x0;
u0 = [0;0;0;0];
validateFcns(nlobj,x0,u0);
[~,~,info] = nlmpcmove(nlobj,x0,u0);
% 
% plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue',info.Topt,[sin_q1;0],'o',info.Topt,[sin_q2;0],'square')
% 
% % figure
% % subplot(3,1,1)
figure
plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue',info.Topt,info.Xopt(:,2)+info.Xopt(:,1),'blue',info.Topt,[(sin(linspace(0,pi,length(info.Topt)-1)-pi/2)'+1)/scale+x0(1)+x0(2);0],'o')
legend('1','2')
% 
% % plot(info.Topt,info.Xopt(:,3),'red',info.Topt,info.Xopt(:,4),'blue')
% % subplot(3,1,3)
% % plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue') %,info.Topt,info.MVopt(:,3),'green'
% % legend('1','2','3')
figure
plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue',info.Topt,info.MVopt(:,3),'green',info.Topt,info.MVopt(:,4),'black')
legend('1','2','3','4')
% 
inputData1 = timeseries(info.MVopt(:,1),info.Topt);
save("inputData1.mat","inputData1","-v7.3");
inputData2 = timeseries(info.MVopt(:,2),info.Topt);
save("inputData1.mat","inputData1","-v7.3");
inputData3 = timeseries(info.MVopt(:,3),info.Topt);
save("inputData1.mat","inputData1","-v7.3");
inputData4 = timeseries(info.MVopt(:,4),info.Topt);
save("inputData1.mat","inputData1","-v7.3");