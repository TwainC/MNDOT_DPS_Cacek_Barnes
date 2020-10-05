% Generate some random data to use as an example.
n = 250;
x = 100.0 * rand(n,1);
y = 100.0 * rand(n,1);

mu = 4.5 + (x-min(x))/(max(x)-min(x));  % the mean increases left to right.
z = normrnd(mu, 0.3, n, 1);             % normal random values with a shifting mean.

% The following gives a nonlinear scaling for the selection
% of colors, but a linear scale on the colorbar. This results
% in dots that have colors evenly distributed across the choosen
% range, but the colorbar is squished.

[s,I] = sort(z);
baseMap = turbo(n);
scatter(x(I), y(I), 50, baseMap, 'filled');
grid(gca,'minor')
grid on

newMap = interp1(s, baseMap, linspace(s(1), s(n), n));
colormap(newMap)
caxis([s(1), s(n)]);
colorbar;
