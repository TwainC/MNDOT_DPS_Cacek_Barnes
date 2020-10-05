%------------------------------------------------------------------------------
% [X,Z] = simulate( n, xmin, xmax, mu, sigma, lambda )
% 
%   Simulate n randomly located, spatial correlated values in one space 
%   dimension.
%
% Arguments
%   n       number of points to simulate.
%   xmin    range of x-values go from xmin to xmax. 
%   xmax    range of x-values go from xmin to xmax.
%   mu      stationary mean.
%   sigma   stationary standard deviation.
%   lambda  correlation length.
%
% Returns
%   X   (N) vector of spatial locations.
%   Z   (N) vector of field values.
% 
% Notes
%   o   The autocovariance is a simple exponential model
%
%           cov(h) = sigma^2 * exp(-h/lambda)
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   2 May 2015
%------------------------------------------------------------------------------
function [X,Z] = simulate( n, xmin, xmax, mu, sigma, lambda )
    assert( isscalar(n) & isreal(n) & rem(n,1)==0 & n>0, 'n must be a positive, integer, real scalar');
    assert( isscalar(xmin) & isreal(xmin), 'xmin must be a real scalar');
    assert( isscalar(xmax) & isreal(xmax), 'xmax must be a real scalar');
    assert( xmin < xmax, 'xmin must be less than xmax');
    assert( isscalar(mu) & isreal(mu), 'mu must be a real scalar');
    assert( isscalar(sigma) & isreal(sigma) & sigma>0, 'sigma must be a positive, real scalar');
    assert( isscalar(lambda) & isreal(lambda) & lambda>0, 'lambda must be a positive, real scalar');
    
    X = xmin + (xmax-xmin) * rand(1,n);
    X = sort(X);
    
    MU = mu*ones(n,1);
    
    D = nan(n,n);
    for i = 1:n
        for j = 1:n
            D(i,j) = abs(X(j)-X(i));
        end
    end
    COV = sigma^2 * exp(-D/lambda);
    
    Z = mvnrnd(MU,COV);
end
