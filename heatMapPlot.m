%==============================================================================
% function heatMapPlot (A, B, C)
% 
%     Plot geographically refferenced dielectric points. Points colored 
%     according to dilectric value.
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
% Author:
%   Twain Cacek
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
% 
% Version: 
%   23 September 2020
%==============================================================================


function heatMapPlot (A, B, C)

% Assign easting/northing arrays to individual variables
eastingA = A(:,1);
northingA = A(:,2);
eastingB = B(:,1);
northingB = B(:,2);
eastingC = C(:,1);
northingC = C(:,2);

hold on;

pointsize = 10;

n = size(A,1);

[s,I] = sort(A(:,3));
baseMap = turbo(n);
scatter(A(I,1), A(I,2), pointsize, baseMap, 'filled');

newMap = interp1(unique(s), baseMap, linspace(s(1), s(n), n));
colormap(newMap)
caxis([s(1), s(n)]);
colorbar;


% 
% scatter(eastingB, northingB, pointsize, B(:,3));
% scatter(eastingC, northingC, pointsize, C(:,3));
% text(eastingA(1), northingA(1), 'A');
% text(eastingB(1), northingB(1), 'B');
% text(eastingC(1), northingC(1), 'C');
% grid('on');
% hold off;
end
