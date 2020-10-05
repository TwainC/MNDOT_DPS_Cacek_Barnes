%============================================================================== 
% function extractAndPlotVariogram(csvPath)
%
%   Extract the location and dielectric data from a standard MnDOT-supplied
%   .csv file, compute the 2D variogram, and plot it. Used for meeting with
%   MNDOT on 09/30/2020
%
% Arguments:
% - csvPath : string
%       The complete path to the MnDOT-supplied .csv file. For example,
%       'D:\MnDOT\TH002_2020-07-27_rdm2__001Raw_Raw.csv'.
%
%
%
%
%   Version:
%       28 September 2020
%==============================================================================
function [means, sds] = extractAndPlotVariogram(csvPath)
    
    
    % Extract the data for the three sensors.
    assert(isfile(csvPath), "Cannot find the file %s.\n", csvPath);
    

    
    fid = fopen(csvPath);
    raw = textscan(fid, ['%f %*f %*s ' ...
        '%f %f %*f %*s %f %*f %*f %*f %*d %*f %*f ' ...
        '%f %f %*f %*s %f %*f %*f %*f %*d %*f %*f ' ...
        '%f %f %*f %*s %f %*f %*f %*f %*d %*f %*f ' ...
        '%*[^\n]'], ...
        'Headerlines', 22, 'Delimiter', ',');
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
        
    % Compute and report spatial statistics (e.g. the semi-variogram).
    hmax = 10;
    nh = 50;
    
    [hA, gA] = variogram2D(A(:,1:2), A(:,3), hmax, nh);
    
    [hB, gB] = variogram2D(B(:,1:2), B(:,3), hmax, nh);
    
    [hC, gC] = variogram2D(C(:,1:2), C(:,3), hmax, nh);
    
    plot(hA, gA, 'o', 'MarkerFaceColor','r', 'MarkerEdgecolor','k');
    hold on
    plot(hB, gB, 'o', 'MarkerFaceColor','g', 'MarkerEdgecolor','k');
    plot(hC, gC, 'o', 'MarkerFaceColor','b', 'MarkerEdgecolor','k');
    
    varA = var(A(:,3));
    varB = var(B(:,3));
    varC = var(C(:,3));
    
    plot([min(hA), max(hA)], [varA, varA], '-r');
    plot([min(hB), max(hB)], [varB, varB], '-g');
    plot([min(hC), max(hC)], [varC, varC], '-b');
    hold off
    
    fileName = convertStringsToChars(csvPath);
    fileName = fileName(100:end);
    fileName = convertCharsToStrings(fileName);
    
    V = axis;
    ylim([0,V(4)]);
    xlabel('separation distance [ft]');
    ylabel('\gamma(h) [.]');
    title(fileName);
    
    legend('A', 'B', 'C', 'Var A', 'Var B', 'Var C', 'Location', 'NorthWest');
    
    means = [fileName, round(mean(A(:,3)),2), round(mean(B(:,3)),2), round(mean(C(:,3)),2), length(A(:,1))];
    sds = [fileName, round(std(A(:,3)),2), round(std(B(:,3)),2), round(std(C(:,3)),2), length(A(:,1))];

end