%------------------------------------------------------------------------------
% [h, g, n] = computeVariogram1D(X, Z, hmax, nh)
%
%   Compute the semi-variogram for one-dimensional data.
%
% Arguments
%   X       vector of spatial locations.
%   Z       vector of field values. X and Z must be the same length.
%   hmax    (scalar) maximum separation distance on the variogram plot.
%   nh      (scalar) number of subdivisions in the variogram plot.
%
% Returns
%   h       (nh x 1) matrix of average separation distances.
%   g       (nh x 1) matrix of average semi-variogram values.
%   n       (nh x 1) matrix of the number of pairs.
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   19 October 2020
%------------------------------------------------------------------------------
function [h, g, n] = computeVariogram1D(X, Z, hmax, nh)
    % Validate.
    assert( isvector(X), 'X must be a vector');
    assert( isvector(Z), 'Z must be a vector');
    assert( length(X) == length(Z), 'X and Z must be the same length');
    assert( isscalar(hmax) & hmax>0, 'hmax must be a positive scalar');
    assert( isscalar(nh) & rem(nh,1)==0 & nh>0, 'nh must be a positive integer scalar');
    
    % Initialize.
    n = zeros(nh, 1);
    h = zeros(nh, 1);
    g = zeros(nh, 1);
    
    width = hmax/nh;
    
    % We sort the data by x-coordinate so we can terminte the inner
    % pair-comparison loop (i.e. the j-loop below) as early as possible.
    [X, I] = sort(X);
    Z = Z(I);
    
    % Run through the pairs.
    for i = 1:length(X)-1
        for j = i+1:length(X)
            deltax = X(j)-X(i);
            if deltax > hmax
                break;
            end
            
            k = max(1, ceil(deltax/width));
            if k <= nh
                h(k) = h(k) + deltax;
                g(k) = g(k) + 0.5*(Z(j)-Z(i))^2;
                n(k) = n(k) + 1;
            end
        end
    end
    
    % Compute the bin averages.
    for k = 1:nh
        if n(k) > 0
            h(k) = h(k)/n(k);
            g(k) = g(k)/n(k);
        else
            h(k) = NaN;
            g(k) = NaN;
        end
    end
end