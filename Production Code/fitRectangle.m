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
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   14 October 2020
%------------------------------------------------------------------------------
function [rectangleLength, rectangleWidth, theta, corners] = fitRectangle(x, y)
    assert(isrow(x) & isrow(y) & length(x) == length(y), ...
        'x and y must be row vectors of the same length.');
    
    % Shift the data to put the midpoint at the origin. This is not required 
    % by the math, but UTM coordinates can be quite large and risk a loss of
    % precision during rotations.
    midpoint = [(max(x)+min(x))/2; (max(y)+min(y))/2];
    XY = [x; y] - midpoint;
    
    % Find the optimal rotation.
    options = optimset('display', 'off');
    [theta] = fminsearch(@(theta) objective(XY, theta), 0, options);
    
    % Return the four corners of the fitted rectangle.
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    Rinv = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    
    UV = R*XY;
    Umin = min(UV(1,:));
    Umax = max(UV(1,:));
    Vmin = min(UV(2,:));
    Vmax = max(UV(2,:));
    
    if Umax-Umin > Vmax-Vmin
        rectangleLength = Umax-Umin;
        rectangleWidth = Vmax-Vmin;
    else
        rectangleLength = Vmax-Vmin;
        rectangleWidth = Umax-Umin;
        theta = theta - pi/2;
    end
    
    corners = Rinv*[Umin, Umax, Umax, Umin; Vmin, Vmin, Vmax, Vmax] + midpoint;
end

% Rather than rotate the rectangle, we rotate the points. This way, for any
% given rotation, the bounding rectangle is axis-aligned and the width and
% height can be computed using the range --- i.e. no optimization required.
function [width] = objective(XY, theta)
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    width = min(range(R*XY, 2));
end