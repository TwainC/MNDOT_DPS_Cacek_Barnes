%------------------------------------------------------------------------------
% [varRib, meanRib, nPoints] = ribbonDielectric(csvPath,d,n)
% 
%   Finds the smallest bounding rectangle for the input data set, then 
%   breaks the set into segments (ribbons) according to input parameters. 
%   Bounding rectangle, ribbons, centerline refference, and data set 
%   plotted together. Mean, Variance, and number of points for each segment 
%   are returned as arrays.
%
% Arguments:
%   csvPath : character array or string
%       The path for the data file that will be examined.
%
%   d : scalar
%       The width of each ribbon segment in [ft].
%
%   n : scalar
%       Number of ribbon segments.
%
%   Note:
%       -If both d and n are inputted, function will use d automatically.
%
% Returns:
%   meanVarRib : (3 x n) matrix
%       The sample variance, mean, and number of data points corresponding 
%       to each ribbon segment.      
%
% Author:
%   Twain Cacek
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   26 October 2020
%------------------------------------------------------------------------------

function meanVarRib = ribbonDielectric(csvPath,d,n)
    

    
    %Extract UTM from input data, form row vector, and find the bounding
    %rectangle
    [A,B,C,D,offsets] = extractFilteredDielectric(csvPath);
    
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
    V = utmR(2,:);
    U = utmR(1,:);
    
    %Find midpoint of the northing values to bring them to the U-axis
    midpointV = (max(utmR(2,:)) + min((utmR(2,:))))/2;
    midpointU = (max(utmR(1,:)) + min((utmR(1,:))))/2;
    V = V - midpointV;
    U = U - midpointU;
    
    %Checks that the rectangle has length axis along U-axis
    if (max(V) - min(V)) > 10
        theta = theta - pi/2;
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        Rinv = [cos(theta), sin(theta); -sin(theta), cos(theta)];
        utmR = R*UTM;
        V = utmR(2,:);
        U = utmR(1,:);
        midpointV = (max(utmR(2,:)) + min((utmR(2,:))))/2;
        midpointU = (max(utmR(1,:)) + min((utmR(1,:))))/2;
        V = V - midpointV;
        U = U - midpointU;
    end
    
    %Checks that the dataset begins in -U and ends in +U
    if U(1) > U(end)
        theta = theta - pi;
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        Rinv = [cos(theta), sin(theta); -sin(theta), cos(theta)];
        utmR = R*UTM;
        V = utmR(2,:);
        U = utmR(1,:);
        midpointV = (max(utmR(2,:)) + min((utmR(2,:))))/2;
        midpointU = (max(utmR(1,:)) + min((utmR(1,:))))/2;
        V = V - midpointV;
        U = U - midpointU;
    end
    
    %Convert the rectangle corners to our rotated coordinate system
    cornersR = R*corners;
    cornersR(2,:) = cornersR(2,:) - midpointV;
    
    %Check for ribbon distance/quantity parameter - d chosen over n when
    %both given
    if isempty(d)
        ribbons = linspace(max(cornersR(2,:)),min(cornersR(2,:)),n+1);
    else
        d = d/3.28;
        ribbons = (max(cornersR(2,:)):-d:min(cornersR(2,:)));
        if ribbons(end) ~= min(cornersR(2,:))
            ribbons(end + 1) = min(cornersR(2,:));
        end
    end
    
    %Find offset distance from centerline and convert to double
    offsetA = strsplit(offsets(1),{'R','L'});
    offsetC = strsplit(offsets(3),{'R','L'});
    offsetDA = str2double(offsetA(1));
    offsetDC = str2double(offsetC(1));
    
    %Boolean to find which offset is greater (i.e. further from centerline)
    AoverC = offsetDA > offsetDC;
    
    %Rereates the ribbons vector to staisfy the condition that the
    %centerline is closer to the sensor with the smaller offset.
    if AoverC | ~isempty(d)
        if abs(ribbons(end)-V(1)) > abs(ribbons(end)-V(2*length(A)+1))
            ribbons = (min(cornersR(2,:)):d:max(cornersR(2,:)));
            ribbons = flip(ribbons);
        end
    else
        if abs(ribbons(end)-V(1)) < abs(ribbons(end)-V(2*length(A)+1))
            ribbons = (min(cornersR(2,:)):d:max(cornersR(2,:)));
            ribbons = flip(ribbons);
        end
    end
    
    %Initialize the ribbon marker row
    totUTM(4,:) = 0;
    
    for i=1:length(ribbons)-1
        %Create boolean array for data points within ribbon bounds
        I = V >= ribbons(i+1) & V <= ribbons(i);
        
        %Label each point with corresponding ribbon and store ribbon data
        totUTM(4,:) = totUTM(4,:) + I*i;
        ribbonData = totUTM(:,(I==1))';
        
        %Compute summary statistics
        varRib(i) = var(ribbonData(:,3));
        meanRib(i) = mean(ribbonData(:,3));
        nPoints(i) = length(ribbonData);
        
        
        %Create array for plotting the ribbon boundaries
        ribbonLine = [min(utmR(1,:)) max(utmR(1,:)); ribbons(i) ribbons(i)];
        ribbonLine(2,:) = ribbonLine(2,:) + midpointV;
        ribbonLine = Rinv * ribbonLine;
        plot(ribbonLine(1,:),ribbonLine(2,:),'-r');
        
        clear ribbonData; clear h; clear g; clear N; clear ribbonLine;
    end
    
    %Plot the final ribbon divider
    ribbonLine = [min(utmR(1,:)) max(utmR(1,:)); ribbons(end) ribbons(end)];
    ribbonLine(2,:) = ribbonLine(2,:) + midpointV;
    ribbonLine = Rinv * ribbonLine;
    plot(ribbonLine(1,:),ribbonLine(2,:),'-r');
    
    %Plot the centerline
    ribbonLine = [min(utmR(1,:)) max(utmR(1,:)); ribbons(1) ribbons(1)];
    ribbonLine(2,:) = ribbonLine(2,:) + midpointV;
    ribbonLine = Rinv * ribbonLine;
    plot(ribbonLine(1,:),ribbonLine(2,:),'-g');
    
%Change ribbon distances in refference to the centerline and construct
%outpu matrix
ribbons = abs(ribbons(1,:)-ribbons(1));
meanVarRib = [ribbons*3.28; 0,meanRib; 0,varRib; 0,nPoints];
    hold off
end

    
