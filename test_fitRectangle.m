n = 1000;
Xmax = 250;
Ymax = 10;

alpha = 2*pi*rand();
Rinv = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)];    

X = Xmax*rand(1, n);
Y = Ymax*rand(1, n);
xy = Rinv*[X; Y];
x = xy(1,:) + 1000*rand();
y = xy(2,:) + 1000*rand();

[rectangleLength, rectangleWidth, rectangleTheta, corners] = fitRectangle(x, y);

fill(corners(1,:), corners(2,:), [0.9, 0.9, 0.9]);
hold on;
plot(x, y, '.b');
title(sprintf('Length = %.2f | Width = %.2f | Theta = %.1f [deg]', ...
    rectangleLength, rectangleWidth, rad2deg(rectangleTheta)));

for j = 1:4
    text(corners(1,j), corners(2,j), sprintf('%d', j), 'FontSize', 18);
end

hold off;
axis equal;

