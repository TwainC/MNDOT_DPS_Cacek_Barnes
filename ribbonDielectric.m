%------------------------------------------------------------------------------
% [rectangleLength, rectangleWidth, rectangleTheta, corners] = fitRectangle(x, y)
%
%   Finds the rectangle with the smallest minimum dimension that contains all
%   of the points (x,y). This rectangle is not necessarily axis-aligned.
%
% Arguments:
%   x : (1 x n) row vector
%       The x-coordinates of the points.
%
%   y : (1 x n) row vector
%       The y-coordinates of the points.
%
% Returns:
%   rectangleLength : double
%       The maximum dimension of the bounding rectangle.
%
%   rectangleWidth : double
%       The minimum dimension of the bounding rectangle.
%
%   rectangleTheta : double
%       The rotation angle [rad] to make the bounding rectangle axis-aligned
%       with the longest dimension parallel to the horizontal axis.
%
%   corners : (2x4) array
%       The four corner points of the optimal rectangle. The first row are the
%       x-coordinates of the corners, the second row are the y-coordinates of
%       the corners. The corners are ordered so as to traverse the bounding 
%       rectangle counterclockwise.
%
% Author:
%   Twain Cacek
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   14 October 2020
%------------------------------------------------------------------------------

function ribbonDielectric(csvPath,d,n)
    

    
    %Extract UTM from input data, form row vector, and find the bounding
    %rectangle
    [A,B,C,D] = extractFilteredDielectric(csvPath);
    totUTM = [A;B;C]';
    UTM = totUTM(1:2,:);
    easting = UTM(1,:);
    northing = UTM(2,:);
    [rectangleLength, rectangleWidth, theta, corners] = fitRectangle(easting, northing);
    
    %Plot UTM data and the bounding rectangle
    x = [A(:,1);B(:,1);C(:,1)]';
    y = [A(:,2);B(:,2);C(:,2)]';

    fill(corners(1,:), corners(2,:), [0.9, 0.9, 0.9]);
    hold on;
    plot(x, y, '.b');
    title(sprintf('Length = %.2f | Width = %.2f | Theta = %.1f [deg]', ...
        rectangleLength, rectangleWidth, rad2deg(theta)));
    
    for j = 1:4
        text(corners(1,j), corners(2,j), sprintf('%d', j), 'FontSize', 18);
    end
    axis equal;
    
    %Create rotation matrix and inverse rotation matrix
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    Rinv = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    
    %Create UTM array rotated to become axis aligned
    utmR = R*UTM;
    northingR = utmR(2,:);
    
    %Find midpoint of the northing values to bring them to the easting-axis
    midpointY = (max(utmR(2,:)) + min((utmR(2,:))))/2;
    northingR = northingR - midpointY;
    
    %Convert the rectangle corners to our rotated coordinate system
    cornersR = R*corners;
    cornersR(2,:) = cornersR(2,:) - midpointY;
    
    %Check for ribbon distance/quantity parameter - d chosen over n when
    %both given
    if isempty(d)
        ribbons = linspace(max(cornersR(2,:)),min(cornersR(2,:)),n);
    else
        ribbons = (max(cornersR(2,:)):-d:min(cornersR(2,:)));
        if ribbons(end) ~= min(cornersR(2,:))
            ribbons(end + 1) = min(cornersR(2,:));
        end
    end
    
    %Initialize the ribbon marker row
    totUTM(4,:) = 0;
    
    for i=1:length(ribbons)-1
        %Create boolean array for data points within ribbon bounds
        I = northingR >= ribbons(i+1) & northingR <= ribbons(i);
        
        %Label each point with corresponding ribbon and store ribbon data
        totUTM(4,:) = totUTM(4,:) + I*i;
        ribbonData = totUTM(:,(I==1))';
        
        %Compute summary statistics
        varRib(i) = var(ribbonData(:,3));
        meanRib(i) = mean(ribbonData(:,3));
        nPoints(i) = length(ribbonData);
        
        %Create array for plotting the ribbon boundaries
        ribbonLine = [min(utmR(1,:)) max(utmR(1,:)); ribbons(i) ribbons(i)];
        ribbonLine(2,:) = ribbonLine(2,:) + midpointY;
        ribbonLine = Rinv * ribbonLine;
        plot(ribbonLine(1,:),ribbonLine(2,:),'-r');
        
        clear ribbonData; clear h; clear g; clear N; clear ribbonLine;
    end
    hold off
end

    
