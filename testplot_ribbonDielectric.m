

    f2 = figure;
    f3 = figure;
%    f4 = figure;
    f5 = figure;
%     f6 = figure;
%     f7 = figure;
%     
    allMeans = zeros(length(swerveFilePaths),18);
    allVars = allMeans;
    allCounts = allVars;
    comparisonSwFiles = [9 10 11 12 13 15 18];
    comparisonLonFiles = [8 9 10 11 12 13 14];
    distance = (0.5:1:17.5);
    k = 1;
    comparisonSwerve = [];
for i=1:length(swerveFilePaths)
    [totalTH002, serials] = ribbonDielectric(swerveFilePaths(i),1,[],0,1);
    

    
    plotTH002 = totalTH002(:,2:end);
    plotTH002(1,:) = plotTH002(1,:) - plotTH002(1,1)/2;
    %coeffVar = sqrt(plotTH002(3,:))./plotTH002(2,:);
    matLen = length(plotTH002(1,:));

%     if ismember(i,comparisonSwFiles)
%         [A,B,C,D,offsets] = extractFilteredDielectric(lonFilePaths727(comparisonLonFiles(k)));
%         means = [mean(A(:,3)), mean(B(:,3)), mean(C(:,3))];
%         vars = [var(A(:,3)), var(B(:,3)), var(C(:,3))];
%         count = length(A);
%         sensorD = [0,1.5,3];
%         
%         figure(f6);
%         hold on;
%         plot(distance(1:matLen),plotTH002(2,:),'or', 'LineWidth', 2);
%         plot(sensorD, means, 'ob', 'LineWidth', 2);
%         legend("Swerve Lines", "Longitudinal Lines");
%         xlabel("Distance from Centerline [ft]");
%         ylabel("Mean of each segment");
%         title("Mean comparison between coincedent swerve and longitudinal paths");
%         grid on;
%         hold off;
%         
%         figure(f7);
%         hold on;
%         plot(distance(1:matLen),plotTH002(3,:),'or', 'LineWidth', 2);
%         plot(sensorD, vars, 'ob', 'LineWidth', 2);
%         legend("Swerve Lines", "Longitudinal Lines");
%         xlabel("Distance from Centerline [ft]");
%         ylabel("Variance of each segment");
%         ylim([0,.25]);
%         title("Variance comparison between coincedent swerve and longitudinal paths");
%         grid on;
%         hold off;
%                 
%         k = k + 1;
%     end
    
    
    %allCoeffVar(i,1:matLen) = coeffVar(1:matLen);
    allMeans(i,1:matLen) = plotTH002(2,1:matLen);
    allVars(i,1:matLen) = plotTH002(3,1:matLen);
    allCounts(i,1:matLen) = plotTH002(4,1:matLen);
    
%     AMeans(i,1:matLen) = plotTH002(5,1:matLen);
%     AVars(i,1:matLen) = plotTH002(6,1:matLen);
%     ACounts(i,1:matLen) = plotTH002(7,1:matLen);
%     
%     BMeans(i,1:matLen) = plotTH002(8,1:matLen);
%     BVars(i,1:matLen) = plotTH002(9,1:matLen);
%     BCounts(i,1:matLen) = plotTH002(10,1:matLen);
%     
%     CMeans(i,1:matLen) = plotTH002(11,1:matLen);
%     CVars(i,1:matLen) = plotTH002(12,1:matLen);
%     CCounts(i,1:matLen) = plotTH002(13,1:matLen);
    
    figure(f2);
    plot(distance(1:matLen), plotTH002(2,:),'o'); hold on
%     plot(distance(1:matLen), plotTH002(5,:), 'x');
%     plot(distance(1:matLen), plotTH002(8,:), 'p');
%     plot(distance(1:matLen), plotTH002(11,:), 's');
    ylim([4.5 5]);
    xlim([0 10]);
