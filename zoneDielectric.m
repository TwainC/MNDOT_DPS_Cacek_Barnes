%------------------------------------------------------------------------------
% [varRib, meanRib, nPoints] = zoneDielectric(csvPath,wJ,wT,wM)
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
%       -The sample variance, mean, and number of data points corresponding 
%       to each ribbon segment.   
%
%   serials : (3 x 1) vector
%       -Vector of serial numbers for sensor A,B,C
%
% Author:
%   Twain Cacek
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   15 November 2020
%------------------------------------------------------------------------------

function [totUTM, serials] = zoneDielectric(csvPath,wJ,wT,wM)
    
    %Extract UTM from input data, form row vector, and find the bounding
    %rectangle
    [A,B,C,D,offsets,serials] = extractFilteredDielectric(csvPath);
    serials = str2double(serials);
    A(:,4) = serials(1);
    B(:,4) = serials(2);
    C(:,4) = serials(3);
    
    totUTM = [A;B;C]';
    UTM = totUTM(1:2,:);
    easting = UTM(1,:);
    northing = UTM(2,:);
    [rectangleLength, rectangleWidth, theta, corners] = fitRectangle(easting, northing);
    

    
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
    wJ = wJ/3.28;
    wT = wT/3.28;
    wM = wM/3.28;
    center = -wJ-wT-wM/2;
    jtC = -wT-wM/2;
    tmC = -wM/2;
    tmS = wM/2;
    jtS = wM/2+wT;
    shoulder = wM/2+wT+wJ;
    
    ribbons = [center,jtC,tmC,tmS,jtS,shoulder];
    
    %Initialize the ribbon marker row
    totUTM(5,:) = 0;
    
    for i=1:length(ribbons)-1
        %Create boolean array for data points within ribbon bounds
            I = V <= ribbons(i+1) & V >= ribbons(i);

        %Label each point with corresponding ribbon and store ribbon data
        totUTM(5,:) = totUTM(5,:) + I*i;
    end
end