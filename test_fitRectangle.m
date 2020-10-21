[A,B,C,D] = extractFilteredDielectric(swerveFile);
x = [A(:,1);B(:,1);C(:,1)]';
y = [A(:,2);B(:,2);C(:,2)]';

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

