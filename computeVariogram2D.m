%------------------------------------------------------------------------------
% [H, G, N] = computeVariogram2D( X, Z )
%
%   Compute the omni-directional semi-variogram for two-dimensional data.
%
% Arguments
%   X       (n x 2) matrix of spatial locations in the form (x,y).
%   Z       vector of field values. X and Z must be the same length.
%   hmax    (scalar) maximum separation distance on the variogram plot.
%   nh      (scalar) number of subdivisions in the variogram plot.
%
% Returns
%   H   (nh x 1) matrix of average separation distances.
%   G   (nh x 1) matrix of average semi-variogram values.
%   N   (nh x 1) matrix of pair counts in the bin.
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   14 October 2020
%------------------------------------------------------------------------------
function [H, G, N] = computeVariogram2D( X, Z, hmax, nh )
    % Validate.
    assert(size(X,2)==2, 'X must be an (nx2) matrix');
    assert(isvector(Z), 'Z must be a vector');
    assert(length(X) == length(Z), 'X and Z must be the same length');
    assert(isscalar(hmax) & hmax>0, 'hmax must be a positive scalar');
    assert( isscalar(nh) & rem(nh,1)==0 & nh>0, 'nh must be a positive integer scalar');
    
    % Initialize.
    H = zeros(nh, 1);
    G = zeros(nh, 1);
    N = zeros(nh, 1);    
    
    deltah = hmax/nh;
    
    % We sort the data by x-coordinate so we can terminte the inner
    % pair-comparison loop (i.e. the j-loop below) as early as possible.
    [X, I] = sortrows(X);
    Z = Z(I);
    
    % Run through the pairs.
    for i = 1:length(X)-1
        for j = i+1:length(X)
            deltax = X(j,1)-X(i,1);
            if deltax > hmax
                break
            end
            
            deltay = X(j,2)-X(i,2);
            h = hypot(deltax, deltay);
            k = max(1, ceil(h/deltah));
            if k <= nh
                H(k) = H(k) + h;
                G(k) = G(k) + 0.5*(Z(j)-Z(i))^2;
                N(k) = N(k) + 1;
            end
        end
    end
    
    % Compute the bin averages
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