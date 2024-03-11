% Integrate the equations over from 0 to 5 seconds with 50 steps.
t_end = 10;

% Set initial angles in radians and the initial speeds to zero.
initialConditions = [-pi/2;0;0;0];

% Define particles' mass, pendulums' length, and the acceleration due to
% gravity.
m = 1.0;
l = 10.0;
g = 9.81;
% koeficienty tlumeni minus, protoze v pythonu jsou momenty s opacnym
% znamenkem
c1 = 10;
c2 = 10;
k1 = 0;
k2 = 0;
F1 = 0;
F2 = 0;
F3 = 0;

OUT = sim('double_pend_example.slx',t_end);

% % Create a function handle to an anonymous function which which can pass the
% % parameters.
% f = @(t, x) fun_pydy(t, x, m, l, g);
% 
% % Integrate the equations of motion with default integration settings.
% [t, x] = ode45(f, timeSpan, initialConditions_pydy);
% % Plot the results.
% fig = figure();
% plot(t, x(:,1),t,x(:,2))
% title('pydy')
% xlabel('Time [s]')
% legend('q1 [rad]','q2 [rad]')
% Create a function handle to an anonymous function which which can pass the
% parameters.
f = @(t, x) Double_pend_forward(t, x, m, l, g, c1, c2, k1, k2,F1,F2,F3);
% 
% Integrate the equations of motion with default integration settings.
[t, x] = ode45(f, OUT.tout, initialConditions);
% Plot the results.
fig = figure();
plot(t, x(:,1),t,x(:,2),t,OUT.q1(1,:),'o',t,OUT.q2(1,:),'*')
title('moje')
xlabel('Time [s]')
legend('q1 [rad]','q2 [rad]','q1_sim [rad]','q2_sim [rad]')