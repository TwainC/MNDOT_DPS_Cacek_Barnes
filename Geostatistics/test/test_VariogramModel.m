%------------------------------------------------------------------------------
% Version:
%   19 October 2020
%------------------------------------------------------------------------------
folder = 'D:\Google Drive\Research\MnDOT Density Profiling\data\TH002_L1_2020-07-27\';
file   = 'TH002_2020-07-27_rdm2__001.csv';

FEET_PER_METER = 100/(2.54*12);
hmax = 15;
nh = 150;

[sensorA, sensorB, sensorC, D] = extractDielectric(strcat(folder, file));

%--------------------
X = sensorA(:,1:2);
Z = sensorA(:,3);
[h, g, n] = computeVariogram2D(X, Z, hmax, nh);
h = h*FEET_PER_METER;

Alpha = Combo();
addComponent(Alpha, Nugget([0, 0.004, 0.1]));
addComponent(Alpha, Spherical([0, 0.006, inf], [0, 1.0, 5]));
addComponent(Alpha, Spherical([0, 0.02, inf], [5, 6.1, 100]));

[~, exitflag] = fit(Alpha, h, g, n);
assert(exitflag > 0);

figure(1)
plotVariogram(h, g, [], Alpha, ...
    'hunits', 'ft', 'color', 'blue', 'variance', var(Z));
title(sprintf('%s | Sensor A', file), 'interpreter', 'none');
grid on;

%--------------------
X = sensorB(:,1:2);
Z = sensorB(:,3);
[h, g, n] = computeVariogram2D(X, Z, hmax, nh);
h = h*FEET_PER_METER;

Beta = Combo();
addComponent(Beta, Nugget([0, 0.004, 0.1]));
addComponent(Beta, Spherical([0, 0.01, inf], [0, 1, 5]));
addComponent(Beta, Spherical([0, 0.01, inf], [5, 10, 100]));
[~, exitflag] = fit(Beta, h, g, n);
assert(exitflag > 0);

figure(2)
plotVariogram(h, g, [], Beta, ...
    'hunits', 'ft', 'color', 'red', 'display', 'on', 'variance', var(Z));
title(sprintf('%s | Sensor B', file), 'interpreter', 'none');
grid on;

%--------------------
X = sensorA(:,1:2);
Z = sensorA(:,3);
[h, g, n] = computeVariogram2D(X, Z, hmax, nh);
h = h*FEET_PER_METER;

Alpha = Combo();
addComponent(Alpha, Nugget([0, 0.004, 0.1]));
addComponent(Alpha, Spherical([0, 0.02, inf], [5, 6.1, 100]));

[~, exitflag] = fit(Alpha, h, g, n);
assert(exitflag > 0);

figure(3)
plotVariogram(h, g, [], Alpha, ...
    'hunits', 'ft', 'color', 'blue', 'variance', var(Z));
title(sprintf('%s | Sensor A', file), 'interpreter', 'none');
grid on;

%--------------------
X = sensorB(:,1:2);
Z = sensorB(:,3);
[h, g, n] = computeVariogram2D(X, Z, hmax, nh);
h = h*FEET_PER_METER;

Beta = Combo();
addComponent(Beta, Nugget([0, 0.004, 0.1]));
addComponent(Beta, Spherical([0, 0.01, inf], [5, 10, 100]));
[~, exitflag] = fit(Beta, h, g, n);
assert(exitflag > 0);

figure(4)
plotVariogram(h, g, [], Beta, ...
    'hunits', 'ft', 'color', 'red', 'display', 'on', 'variance', var(Z));
title(sprintf('%s | Sensor B', file), 'interpreter', 'none');
grid on;

%--------------------
X = sensorC(:,1:2);
Z = sensorC(:,3);
[h, g, n] = computeVariogram2D(X, Z, hmax, nh);
h = h*FEET_PER_METER;

Delta = Combo();
addComponent(Delta, Nugget([0, 0.004, inf]));
addComponent(Delta, Spherical([0, 0.01, inf], [0, 1, 100]));
[~, exitflag] = fit(Delta, h, g, n);
assert(exitflag > 0);

figure(5)
plotVariogram(h, g, [], Delta, ...
    'hunits', 'ft', 'color', 'black', 'display', 'on', 'variance', var(Z));
title(sprintf('%s | Sensor C', file), 'interpreter', 'none');
grid on;

%--------------------
X = sensorC(:,1:2);
Z = sensorC(:,3);
[h, g, n] = computeVariogram2D(X, Z, hmax, 50);
h = h*FEET_PER_METER;

Delta = Combo();
addComponent(Delta, Nugget([0, 0.004, inf]));
addComponent(Delta, Spherical([0, 0.01, inf], [0, 1, 100]));
[~, exitflag] = fit(Delta, h, g, n);
assert(exitflag > 0);

figure(6)
plotVariogram(h, g, n, Delta, ...
    'hunits', 'ft', 'color', 'black', 'display', 'on', 'variance', var(Z));
title(sprintf('%s | Sensor C', file), 'interpreter', 'none');
grid on;
