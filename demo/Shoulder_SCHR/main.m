clc
clear all
data;
% nx = 4;
% ny = 4;
% nu = 2;
% nlobj = nlmpc(nx,ny,nu);
% Ts = 0.04;
% p = 50;
% c = 50;
% nlobj.Ts = Ts;
% for i=1:2
% nlobj.MV(i).Min = -100000;
% nlobj.MV(i).Max = 100000;
% end
% sin_q1 = [(sin(linspace(0,pi,p)-pi/2)'+1)/2-pi/2];
% sin_q2 = [(sin(linspace(0,2*pi,p)-pi/2)'+1)/6];
% % sin_q2 = linspace(0,1,p)'.^2;
% traj = [-pi/2*ones(p,1)*0.501,sin_q2*0];
% nlobj.Weights.ManipulatedVariablesRate = [0,0];
% 
% nlobj.PredictionHorizon = p;
% nlobj.ControlHorizon = c;
% nlobj.Model.StateFcn = "optim_control_nlmpc";
% nlobj.Optimization.CustomCostFcn = @(X,U,e,data) sum(sum(U(1:p,:).^2)) ; %+1e8*(sum(sum(((X(1:p,1:2)-traj).^2))))%1e8*(sum(sum(((X(1:p,1:2)-traj).^2))))+sum(sum(U(1:p,:).^2))
% nlobj.Optimization.ReplaceStandardCost = true;
% nlobj.Optimization.CustomEqConFcn = @(X,U,data) X(end,:)'-[0,0,0,0]'; %U(1,:)' - [0;0;0] [X(1:p,1)-sin_time;X(1:p,2)-0.3]
% 
% x0 = [-pi/2;0;0;0];
% initialConditions = x0;
% u0 = [0;0];
% validateFcns(nlobj,x0,u0);
% [~,~,info] = nlmpcmove(nlobj,x0,u0);
% 
% % plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue',info.Topt,[sin_q1;0],'o',info.Topt,[sin_q2;0],'square')
% 
% % figure
% % subplot(3,1,1)
% figure
% plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue')
% legend('1','2')
% 
% % plot(info.Topt,info.Xopt(:,3),'red',info.Topt,info.Xopt(:,4),'blue')
% % subplot(3,1,3)
% % plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue') %,info.Topt,info.MVopt(:,3),'green'
% % legend('1','2','3')
% figure
% plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue')
% legend('1','2')
% 
% inputData1 = timeseries(info.MVopt(:,1),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");
% inputData2 = timeseries(info.MVopt(:,2),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");
% % inputData3 = timeseries(info.MVopt(:,3),info.Topt);
% % save("inputData1.mat","inputData1","-v7.3");