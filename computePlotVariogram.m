%============================================================================== 
% function computePlotVariogram(A, B, C, hmax, nh)
%
%   Comput and plot semi-variogram for dataset containing sensor A, B, and 
%   C already extracted from a MNDOT data sheet.
%   
%  Arguments:
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
% - hmax : scalar
%       Maximum separation distance in meters.
%
% - nh : scalar
%       Number of subdivisions in variogram plot.
%
%
%
%   Version:
%       5 October 2020
%==============================================================================
function computePlotVariogram(A, B, C, hmax, nh)

 % Compute and report spatial statistics (e.g. the semi-variogram).
    
    [hA, gA] = variogram2D(A(:,1:2), A(:,3), hmax, nh);
    
    [hB, gB] = variogram2D(B(:,1:2), B(:,3), hmax, nh);
    
    [hC, gC] = variogram2D(C(:,1:2), C(:,3), hmax, nh);
    
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
    xlabel('separation distance [ft]');
    ylabel('\gamma(h) [.]');
    title('Longitudinal Composite Variogram');
    
    legend('A', 'B', 'C', 'Var A', 'Var B', 'Var C', 'Location', 'NorthWest');

end