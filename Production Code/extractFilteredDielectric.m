%==============================================================================
% function [A, B, C, D, offsets] = extractFilteredDielectric(csvPath)
%
%   Extract the location and dielectric data from a standard MnDOT-supplied
%   .csv file.
%
% Arguments:
% - csvPath : string
%       The complete path to the MnDOT-supplied .csv file. For example,
%       'D:\MnDOT\TH002_2020-07-27_rdm2__001Raw_Raw.csv'.
%
% Returns:
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
% - D : (n x 1) matrix
%       The "distances" of [ft] record by the cart based on a 
%       wheel rotation.
%
% - offsets: (3 x 1)  array
%       The offsets of each sensor
%
% - serials: (3 x 1) array
%       The serial numbers of each sensor in order of A,B,C
%
% Notes:
% - The function reads in the recorded GPS-based lat/lon information for the 
%   sensors' locations and converts these to UTM coordinates (e.g. [m]).
%
% - The UTM coordinates are in 'NAD 1983 UTM zone 15N' (EPSG:26915).
%
% - We cannot use the MATLAB function csvread because csvread requires:
%
%       "M = csvread(filename) reads a comma-separated value (CSV) formatted
%       file into array M. The file must contain only numeric values."
%
%   Instead, we will use the MATLAB function textscan. We could use the
%   MATLAB readmatrix function, but textscan seems easier sine we only
%   want the coordinates and dielectric values.
%
% Version:
%   9 November 2020
%==============================================================================
function [A, B, C, D, offsets, serials] = extractFilteredDielectric(csvPath)
    
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
    raw = textscan(fid, ['%f %*f %*s ', repmat('%f %f %*f %s %f %*f %*f %*f %s %*f %*f ', [1,3]), '%*[^\n] '], 'HeaderLines', headerLines, 'Delimiter',',');
    
    fclose(fid);

    
    % Extract the looked for information.
    D = raw{1};
    
    latA = raw{2};
    lonA = raw{3};
    offsetA = raw{4};
    dieA = raw{5};
    serialA = raw{6};
    serialA = convertCharsToStrings(cell2mat(serialA(1)));
    
    latB = raw{7};
    lonB = raw{8};
    offsetB = raw{9};
    dieB = raw{10};
    serialB = raw{11};
    serialB = convertCharsToStrings(cell2mat(serialB(1)));
    
    latC = raw{12};
    lonC = raw{13};
    offsetC = raw{14};
    dieC = raw{15};
    serialC = raw{16};
    serialC = convertCharsToStrings(cell2mat(serialC(1)));
    
    offsetA = cell2mat(offsetA);
    offsetB = cell2mat(offsetB);
    offsetC = cell2mat(offsetC);
    
    offsetA = convertCharsToStrings(offsetA(1,:));
    offsetB = convertCharsToStrings(offsetB(1,:));
    offsetC = convertCharsToStrings(offsetC(1,:));
    
    offsets = [offsetA(1);offsetB(1);offsetC(1)];
    serials = [serialA; serialB; serialC];
    
    % Convert lat/lon to UTM.
    proj = projcrs(26915, 'Authority', 'EPSG');
    
    [eastingA, northingA] = projfwd(proj, latA, lonA);
    [eastingB, northingB] = projfwd(proj, latB, lonB);
    [eastingC, northingC] = projfwd(proj, latC, lonC);
    
    % And... return
    A = [eastingA, northingA, dieA];
    B = [eastingB, northingB, dieB];
    C = [eastingC, northingC, dieC];
end