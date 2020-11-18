%------------------------------------------------------------------------------
% run_simulate
%   A bare test case for timing and profiling.
%
% Version:
%   18 November 2020
%------------------------------------------------------------------------------
X = 0:1000;
nSim = 25;
mu = 10;

Co = 1;
C = 4;
A = 20;
model = Combo();
addComponent(model, Nugget(Co));
addComponent(model, Spherical(C, A));

[X, Z] = simulate(X, nSim, mu, correlationLength(model), @(h) computeVariogram(model, h));
