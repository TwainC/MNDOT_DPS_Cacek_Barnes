%------------------------------------------------------------------------------
% [H, G, N] = computeVariogram( X, Z, hmax, nh )
%
%   Compute the one-dimensional semi-variogram.
%
% Arguments
%   X       (N) vector of spatial locations.
%   Z       (N) vector of field values.
%   hmax    (scalar) maximum separation distance on the variogram plot.
%   nh      (scalar) number of subdivisions in the variogram plot.
%
% Returns
%   H       (nh x 1) matrix of average separation distances.
%   G       (nh x 1) matrix of average semi-variogram values.
%   N       (nh x 1) matrix of the number of pairs.
%
% Notes:
% - 
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   17 September 2020
%------------------------------------------------------------------------------
function [H, G, N] = computeVariogram( X, Z, hmax, nh )
    % Validate.
    assert( isvector(X), 'X must be a vector');
    assert( isvector(Z), 'Z must be a vector');
    assert( length(X) == length(Z), 'X and Z must be the same length');
    assert( isscalar(hmax) & isreal(hmax) & hmax>0, 'hmax must be a positive, real scalar');
    assert( isscalar(nh) & isreal(nh) & rem(nh,1)==0 & nh>0, 'nh must be a positive, integer, real scalar');
    
    % Initialize.
    N = zeros(nh, 1);
    H = zeros(nh, 1);
    G = zeros(nh, 1);
    
    % Sort the data, X and Z, by increasing X.
    [X, I] = sort(X);
    Z = Z(I);
    
    % Compute the cloud of points.
    for i = 1:length(X)-1
        for j = i+1:length(X)
            h = abs(X(j)-X(i));
            g = 0.5*(Z(j)-Z(i))^2;
            k = ceil(nh * max(h/hmax, eps));
            if k > nh
                break;
            else
                H(k) = H(k) + h;
                G(k) = G(k) + g;
                N(k) = N(k) + 1;
            end
        end
    end
    
    % Compute the averages
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