%     sensorA = sprintf("Sensor # %.1d", serials(1));
%     sensorB = sprintf("Sensor # %.1d", serials(2));
%     sensorC = sprintf("Sensor # %.1d", serials(3));
%     legend("Total Summary Statistics",sensorA, sensorB,sensorC);
    title("Mean v. Distance from centerline");
    xlabel("Ribbon boundary from centerline [ft]");
    ylabel("Sample Mean of < Ribbon boundary");

    
    figure(f3);
    plot(distance(1:matLen), plotTH002(3,:), 'o'); hold on
%     plot(distance(1:matLen), plotTH002(6,:), 'x');
%     plot(distance(1:matLen), plotTH002(9,:), 'p');
%     plot(distance(1:matLen), plotTH002(12,:), 's');
    ylim([0 .06]);
    xlim([0 10]);
%     sensorA = sprintf("Sensor # %.1d", serials(1));
%     sensorB = sprintf("Sensor # %.1d", serials(2));
%     sensorC = sprintf("Sensor # %.1d", serials(3));
%     legend("Total Summary Statistics",sensorA, sensorB,sensorC);
    title("Variance v. Distance from centerline");
    xlabel("Ribbon boundary from centerline [ft]");
    ylabel("Sample Variance of < Ribbon boundary");
%    
%     figure(f4);
%     plot(distance(1,1:matLen), coeffVar, 'o'); hold on
%     ylim([0 .06]);
%     xlim([0 10]);
%     legend("Total Summary Statistics","Sensor # %.1f","Sensor # %.1f","Sensor # %.1f",...
%         serials(1),serials(2),serials(3));
%     title("Coefficient of Variation v. Distance from centerline");
%     xlabel("Ribbon boundary from centerline [ft]");
%     ylabel("Sample Coefficient of Variation of < Ribbon boundary");
%     
    figure(f5);
    plot(distance(1:matLen), plotTH002(4,:),'o'); hold on
%     plot(distance(1:matLen), plotTH002(7,:), 'x');
%     plot(distance(1:matLen), plotTH002(10,:), 'p');
%     plot(distance(1:matLen), plotTH002(13,:), 's');
    ylim([0 1500]);
    xlim([0 10]);
%     sensorA = sprintf("Sensor # %.1d", serials(1));
%     sensorB = sprintf("Sensor # %.1d", serials(2));
%     sensorC = sprintf("Sensor # %.1d", serials(3));
%     legend("Total Summary Statistics",sensorA, sensorB,sensorC);
    title("N v. Distance from centerline");
    xlabel("Ribbon boundary from centerline [ft]");
    ylabel("N of < Ribbon boundary");
    
    
end

allMeans(allMeans==0) = NaN;
meanMed = median(allMeans,1,'omitnan');
allVars(allVars==0) = NaN;
varsMed = median(allVars,1,'omitnan');
allCounts(allCounts==0) = NaN; 
countsMed = median(allCounts,1,'omitnan');
% allCoeffVar (allCoeffVar==0) = NaN;
% coeffVarMed = median(allCoeffVar,1,'omitnan');

% AMeans(AMeans==0) = NaN;
% AMeansMed = median(AMeans,1);
% AVars(AVars==0) = NaN;
% AVarsMed = median(AVars,1);
% ACountsMed = median(ACounts,1);
% BMeans(BMeans==0) = NaN;
% BMeansMed = median(BMeans,1);
% BVars(BVars==0) = NaN;
% BVarsMed = median(BVars,1);
% BCountsMed = median(BCounts,1);
% CMeans(CMeans==0) = NaN;
% CMeansMed = median(CMeans,1);
% CVars(CVars==0) = NaN;
% CVarsMed = median(CVars,1);
% CCountsMed = median(CCounts,1);
    
medianA = sprintf("Sensor # %.1d Median", serials(1));
medianB = sprintf("Sensor # %.1d Median", serials(2));
medianC = sprintf("Sensor # %.1d Median", serials(3));
popMed = sprintf("Population Median");

