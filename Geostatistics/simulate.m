%------------------------------------------------------------------------------
% function [X, Z] = simulate(X, nSim, mu, lambda, computeSemivariogram)
%
%   Simulate a one-dimensional random field.
%
% Arguments:
%   X : vector
%       The location at which values are simulated. length(unique(X)) >= 2.
%
%   lambda : nonnegative scalar
%       Distance at which the correlation is 0.
%
%   nSim : strictly positive, integer scalar
%       The number of realizations to simulate.
%
%   mu : scalar
%       The population mean of the random field.
%
%   computeSemivariogram : function handle
%       The semivariogram function. The function must take one argument, h, the
%       separation distance, and return one value, gamma, the semivariogram.
%
% Returns:
%   X : vector
%       Sorted version of unique X's.
%
%   Z : (nSim x n) matrix
%       The matrix of simulated values. Each row is a single multivariate random
%       vector of length = length(X).
%
% Notes:
% o  As currently coded, the simulated random vectors are mutivarite normal.
%
% Author:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   Universuty of Minnesota
%
% Version:
%   18 November 2020
%------------------------------------------------------------------------------
function [X, Z] = simulate(X, nSim, mu, lambda, computeSemivariogram)
    assert(isvector(X) & length(X) >= 2 & length(X) == length(unique(X)));
    assert(isscalar(nSim) & rem(nSim,1)==0 & nSim >= 1);
    assert(isscalar(mu));
    assert(isa(computeSemivariogram, 'function_handle'));

    % Compute some useful values.
    X = unique(X);
    n = length(X);
    
    % Determine the population variance from the sill of the semivariogram.
    % If the semivariogram has no sill, then determine an appropriate pseudo-
    % psuedo-sill to act as a pseudo-variance.
    sill = computeSemivariogram(inf);
    if sill < inf
        variance = sill;
    else
        maxh = X(end) - X(1);
        variance = computeSemivariogram(maxh);
    end
    
    % Set up the covariance matrix.
    Sigma = zeros(n, n);
    for i = 1:n
        Sigma(i,i) = variance;
    end
    
    for i = 1:n-1
        for j = i+1:n
            h = X(j) - X(i);
            if h > lambda
                break;
            end
            
            cov = variance - computeSemivariogram(h);
            Sigma(i,j) = cov;
            Sigma(j,i) = cov;
        end
    end

    % Do the simulation.
    Z = mvnrnd(mu*ones(1,n), Sigma, nSim);
end