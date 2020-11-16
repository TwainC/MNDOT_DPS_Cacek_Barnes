%------------------------------------------------------------------------------
% [varRib, meanRib, nPoints] = ribbonDielectricHist(csvPath,d,n,plotOption)
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
%   plotOption : int
%       Option for plotting output. 
%       -Enter 0 for no plots (will only return computations)
%       -Enter 1 for scatterplot with ribbon lines and bounding rectangle
%       -Enter 2 for heat map with ribbon lines and bounding rectangle
%
%   serialOption : int
%       Option for what data will be returned
%       -Enter 0 for summary statistics of each ribbon
%       -Enter 1 for summary statistics of each ribbon and each sensor
%       measuring within the ribbons.
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
%   11 November 2020
%------------------------------------------------------------------------------

function ribReturn = ribbonDielectricHist(csvPath,d,n,plotOption,serialOption,ribbonNum)
    
    assert(plotOption >= 0 & plotOption <=2, "plotOption must be 0, 1, or 2");
    
    %Extract UTM from input data, form row vector, and find the bounding
    %rectangle
    [A,B,C,D,offsets,serials] = extractFilteredDielectric2(csvPath);
    serials = str2double(serials);
    A(:,4) = serials(1);
    B(:,4) = serials(2);
    C(:,4) = serials(3);
    
    totUTM = [A;B;C]';
    UTM = totUTM(1:2,:);
    easting = UTM(1,:);
    northing = UTM(2,:);
    [rectangleLength, rectangleWidth, theta, corners] = fitRectangle(easting, northing);
    
    %Plot UTM data and the bounding rectangle
    
    if plotOption == 0
    elseif plotOption == 1
        x = [A(:,1);B(:,1);C(:,1)]';
        y = [A(:,2);B(:,2);C(:,2)]';
        
        fill(corners(1,:), corners(2,:), [0.9, 0.9, 0.9]);
        hold on;
        title(sprintf('Length = %.2f [ft]| Width = %.2f [ft] | Theta = %.1f [deg]', ...
            rectangleLength*3.28, rectangleWidth*3.28, rad2deg(theta)));
        
        for j = 1:4
            text(corners(1,j), corners(2,j), sprintf('%d', j), 'FontSize', 18);
        end
        axis equal;
        plot(x, y, '.b');
        
    elseif plotOption == 2
        fill(corners(1,:), corners(2,:), [0.9, 0.9, 0.9]);
        plotHeatMap(csvPath);
        hold on;

        title(sprintf('Length = %.2f [ft]| Width = %.2f [ft] | Theta = %.1f [deg]', ...
            rectangleLength*3.28, rectangleWidth*3.28, rad2deg(theta)));
        
        for j = 1:4
            text(corners(1,j), corners(2,j), sprintf('%d', j), 'FontSize', 18);
        end
        axis equal;
        
        
    end
    

    
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
    if (max(V) - min(V)) > 20
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
    
    %Sets the first element of the ribbons vector as the centerline
    if AoverC 
        if mean(V(1:length(A))) < mean(V(2*length(A)+1:end))
            ribbons = [(max(cornersR(2,:)):-d:min(cornersR(2,:))),min(cornersR(2,:))];
        else
            ribbons = [(min(cornersR(2,:)):d:max(cornersR(2,:))),max(cornersR(2,:))];
        end
    else
        if mean(V(1:length(A))) < mean(V(2*length(A)+1:end))
            ribbons = [(min(cornersR(2,:)):d:max(cornersR(2,:))),max(cornersR(2,:))];
        else
            ribbons = [(max(cornersR(2,:)):-d:min(cornersR(2,:))),min(cornersR(2,:))];
        end
    end
            
    %Initialize the ribbon marker row
    totUTM(5,:) = 0;
    
    for i=1:length(ribbons)-1
        %Create boolean array for data points within ribbon bounds
        if ribbons(1) > ribbons(end)
            I = V >= ribbons(i+1) & V <= ribbons(i);
        else
            I = V <= ribbons(i+1) & V >= ribbons(i);
        end
        %Label each point with corresponding ribbon and store ribbon data
        totUTM(5,:) = totUTM(5,:) + I*i;
        ribbonData = totUTM(:,(I==1))';
        
        %Compute summary statistics
        varRib(i) = var(ribbonData(:,3));
        meanRib(i) = mean(ribbonData(:,3));
        nPoints(i) = length(ribbonData);
        
        if serialOption == 1
            ribbonDataA = ribbonData((ribbonData(:,4) == serials(1)),:);
            ribbonDataB = ribbonData((ribbonData(:,4) == serials(2)),:);
            ribbonDataC = ribbonData((ribbonData(:,4) == serials(3)),:);
            
            varA(i) = var(ribbonDataA(:,3));
            meanA(i) = mean(ribbonDataA(:,3));
            nA(i) = length(ribbonDataA);
            
            varB(i) = var(ribbonDataB(:,3));
            meanB(i) = mean(ribbonDataB(:,3));
            nB(i) = length(ribbonDataB);
            
            varC(i) = var(ribbonDataC(:,3));
            meanC(i) = mean(ribbonDataC(:,3));
            nC(i) = length(ribbonDataC);
        end
        
        if i == ribbonNum
            ribReturn = ribbonData;
        end
        
        if plotOption ~= 0
            %Create array for plotting the ribbon boundaries
            ribbonLine = [min(utmR(1,:)) max(utmR(1,:)); ribbons(i) ribbons(i)];
            ribbonLine(2,:) = ribbonLine(2,:) + midpointV;
            ribbonLine = Rinv * ribbonLine;
            plot(ribbonLine(1,:),ribbonLine(2,:),'-r');
        end
        clear ribbonData; clear h; clear g; clear N; clear ribbonLine;
    end
    
    if plotOption ~= 0
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
        
        hold off;
    end
    
%Change ribbon distances in refference to the centerline and construct
%outpu matrix
ribbons = abs(ribbons(1,:)-ribbons(1));

%Return sensor statistics if specified
if serialOption == 1
    meanVarRib = [ribbons*3.28; 0,meanRib; 0,varRib; 0,nPoints;...
        0,meanA;0,varA;0,nA; ...
        0,meanB;0,varB;0,nB; ...
        0,meanC;0,varC;0,nC];
else
    meanVarRib = [ribbons*3.28; 0,meanRib; 0,varRib; 0,nPoints];
end
end

    
