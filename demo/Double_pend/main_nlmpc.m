clc
clear all
c1 = 10;
c2 = 10;
k1 = 0;
k2 = 0;
nx = 4;
ny = 4;
nu = 2;
nlobj = nlmpc(nx,ny,nu);
Ts = 0.04;
p = 25;
c = p;
nlobj.Ts = Ts;
for i=1:2
nlobj.MV(i).Min = -100000;
nlobj.MV(i).Max = 100000;
end
sin_q1 = [(sin(linspace(0,pi,p)-pi/2)'+1)/2-pi/2];
sin_q2 = [(sin(linspace(0,2*pi,p)-pi/2)'+1)/6];
% sin_q2 = linspace(0,1,p)'.^2;
traj = [sin_q1,sin_q2];
nlobj.Weights.ManipulatedVariablesRate = [0,0];

nlobj.PredictionHorizon = p;
nlobj.ControlHorizon = c;
nlobj.Model.StateFcn = "optim_control_nlmpc";
nlobj.Optimization.CustomCostFcn = @(X,U,e,data) sum(sum(U(1:p,:).^2)) ; %1e8*(sum(sum(((X(1:p,1:2)-traj).^2))))+sum(sum(U(1:p,:).^2))
nlobj.Optimization.ReplaceStandardCost = true;
nlobj.Optimization.CustomEqConFcn = @(X,U,data) [X(end,:)'-[pi/2,0,0,0]';X(ceil(end/2),2)-0]; %U(1,:)' - [0;0;0] [X(1:p,1)-sin_time;X(1:p,2)-0.3]

x0 = [-pi/2;0;0;0];
initialConditions = x0;
u0 = [0;0];
validateFcns(nlobj,x0,u0);
[~,~,info] = nlmpcmove(nlobj,x0,u0);

addpath ../../

maxForce = 10000;  %Maximum actuator forces
duration = 1;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up function handles                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.func.dynamics = @(t,x,u)(optim_control_optimtraj(x,u) );
problem.func.pathObj = @(t,z,u)( (sum(u.^2,1) ));  %Force-squared cost function
problem.func.pathCst = @(t,x,u)( pathConstraint(x) );


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up problem bounds                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = duration;
problem.bounds.finalTime.upp = duration;

problem.bounds.initialState.low = [-pi/2;0;0;0];
problem.bounds.initialState.upp = [-pi/2;0;0;0];
problem.bounds.finalState.low = [pi/2;0;0;0];
problem.bounds.finalState.upp = [pi/2;0;0;0];

problem.bounds.state.low = [-inf;-inf;-inf;-inf];
problem.bounds.state.upp = [inf;inf;inf;inf];

problem.bounds.control.low = -maxForce*[1;1];
problem.bounds.control.upp = maxForce*[1;1];

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                    Initial guess at trajectory                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.guess.time = [0,duration];
problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.low];
problem.guess.control = ones(2,2);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                         Solver options                                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.options.nlpOpt = optimset(...
    'Display','iter',...
    'MaxFunEvals',1e6);

problem.options.method = 'trapezoid';
problem.options.trapezoid.nGrid = 100;
% problem.options.method = 'hermiteSimpson';
% problem.options.hermiteSimpson.nSegment = 100;
% problem.options.method = 'rungeKutta';
% problem.options.rungeKutta.nSegment = 60;
% problem.options.rungeKutta.nSubStep = 10;
% problem.options.method = 'chebyshev';

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                            Solve!                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

soln = optimTraj(problem);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Display Solution                                 %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%%%% Unpack the simulation
t = linspace(soln.grid.time(1), soln.grid.time(end), 150);
z = soln.interp.state(t);
u = soln.interp.control(t);
% plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue',info.Topt,[sin_q1;0],'o',info.Topt,[sin_q2;0],'square')

figure
subplot(2,1,1)
plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue',t,z(1,:),t,z(2,:))
legend('x1 nlmpc', 'x2 nlmpc','x1 optimtraj','x2 optimtraj')
% subplot(3,1,2)
% plot(info.Topt,info.Xopt(:,3),'red',info.Topt,info.Xopt(:,4),'blue')
subplot(2,1,2)
plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue',t,u(1,:),t,u(2,:)) %,info.Topt,info.MVopt(:,3),'green'
legend('u1 nlmpc','u2 nlmpc','u1 optimtraj', 'u2 optimtraj')



% inputData1 = timeseries(info.MVopt(:,1),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");
% inputData2 = timeseries(info.MVopt(:,2),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");
% inputData3 = timeseries(info.MVopt(:,3),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");