% MAIN.m
%
% Solve the cart-pole swing-up problem

clc; clear;
addpath ../../

p.m1 = 2.0;  % (kg) Cart mass
p.m2 = 0.5;  % (kg) pole mass
p.g = 9.81;  % (m/s^2) gravity
p.l = 0.5;   % (m) pendulum (pole) length

dist = 0.8;  %How far must the cart translate during its swing-up
maxForce = 10000;  %Maximum actuator forces
duration = 1;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                     Set up function handles                             %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

problem.func.dynamics = @(t,x,u)(optim_control(x,u) );
problem.func.pathObj = @(t,z,u)( (sum(u.^2)) );  %Force-squared cost function

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
    'MaxFunEvals',1e5);

problem.options.method = 'trapezoid';
problem.options.trapezoid.nGrid = 50;
% problem.options.method = 'hermiteSimpson';
% problem.options.method = 'rungeKutta';
% problem.options.method = 'chebyshev';

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                            Solve!                                       %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

% soln = optimTraj(problem);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%                        Display Solution                                 %
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

%%%% Unpack the simulation
t = linspace(soln.grid.time(1), soln.grid.time(end), 150);
z = soln.interp.state(t);
u = soln.interp.control(t);

% plot(t,z(1,:),t,z(2,:))
plot(t,u(1,:),t,u(2,:))
legend('1','2')