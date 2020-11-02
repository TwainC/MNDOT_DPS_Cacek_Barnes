
    f1 = figure;
%     f2 = figure;
%     f3 = figure;
%     f4 = figure;
%     f5 = figure;
    f6 = figure;
    f7 = figure;
    
    allMeans = zeros(length(swerveFilePaths),16);
    allVars = allMeans;
    allCounts = allVars;
    comparisonSwFiles = [9 10 11 12 13 15 18];
    comparisonLonFiles = [8 9 10 11 12 13 14];
    distance = (0.5:1:17.5);
    k = 1;
    comparisonSwerve = [];
for i=1:length(swerveFilePaths)
    figure(f1);
    [totalTH002] = ribbonDielectric(swerveFilePaths(i),1,[]); hold on
    

    
    plotTH002 = totalTH002(:,2:end);
    plotTH002(1,:) = plotTH002(1,:) - plotTH002(1,1)/2;
    coeffVar = sqrt(plotTH002(3,:))./plotTH002(2,:);
    matLen = length(plotTH002);

    if ismember(i,comparisonSwFiles)
        [A,B,C,D,offsets] = extractFilteredDielectric(lonFilePaths727(comparisonLonFiles(k)));
        means = [mean(A(:,3)), mean(B(:,3)), mean(C(:,3))];
        vars = [var(A(:,3)), var(B(:,3)), var(C(:,3))];
        count = length(A);
        sensorD = [.5,2,3.5];
        
        figure(f6);
        hold on;
        plot(distance(1:matLen),plotTH002(2,:),'-r', 'LineWidth', 2);
        plot(sensorD, means, '-b', 'LineWidth', 2);
        legend("Swerve Lines", "Longitudinal Lines");
        xlabel("Distance from Centerline");
        ylabel("Mean of each segment");
        %title(sprintf("%s and %s", swerveFiles727(i),lonFiles727(comparisonLonFiles(k))));
        hold off;
        
        figure(f7);
        hold on;
        plot(distance(1:matLen),plotTH002(3,:),'-r', 'LineWidth', 2);
        plot(sensorD, vars, '-b', 'LineWidth', 2);
        legend("Swerve Lines", "Longitudinal Lines");
        xlabel("Distance from Centerline");
        ylabel("Variance of each segment");
        ylim([0,.25]);
        %title(sprintf("%s and %s", swerveFiles727(i),lonFiles727(comparisonLonFiles(k))));
        hold off;
        
%         figure;
%         hold on;
%         plot(distance(1:matLen),plotTH002(4,:),'-r', 'LineWidth', 2);
%         plot(sensorD, count, '-b', 'LineWidth', 2);
%         title(sprintf("%s and %s", swerveFiles727(i),lonFiles727(comparisonLonFiles(k))));
%         hold off;
                
        k = k + 1;
    end
    
    
%     allCoeffVar(i,1:matLen) = coeffVar(1:matLen);
%     allMeans(i,1:matLen) = plotTH002(2,1:matLen);
%     allVars(i,1:matLen) = plotTH002(3,1:matLen);
%     allCounts(i,1:matLen) = plotTH002(4,1:matLen);
%     
%     figure(f2);
%     plot(distance(1,1:matLen), plotTH002(2,:),'o'); hold on
%     ylim([4.5 5]);
%     xlim([0 10]);
%     title("Mean v. Distance from centerline");
%     xlabel("Ribbon boundary from centerline [ft]");
%     ylabel("Sample Mean of < Ribbon boundary");
% 
%     
%     figure(f3);
%     plot(distance(1,1:matLen), plotTH002(3,:), 'o'); hold on
%     ylim([0 .06]);
%     xlim([0 10]);
%     title("Variance v. Distance from centerline");
%     xlabel("Ribbon boundary from centerline [ft]");
%     ylabel("Sample Variance of < Ribbon boundary");
%    
%     figure(f4);
%     plot(distance(1,1:matLen), coeffVar, 'o'); hold on
%     ylim([0 .06]);
%     xlim([0 10]);
%     title("Coefficient of Variation v. Distance from centerline");
%     xlabel("Ribbon boundary from centerline [ft]");
%     ylabel("Sample Coefficient of Variation of < Ribbon boundary");
%     
%     figure(f5);
%     plot(distance(1,1:matLen), plotTH002(4,:),'o'); hold on
%     ylim([0 1500]);
%     xlim([0 10]);
%     title("N v. Distance from centerline");
%     xlabel("Ribbon boundary from centerline [ft]");
%     ylabel("N of < Ribbon boundary");
    
    
end
close(f1);

allMeans(allMeans==0) = NaN;
meanMed = median(allMeans,1,'omitnan');
allVars(allVars==0) = NaN;
varsMed = median(allVars,1,'omitnan');
allCounts(allCounts==0) = NaN; 
countsMed = median(allCounts,1,'omitnan');
allCoeffVar (allCoeffVar==0) = NaN;
coeffVarMed = median(allCoeffVar,1,'omitnan');
distance = (0.5:1:17.5);

figure(f2);
plot(distance,meanMed,'-r', 'LineWidth', 5);
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10)); xline(totalTH002(1,11));
figure(f3);
plot(distance,varsMed,'-r', 'LineWidth', 5);
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10)); xline(totalTH002(1,11));
figure(f4);
plot(distance,coeffVarMed,'-r', 'LineWidth', 5);
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10)); xline(totalTH002(1,11));
figure(f5);
plot(distance,countsMed,'-r', 'LineWidth', 5);
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10)); xline(totalTH002(1,11));

