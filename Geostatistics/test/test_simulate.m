%------------------------------------------------------------------------------
% test_simulate
%   A moderate test case with graphical output.
%   
% Version:
%   18 November 2020
%------------------------------------------------------------------------------
tic 

X = 0:10000;
nSim = 25;
mu = 10;

Co = 1;
C = 4;
A = 20;
model = Combo();
addComponent(model, Nugget(Co));
addComponent(model, Spherical(C, A));

[X, Z] = simulate(X, nSim, mu, correlationLength(model), @(h) computeVariogram(model, h));

nrows = floor(sqrt(nSim));
ncols = ceil(nSim/nrows);
hMax = 1.5*A;

% Plot the nSim histograms
figure(1);
ymax = 0;
for i = 1:nSim
    subplot(nrows, ncols, i)
    histogram(Z(i,:), 40);
    V = axis;
    ymax = max(ymax, V(4));
end

for i = 1:nSim
    subplot(nrows, ncols, i)
    axis([min(Z(:)), max(Z(:)), 0, ymax]);
    grid on;
end

% Plot the nSim variograms
figure(2)
ymax = 0;

hhat = linspace(0, hMax, 500);
ghat = computeVariogram(model, hhat);

for i = 1:nSim
    subplot(nrows, ncols, i)
    [h, g, n] = computeVariogram1D(X, Z(i,:), hMax, 20);
    plot(h, g, 'ok', hhat, ghat, '-b');    
    V = axis;
    ymax = max(ymax, V(4));    
end

for i = 1:nSim
    subplot(nrows, ncols, i)
    axis([0, hMax, 0, ymax]);
    grid on
end

toc