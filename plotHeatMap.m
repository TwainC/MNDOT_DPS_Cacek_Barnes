%==============================================================================
% function plotHeatMap(A, B, C, varargin)
%
%     Plot geographically refferenced dielectric points. Points colored
%     according to dilectric value using a gaussian-scaled colormap.
%
%  Arguments:
% - A : (n x 3) matrix
%       The three columns are [UTM eastings, UTM northings, dielectric]
%       for first sensor.
%
% - B : (n x 3) matrix
%       The three columns are [UTM eastings, UTM northings, dielectric]
%       for second sensor.
%
% - C : (n x 3) matrix
%       The three columns are [UTM eastings, UTM northings, dielectric]
%       for third sensor.
%
% - varargin : parameter/value pairs
%       Parameter/value pairs to specify additional properties. The
%       order of the pairs does not matter.
%
%       The currently implemented properties are:
%
%       -- 'colormap', string
%           Any of the standard colormap names can be used. 
%           Default = 'turbo'.
%
%       -- 'colorramp', string
%           The colorramp scaling: 'linear', or 'gaussian'.
%           Default = 'linear'
%
%       -- 'markersize', float
%           The markersize determines area of each marker (in points^2).
%           Default = 10.
%
%       -- 'lowerbound', float
%           The lowerbound of the linear colorramp scaling.
%           Default = minimum of the dielectric data sets.
%
%       -- 'upperbound', float
%           The upperbound of the linear colorramp scaling.
%           Default = maximum of the dielectric data sets.
%
%       -- 'mu', float
%           The center point of the gaussian colorramp scaling.
%           Default = mean of the dielectric data sets.
%
%       -- 'sigma', float
%           The spread of the gaussian colorramp scaling.
%           Default = standard deviation of the dielectric data sets.
%
% Examples:
%   plotHeatMap(A, B, C)
%
%   plotHeatMap(A, B, C, ...
%       'colormap', 'jet', ...
%       'colorramp', 'gaussian', ...
%       'markersize', 15, ...
%       'mu', 4.76, ...
%       'sigma', 0.1 )
%
% Notes:
% - The 'lowerbound' and 'upperbound' properties for the linear colorramp
%   allow the user to maintain a consistent colormap across multiple plots.
%
% - The 'mu' and 'sigma' properties for the gaussian colorramp allow the user
%   to maintain a consistent colormap across multiple plots.
%
% Author:
%   Twain Cacek & Dr. Randal J Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   30 September 2020
%==============================================================================
function plotHeatMap(A, B, C, varargin)
    narginchk(3, inf);
    
    % Set the default values for the options.
    colormap('turbo');
    colorramp = 'linear';
    markersize = 10;
    lowerbound = min([A(:,3); B(:,3); C(:,3)]);
    upperbound = max([A(:,3); B(:,3); C(:,3)]);
    mu = mean([A(:,3); B(:,3); C(:,3)]);
    sigma = std([A(:,3); B(:,3); C(:,3)]);
    
    % Check for user-set options.
    for indx = 1:2:length(varargin)
        switch varargin{indx}
            case 'colormap'
                colormap(varargin{indx+1});
                
            case 'colorramp'
                colorramp = varargin{indx+1};
                
            case 'markersize'
                markersize = varargin{indx+1};
                
            case 'upperbound'
                upperbound = varargin{indx+1};
                
            case 'lowerbound'
                lowerbound = varargin{indx+1};
                
            case 'mu'
                mu = varargin{indx+1};
                
            case 'sigma'
                sigma = varargin{indx+1};
                
            otherwise
                error('Unknown option ''%s''', varargin{indx});
        end
    end
    
    switch colorramp
        case 'linear'
            % Create the plot using a linear-scaled colorbar.
            hold on;
            scatter(A(:,1), A(:,2), markersize, A(:,3), 'filled');
            scatter(B(:,1), B(:,2), markersize, B(:,3), 'filled');
            scatter(C(:,1), C(:,2), markersize, C(:,3), 'filled');
            hold off;

            colorbar;
            caxis([lowerbound, upperbound]);
                
        case 'gaussian'
            % Create the plot using a gaussian-scaled colorbar.
            hold on;
            scatter(A(:,1), A(:,2), markersize, normcdf(A(:,3), mu, sigma), 'filled');
            scatter(B(:,1), B(:,2), markersize, normcdf(B(:,3), mu, sigma), 'filled');
            scatter(C(:,1), C(:,2), markersize, normcdf(C(:,3), mu, sigma), 'filled');
            hold off;

            % Create the nonlinear colorbar tick marks and labels.
            cb = colorbar;
            caxis([0, 1]);
            
            TickValues = (-2.0:0.5:2.0)*sigma + mu;
            cb.Ticks = normcdf(TickValues, mu, sigma);
            cb.TickLabels = sprintfc("%.3f", TickValues);
            
        otherwise
            error('Unknown colorramp ''%s''', colorramp);
    end
end