figure(f2);
meanPlots(1) = plot(distance(1:length(meanMed)),meanMed,'pb', 'MarkerSize', 15, 'MarkerFaceColor', 'black');
% meanPlots(2) = plot(distance,AMeansMed,'pm', 'MarkerSize', 15, 'MarkerFaceColor', 'magenta');
% meanPlots(3) = plot(distance,BMeansMed,'pc', 'MarkerSize', 15, 'MarkerFaceColor', 'cyan');
% meanPlots(4) = plot(distance,CMeansMed,'pg', 'MarkerSize', 15, 'MarkerFaceColor', 'green');
meanPlots(2) = plot(NaN,NaN,'o');
% meanPlots(6) = plot(NaN,NaN,'x');
% meanPlots(7) = plot(NaN,NaN,'p');
% meanPlots(8) = plot(NaN,NaN,'s');
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10));
%lgd = legend(meanPlots, popMed, medianA, medianB, medianC, 'Ribbon Mean','Sensor #171 Ribbon Mean','Sensor #173 Ribbon Mean','Sensor #181 Ribbon Mean');
lgd = legend(meanPlots, popMed,'Ribbon Mean');

figure(f3);
varPlots(1) = plot(distance,varsMed,'pb', 'MarkerSize', 15, 'MarkerFaceColor', 'black');
% varPlots(2) = plot(distance,AVarsMed,'pm', 'MarkerSize', 15, 'MarkerFaceColor', 'magenta');
% varPlots(3) = plot(distance,BVarsMed,'pc', 'MarkerSize', 15, 'MarkerFaceColor', 'cyan');
% varPlots(4) = plot(distance,CVarsMed,'pg', 'MarkerSize', 15, 'MarkerFaceColor', 'green');
varPlots(2) = plot(NaN,NaN,'o');
% varPlots(6) = plot(NaN,NaN,'x');
% varPlots(7) = plot(NaN,NaN,'p');
% varPlots(8) = plot(NaN,NaN,'s');
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10));
%lgd = legend(varPlots, popMed, medianA, medianB, medianC,'Ribbon Variance','Sensor #171 Ribbon Variance','Sensor #173 Ribbon Variance','Sensor #181 Ribbon Variance');
lgd = legend(varPlots, popMed, 'Ribbon Variance');

% figure(f4);
% coeffvarplot = plot(distance,coeffVarMed,'pb', 'MarkerSize', 15, 'MarkerFaceColor', 'black');
% xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10));
% legend(medianA,medianB,medianC,coeffvarplot,'Population Median');

figure(f5);
countPlots(1) = plot(distance,countsMed,'pb', 'MarkerSize', 15, 'MarkerFaceColor', 'black');
% countPlots(2) = plot(distance,ACountsMed,'pm', 'MarkerSize', 15, 'MarkerFaceColor', 'magenta');
% countPlots(3) = plot(distance,BCountsMed,'pc', 'MarkerSize', 15, 'MarkerFaceColor', 'cyan');
% countPlots(4) = plot(distance,CCountsMed,'pg', 'MarkerSize', 15, 'MarkerFaceColor', 'green');
countPlots(2) = plot(NaN,NaN,'o');
% countPlots(6) = plot(NaN,NaN,'x');
% countPlots(7) = plot(NaN,NaN,'p');
% countPlots(8) = plot(NaN,NaN,'s');
xline(totalTH002(1,1)); xline(totalTH002(1,2)); xline(totalTH002(1,3)); xline(totalTH002(1,4)); xline(totalTH002(1,5)); xline(totalTH002(1,6)); xline(totalTH002(1,7)); xline(totalTH002(1,8)); xline(totalTH002(1,9)); xline(totalTH002(1,10)); xline(totalTH002(1,11));
%lgd = legend(countPlots, popMed, medianA, medianB, medianC,'Ribbon Count','Sensor #171 Ribbon Count','Sensor #173 Ribbon Count','Sensor #181 Ribbon Count');
lgd = legend(countPlots, popMed, 'Ribbon Count');