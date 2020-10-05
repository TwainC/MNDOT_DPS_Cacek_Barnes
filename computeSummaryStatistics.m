%==============================================================================
% function S = computeSummaryStatistics(A)
%
%   Compute a suite of summary statistics for each column in A.
%
% Arguments:
% - Data : (m x n) matrix
%       The matrix of numeric values.
%
% Returns:
% - S : (8 x n) matrix
%       Matrix of summary statistics for the columns of A. Any NaN values
%       are excluded before computing the statistics. The eight rows are
%           count
%           minimum
%           25 percentile
%           median
%           75 percentile
%           maximum
%           average
%           stdev
%           variance
%
% Notes:
% -
%
% Version:
%   17 September 2020
%==============================================================================
function S = computeSummaryStatistics(Data)
    S = nan(8, size(Data,2));
    
    for j = 1:size(Data,2)
        X = Data(:,j);
        X = X(not(isnan(X)));
        
        S(1,j) = length(X);
        S(2,j) = min(X);
        S(3,j) = prctile(X, 25);
        S(4,j) = median(X);
        S(5,j) = prctile(X, 75);
        S(6,j) = max(X);
        S(7,j) = mean(X);
        S(8,j) = std(X);
        S(9,j) = var(X);
        S(10,j) = std(X)/mean(X);               % coefficient of variation
        S(11,j) = std(X)/sqrt(length(X)-1);     % standard error of the mean
        S(12,j) = std(X)/sqrt(2*length(X));     % standard error of the std
    end
end

        
    
    