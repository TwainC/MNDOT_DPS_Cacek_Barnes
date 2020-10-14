%------------------------------------------------------------------------------
% [H, G, N] = computeVariogram1D(X, Z, hmax, nh)
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
%   H       (nh x 1) matrix of average separation distances.
%   G       (nh x 1) matrix of average semi-variogram values.
%   N       (nh x 1) matrix of the number of pairs.
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   14 October 2020
%------------------------------------------------------------------------------
function [H, G, N] = computeVariogram1D(X, Z, hmax, nh)
    % Validate.
    assert( isvector(X), 'X must be a vector');
    assert( isvector(Z), 'Z must be a vector');
    assert( length(X) == length(Z), 'X and Z must be the same length');
    assert( isscalar(hmax) & hmax>0, 'hmax must be a positive scalar');
    assert( isscalar(nh) & rem(nh,1)==0 & nh>0, 'nh must be a positive integer scalar');
    
    % Initialize.
    N = zeros(nh, 1);
    H = zeros(nh, 1);
    G = zeros(nh, 1);
    
    deltah = hmax/nh;
    
    % We sort the data by x-coordinate so we can terminte the inner
    % pair-comparison loop (i.e. the j-loop below) as early as possible.
    [X, I] = sort(X);
    Z = Z(I);
    
    % Run through the pairs.
    for i = 1:length(X)-1
        for j = i+1:length(X)
            h = X(j)-X(i);
            if h > hmax
                break;
            end
            
            k = max(1, ceil(h/deltah));
            if k <= nh
                H(k) = H(k) + h;
                G(k) = G(k) + 0.5*(Z(j)-Z(i))^2;
                N(k) = N(k) + 1;
            end
        end
    end
    
    % Compute the bin averages.
    for k = 1:nh
        if N(k) > 0
            H(k) = H(k)/N(k);
            G(k) = G(k)/N(k);
        else
            H(k) = NaN;
            G(k) = NaN;
        end
    end
end