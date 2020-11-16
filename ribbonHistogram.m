%% Data Collection
hist = ribbonDielectricHist(swerveFilePaths(1),1,[],0,0,6);

for i = 1:length(swerveFilePaths)
    hist = [hist;ribbonDielectricHist(swerveFilePaths(i),1,[],0,0,6)];
end

dielectric = hist(:,3);

%% Data Analyis
means = mean(dielectric);
stds = std(dielectric);

histogram(dielectric);
hold on;
xlim([3.5,6]);
title(sprintf("Mean = %.2f | SD = %.2f | z<=|1| = .8455 | z<=|2| = .9748 | z <=|3| = .9907", means, stds));
xline(means,'r', 'LineWidth', 2); xline(means - stds,'g', 'Linewidth',2); xline(means + stds,'g', 'Linewidth',2); xline(means - 2*stds,'c', 'Linewidth',2); xline(means + 2*stds,'c', 'Linewidth',2);
text(means,1000,'z<|1| = .8455')
hold off;
sum(dielectric <= means + stds & dielectric >= means - stds)/length(dielectric);
sum(dielectric <= means + 2*stds & dielectric >= means - 2*stds)/length(dielectric);
sum(dielectric <= means + 3*stds & dielectric >= means - 3*stds)/length(dielectric);

%% Variogram

[h, g, n] = computeVariogram2D(hist(:,1:2),dielectric,20,100);
view(h*3.28,g,n);
hold on;
yline(var(dielectric));