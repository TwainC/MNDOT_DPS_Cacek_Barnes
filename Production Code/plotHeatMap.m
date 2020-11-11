%==============================================================================
% function plotHeatMap(csvPath, varargin)
%
%     Extract the location and dielectric data from a standard MnDOT-supplied
%     .csv file and plot geographically refferenced dielectric points. Points colored
%     according to dilectric value using a gaussian-scaled colormap.
%
%
% Arguments:
% - csvPath : string
%       The complete path to the MnDOT-supplied .csv file. For example,
%       'D:\MnDOT\TH002_2020-07-27_rdm2__001Raw_Raw.csv'.
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
%   plotHeatMap(csvPath)
%
%   plotHeatMap(csvPath, ...
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
%   11 November 2020
%==============================================================================
function plotHeatMap(csvPath, varargin)
    
       
    % Extract the data for the three sensors.
    assert(isfile(csvPath), "Cannot find the file %s.\n", csvPath);

    fid = fopen(csvPath);
    
    %Find how many header lines there are
    headerBool = 0;
    headerLines = 0;
    while headerBool == 0
        line = fgetl(fid);
        if length(line) > 8
            if line(1:8) == 'Distance'
                headerBool = 1;
            end
        end
        headerLines = headerLines + 1;
    end
    
    frewind(fid);
    
    %Read in all data that will be used in catalog
    raw = textscan(fid, ['%f %*f %*s ', repmat('%f %f %*f %*s %f %*f %*f %*f %*s %*f %*f ', [1,3]), '%*[^\n] '], 'HeaderLines', headerLines, 'Delimiter',',');
    
    fclose(fid);
    
    % Extract the looked for information.
    D = raw{1};
    
    latA = raw{2};
    lonA = raw{3};
    dieA = raw{4};
    
    latB = raw{5};
    lonB = raw{6};
    dieB = raw{7};
    
    latC = raw{8};
    lonC = raw{9};
    dieC = raw{10};
    
    % Convert lat/lon to UTM.
    proj = projcrs(26915, 'Authority', 'EPSG');
    
    [eastingA, northingA] = projfwd(proj, latA, lonA);
    [eastingB, northingB] = projfwd(proj, latB, lonB);
    [eastingC, northingC] = projfwd(proj, latC, lonC);
    
    % And... return
    A = [eastingA, northingA, dieA];
    B = [eastingB, northingB, dieB];
    C = [eastingC, northingC, dieC];
    
    narginchk(1, inf);
    
    % Set the default values for the options.
    colormap('turbo');
    colorramp = 'gaussian';
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
            ylabel('Northing [m]');
            xlabel('Easting [m]');
            hold off;

            h = colorbar;
            caxis([lowerbound, upperbound]);
            ylabel(h,'Dielectric')
                
        case 'gaussian'
            % Create the plot using a gaussian-scaled colorbar.
            hold on;
            scatter(A(:,1), A(:,2), markersize, normcdf(A(:,3), mu, sigma), 'filled');
            scatter(B(:,1), B(:,2), markersize, normcdf(B(:,3), mu, sigma), 'filled');
            scatter(C(:,1), C(:,2), markersize, normcdf(C(:,3), mu, sigma), 'filled');
            ylabel('Northing [m]');
            xlabel('Easting [m]');
            hold off;

            % Create the nonlinear colorbar tick marks and labels.
            cb = colorbar;
            caxis([0, 1]);
            ylabel(cb,'Dielectric')
            
            TickValues = (-2.0:0.5:2.0)*sigma + mu;
            cb.Ticks = normcdf(TickValues, mu, sigma);
            cb.TickLabels = sprintfc("%.3f", TickValues);
            
        otherwise
            error('Unknown colorramp ''%s''', colorramp);
    end
end
