%------------------------------------------------------------------------------
% [h,g] = variogram2D( X, Z )
%
%   Compute the variogram cloud in one space dimension. Then plot the 
%   semi-variogram.
%
% Arguments
%   X       (Nx2) matrix of spatial locations in the form (x,y).
%   Z       (N) vector of field values.
%   hmax    (scalar) maximum separation distance on the variogram plot.
%   nh      (scalar) number of subdivisions in the variogram plot.
%
% Returns
%   h   (nh x 1) matrix of average separation distances.
%   g   (nh x 1) matrix of average semi-variogram values.
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   18 February 2020
%------------------------------------------------------------------------------
function [h,g] = variogram2D( X, Z, hmax, nh )
    % Validate.
    assert( size(X,2)==2, 'X must be an Nx2 matrix');
    assert( isvector(Z), 'Z must be a vector');
    assert( length(X) == length(Z), 'X and Z must be the same length');
    assert( isscalar(hmax) & isreal(hmax) & hmax>0, 'hmax must be a positive, real scalar');
    assert( isscalar(nh) & isreal(nh) & rem(nh,1)==0 & nh>0, 'nh must be a positive, integer, real scalar');
    
    % Initialize.
    N = length(X);
    H = nan( N*(N-1)/2, 1 );
    G = nan( N*(N-1)/2, 1 );
    
    % Compute the cloud of points.
    for i = 2:N
        for j = 1:i
            k = (i-1)*(i-2)/2 + j;
            H(k) = sqrt( (X(j,1)-X(i,1))^2 + (X(j,2)-X(i,2))^2 );
            G(k) = 0.5*(Z(j)-Z(i))^2;
        end
    end
    
    [H,I] = sort(H);
    G = G(I);
    
    % Compute the averages
    dh = hmax/nh;
    n = zeros(nh,1);
    h = zeros(nh,1);
    g = zeros(nh,1);
    
    I = max(1,ceil(H/dh));
    for i = 1:nh
        n(i) = sum(I==i);
        if n(i) > 0
            h(i) = mean(H(I==i));
            g(i) = mean(G(I==i));
        else
            h(i) = NaN;
            g(i) = NaN;
        end
    end
    h = h * 3.2808;
end