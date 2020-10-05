%==============================================================================
% function inspectSwerveDielectric(A, B, C, D)
%
%   Carry out a cursory inspection of the data returned by extractDielectric
%   for swerve path data sets.
%
% Arguments:
% - A : (n x 3) matrix
%       The three columns are [UTM eastings, UTM northings, dielectric]
%       for first sensor.
%
% - B : (n x 3) matrix
%       The three columns are [UTM eastings, UTM northings, dielectric]
%       for second sensor.
%
% - C : (n x 3) matrix
%       The three columns are [UTM eastings, UTM northings, dielectric]
%       for third sensor.
%
% - A : (n x 1) matrix
%       The are the "distances" record by the cart based on a wheel rotation.
%
% Returns:
%   None
%
% Notes:
% - This is a work in progress.
%
% - The "dielectirc" is shorthand for the dielectric constant, which is also
%   known as the "relative permittivity".  The dielectric is dimensionless.
%
% Version:
%   18 September 2020
%==============================================================================

function inspectSwerveDielectric(A, B, C, D)
    tic;
    
    % ----------
    % Do an internal consistency check on distances moved. The are four
    % separate, but not independent, sources for locations: the GPS-based
    % lat/lon converted to UTM for each of the three sensors (A, B, C),
    % and the reported distance moved from the cart (D).
    
    % Compute the reported distances moved between each measurement for each
    % of the four location sources.
    deltaA = hypot(A(2:end, 1)-A(1:end-1, 1), A(2:end, 2)-A(1:end-1, 2));
    deltaB = hypot(B(2:end, 1)-B(1:end-1, 1), B(2:end, 2)-B(1:end-1, 2));
    deltaC = hypot(C(2:end, 1)-C(1:end-1, 1), C(2:end, 2)-C(1:end-1, 2));
    deltaD = 0.3048 * abs(D(2:end)-D(1:end-1));     % convert [ft] to [m]
    
    % Compute the differences between the reported distances moved for
    % the four location sources.
    diffAB = abs(deltaA - deltaB);
    diffAC = abs(deltaA - deltaC);
    diffAD = abs(deltaA - deltaD);
    diffBC = abs(deltaB - deltaC);
    diffBD = abs(deltaB - deltaD);
    diffCD = abs(deltaC - deltaD);
    
    % Compute the maximum difference for the reported distances moved
    % between the four location sources.
    maxDiff(1,2) = max(diffAB);
    maxDiff(1,3) = max(diffAC);
    maxDiff(1,4) = max(diffAD);
    
    maxDiff(2,1) = maxDiff(1,2);
    maxDiff(2,3) = max(diffBC);
    maxDiff(2,4) = max(diffBD);
    
    maxDiff(3,2) = maxDiff(2,3);
    maxDiff(3,1) = maxDiff(1,3);
    maxDiff(3,4) = max(diffCD);
    
    maxDiff(4,1) = maxDiff(1,4);
    maxDiff(4,2) = maxDiff(2,4);
    maxDiff(4,3) = maxDiff(3,4);
    
    fprintf('\n')
    fprintf('Approximate total distance moved = %10.2f [m]', sum(deltaA));
    fprintf('\n')
    
    fprintf('\n');
    fprintf('Maximum Difference in the Distance Moved [m] \n');
    fprintf('---------------------------------------- \n');
    fprintf('         A         B         C         D \n');
    fprintf('---------------------------------------- \n')
    fprintf('A %8.4f  %8.4f  %8.4f  %8.4f \n', maxDiff(1,1), maxDiff(1,2), maxDiff(1,3), maxDiff(1,4));
    fprintf('B %8.4f  %8.4f  %8.4f  %8.4f \n', maxDiff(2,1), maxDiff(2,2), maxDiff(2,3), maxDiff(2,4));
    fprintf('C %8.4f  %8.4f  %8.4f  %8.4f \n', maxDiff(3,1), maxDiff(3,2), maxDiff(3,3), maxDiff(3,4));
    fprintf('D %8.4f  %8.4f  %8.4f  %8.4f \n', maxDiff(4,1), maxDiff(4,2), maxDiff(4,3), maxDiff(4,4));
    fprintf('---------------------------------------- \n')
    fprintf('\n')
    
    figure(1)
    n = length(deltaA);
    plot(1:n, [deltaA, deltaB, deltaC, deltaD], '.');
    xlabel('index [#]');
    ylabel('distance moved [m]');
    title('Distance Moved');
    legend('A', 'B', 'C', 'D');
    
    figure(2)
    plot(1:n, [diffAB, diffAC, diffBC], '.');
    xlabel('index [#]');
    ylabel('distance differences [m]');
    title('Distance Differences Comparing Sensor GPS');
    legend('AB', 'AC', 'BC');
    
    figure(3)
    plot(1:n, [diffAD, diffBD, diffCD], '.');
    xlabel('index [#]');
    ylabel('distance differences [m]');
    title('Distance Differences Comparing GPS-based to Wheel');
    legend('AD', 'BD', 'CD');
    
    % ----------
    % Compute and report summary statistics.
    S = computeSummaryStatistics([A(:,3), B(:,3), C(:,3)]);
    
    fprintf('\n');
    fprintf('--------------------------------------------- \n');
    fprintf('             Sensor A    Sensor B    Sensor C \n');
    fprintf('--------------------------------------------- \n');
    fprintf('Count      %10d  %10d  %10d \n', S(1,1), S(1,2), S(1,3));
    fprintf('\n');
    fprintf('Minimum    %10.3f  %10.3f  %10.3f \n', S(2,1), S(2,2), S(2,3));
    fprintf('25 Prctile %10.3f  %10.3f  %10.3f \n', S(3,1), S(3,2), S(3,3));
    fprintf('Median     %10.3f  %10.3f  %10.3f \n', S(4,1), S(4,2), S(4,3));
    fprintf('75 Prctile %10.3f  %10.3f  %10.3f \n', S(5,1), S(5,2), S(5,3));
    fprintf('Maximum    %10.3f  %10.3f  %10.3f \n', S(6,1), S(6,2), S(6,3));
    fprintf('\n');
    fprintf('Mean       %10.4f  %10.4f  %10.4f \n', S(7,1), S(7,2), S(7,3));
    fprintf('Std Dev    %10.4f  %10.4f  %10.4f \n', S(8,1), S(8,2), S(8,3));
    fprintf('Variance   %10.4f  %10.4f  %10.4f \n', S(9,1), S(9,2), S(9,3));
    fprintf('\n');
    fprintf('CofVar     %10.4f  %10.4f  %10.4f \n', S(10,1), S(10,2), S(10,3));
    fprintf('StdErr Avg %10.4f  %10.4f  %10.4f \n', S(11,1), S(11,2), S(11,3));
    fprintf('StdErr Std %10.4f  %10.4f  %10.4f \n', S(12,1), S(12,2), S(12,3));    
    fprintf('--------------------------------------------- \n');
    fprintf('\n');
    
    figure(4)
    
    subplot(2, 2, 1)
    histogram(A(:,3), [4:0.05:6]);
    xlabel('dielectric [.]');
    ylabel('count')
    title('Sensor A');
    
    subplot(2, 2, 2)
    histogram(B(:,3), [4:0.05:6]);
    xlabel('dielectric [.]');
    ylabel('count')
    title('Sensor B');
    
    subplot(2, 2, 3)
    histogram(C(:,3), [4:0.05:6]);
    xlabel('dielectric [.]');
    ylabel('count')
    title('Sensor C');
    
    subplot(2, 2, 4)
    [fA, xA] = ecdf(A(:,3));
    [fB, xB] = ecdf(B(:,3));
    [fC, xC] = ecdf(C(:,3));
    
    stairs(xA, fA, '-r');
    hold on
    stairs(xB, fB, '-g');
    stairs(xC, fC, '-b');
    hold off
    xlim([4, 6]);
    xlabel('dielectric [.]');
    ylabel('proportion less than');
    title('Empirical CDF');
    legend('A', 'B', 'C', 'Location', 'best');
    
    figure(5)
    
    subplot(2,2,1)
    normplot(A(:,3));
    xlabel('dielectric [.]');
    ylabel('proportion less than');
    title('Sensor A Normal Probability Plot');
    
    subplot(2,2,2)
    normplot(B(:,3));
    xlabel('dielectric [.]');
    ylabel('proportion less than');
    title('Sensor B Normal Probability Plot');
    
    subplot(2,2,3)
    normplot(A(:,3));
    xlabel('dielectric [.]');
    ylabel('proportion less than');
    title('Sensor C Normal Probability Plot');
    
    % ----------
    % Compute and report spatial statistics (e.g. the semi-variogram).
    hmax = 10;
    nh = 50;
    
    [hA, gA] = variogram2D(A(:,1:2), A(:,3), hmax, nh);
    
    [hB, gB] = variogram2D(B(:,1:2), B(:,3), hmax, nh);
    
    [hC, gC] = variogram2D(C(:,1:2), C(:,3), hmax, nh);
    
    figure(6);
    plot(hA, gA, 'o', 'MarkerFaceColor','r', 'MarkerEdgecolor','k');
    hold on
    plot(hB, gB, 'o', 'MarkerFaceColor','g', 'MarkerEdgecolor','k');
    plot(hC, gC, 'o', 'MarkerFaceColor','b', 'MarkerEdgecolor','k');
    
    varA = var(A(:,3));
    varB = var(B(:,3));
    varC = var(C(:,3));
    
    plot([min(hA), max(hA)], [varA, varA], '-r');
    plot([min(hB), max(hB)], [varB, varB], '-g');
    plot([min(hC), max(hC)], [varC, varC], '-b');
    hold off
    
    V = axis;
    ylim([0,V(4)]);
    xlabel('separation distance [m]');
    ylabel('\gamma(h) [.]');
    title('Dielectric Semi-Variogram');
    
    legend('A', 'B', 'C', 'Var A', 'Var B', 'Var C', 'Location', 'SouthEast');
    
    % ----------
    % Plot the values.
    figure(7)
    n = size(A,1);
    
    plot(1:n, A(:,3), '.r')
    hold on
    plot(1:n, B(:,3), '.g')
    plot(1:n, C(:,3), '.b')
    hold off
    
    xlabel('index [#]');
    ylabel('dielectric [.]');
    title('Measured Dielectric');
    legend('A', 'B', 'C');
    
    fprintf('\n')
    toc
end