clear all
data;
addpath ../../../
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up function handles                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
duration = 2;
problem.func.dynamics = @(t,x,u) optim_control_optimtraj(x,u,params);
problem.func.pathObj = @(t,x,u)((sum(u.^2,1)))+100*sum( (-reference_trajectory(t,duration,x0)+x(2,:)+x(1,:)).^2 ); %
% problem.func.pathCst = @(t,x,u) reference_trajectory(t,x,duration,x0);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up problem bounds                               %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%




problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = duration;
problem.bounds.finalTime.upp = duration;

problem.bounds.initialState.low = x0';
problem.bounds.initialState.upp = x0';
problem.bounds.finalState.low = -inf(4,1);
problem.bounds.finalState.upp = inf(4,1);

problem.bounds.state.low = -Inf(4,1);
problem.bounds.state.upp =  Inf(4,1);

problem.bounds.control.low = zeros(8,1);
problem.bounds.control.upp = ones(8,1);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                    Initial guess at trajectory                          %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.guess.time = [0,1,2];
problem.guess.state = [x0', x0',x0'];
problem.guess.control = ones(8,3);

% problem.guess.time = soln.grid.time;
% problem.guess.state = soln.grid.state;
% problem.guess.control = soln.grid.control;


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                         Solver options                                  %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.options.nlpOpt = optimset(...
    'Display','iter',...
    'MaxFunEvals',1e6);

problem.options.method = 'trapezoid';
problem.options.trapezoid.nGrid = 10;
% problem.options.method = 'hermiteSimpson';
% problem.options.hermiteSimpson.nSegment = 30;
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
% t = linspace(soln.grid.time(1), soln.grid.time(end), 150);
% z = soln.interp.state(t);
% u = soln.interp.control(t);
% % plot(info.Topt,info.Xopt(:,1),'red',info.Topt,info.Xopt(:,2),'blue',info.Topt,[sin_q1;0],'o',info.Topt,[sin_q2;0],'square')
% 
figure
% subplot(2,1,1)
% plot(t,z(1,:),t,z(2,:),t,z(1,:)+z(2,:))
% legend('x1 optimtraj','x2 optimtraj','x1+x2')
subplot(2,1,2)
plot(soln.grid.time,soln.grid.state(1,:),soln.grid.time,soln.grid.state(2,:),soln.grid.time,soln.grid.state(1,:)+soln.grid.state(2,:))
% subplot(2,1,2)
% plot(info.Topt,info.MVopt(:,1),'red',info.Topt,info.MVopt(:,2),'blue',t,u(1,:),t,u(2,:)) %,info.Topt,info.MVopt(:,3),'green'
% legend('u1 nlmpc','u2 nlmpc','u1 optimtraj', 'u2 optimtraj')



% inputData1 = timeseries(info.MVopt(:,1),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");
% inputData2 = timeseries(info.MVopt(:,2),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");
% inputData3 = timeseries(info.MVopt(:,3),info.Topt);
% save("inputData1.mat","inputData1","-v7.3");