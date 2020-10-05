%------------------------------------------------------------------------------
% catalogData(srcFolder, dstFile, recursive)
%
%   Catalog the MnDOT RDM .csv files in srcFolder out to dstFile.
%
% Arguments:
% - srcFolder : string
%       The source folder containing the .csv files to catalog.
%
% - dstFile : string
%       The destination file into which the cataloged information is written.
%       If this file exists it is opened in append mode. If this file does not
%       exist, the file is created and the header line written at the top.
%
%       If dstFile is an empty string, i.e. '', then the cataloged information
%       is written out to the console.
%
% - recursive : boolean
%       If true then the scrFolder is searched recursively. That is, all
%       .csv files in the folder and ANY subfolder is cataloged. If false,
%       only .csv files in the scrFolder are cataloged.
%
% Notes:
% -
%
% Authors:
%   Twain Cacek and Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   4 Oct 2020
%------------------------------------------------------------------------------
function catalogData(srcFolder, dstFile, recursive)
    tic;
    
    % Process the arguments.
    assert(nargin ==3, ...
        'usage: catalogData(srcFolder, dstFile, recursive)');
    
    % Make certain that the source folder exists.
    assert(exist(srcFolder, 'dir'), ...
        sprintf('The specified source folder, %s, does not exist.', srcFolder));
    
    % Open the dstFile in append mode.
    if isempty(dstFile)
        fid = 1;
        needsHeader = true;
    else
        if exist(dstFile, 'file')
            needsHeader = false;
        else
            needsHeader = true;
        end
        
        fid = fopen(dstFile, 'a');
    end
    
    % The header text needs to align with the output.
    if needsHeader
        fprintf(fid, '''File Name'', ''Collection Direction'', ''A Lateral Offset'', ''B Lateral Offset'', ''C Lateral Offset'', ''Station Count'', ''Minimum Distance'', ''Maximum Distance'', ''Path Length'', ''A Dielectric Mean'', ''B Dielectric Mean'', ''C Dielectric Mean'', \n');
    end
    
    % Make a list of all .csv files in the srcFolder.
    if recursive
        % fileList = dir(fullfile(srcFolder, '**\*.csv'));
        fileList = dir(fullfile(srcFolder, '**/*.csv'));
    else
        fileList = dir(fullfile(srcFolder, '*.csv'));
    end
    
    % March through each of the .csv files.
    for n = 1:length(fileList)
        filePath = fullfile(fileList(n).folder, fileList(n).name);
        sfid = fopen(filePath);
        
        collectionBool = 0;
        while collectionBool == 0
            line = fgetl(sfid);
            if length(line) > 4
                if line(1:4) == 'Coll'
                collectionBool = 1;
                end
            end
        end
            
        direction = line(23:32);
        
        frewind(sfid);
        
        headerBool = 0;
        headerLines = 0;
        while headerBool == 0
            line = fgetl(sfid);
            if length(line) > 8
                if line(1:8) == 'Distance'
                headerBool = 1;
                end
            end
            headerLines = headerLines + 1;
        end
        
        frewind(sfid);
        
        dielectric = textscan(sfid, ['%f %*f %*s ', repmat('%*f %*f %*f %s %f %*f %*f %*f %*f %*f %*f ', [1,3]), '%*[^\n] '], 'HeaderLines', headerLines, 'Delimiter',',');
        
        fclose(sfid);
        
        lateralOffsetA = dielectric{2};
        lateralOffsetB = dielectric{4};
        lateralOffsetC = dielectric{6};
        
        dielectric{2} = [];
        dielectric{4} = [];
        dielectric{6} = [];
        
        lateralOffsetA = cell2mat(lateralOffsetA);
        lateralOffsetB = cell2mat(lateralOffsetB);
        lateralOffsetC = cell2mat(lateralOffsetC);
        
        dielectric = cell2mat(dielectric);
        
        
        % Extract the needed information.
        count = length(dielectric(:,1));
        
        minDistance = min(dielectric(:,1));
        maxDistance = max(dielectric(:,1));
        totalLength = maxDistance - minDistance;
        
        meanA = mean(dielectric(:,2));
        meanB = mean(dielectric(:,3));
        meanC = mean(dielectric(:,4));
        
        interval(n,1) = n;
        interval(n,2) = minDistance;
        interval(n,3) = maxDistance;
        intervalSwerve(n) = contains(fileList(n).name, 'sw');
        
        
        % Write the information out to the catalog.
        fprintf(fid, '''%s'', ''%s'', ''%s'', ''%s'', ''%s'', %d, %.1f, %.1f, %.1f, %.4f, %.4f, %.4f \n', ...
            fileList(n).name, direction, lateralOffsetA(1,:), lateralOffsetB(1,:), ...
            lateralOffsetC(1,:), count, minDistance, maxDistance, totalLength, ...
            meanA, meanB, meanC);
        
    end
    
    % Close the catalog file.
    if fid ~= 1
        fprintf(fid, '\n');
        fclose(fid);
    end
    
    % Plot the intrevals of all the files
    hold on;
    for i=1:n
        if intervalSwerve(i)
            plot([interval(i,2), interval(i,3)], [interval(i,1), interval(i,1)], '-r', 'LineWidth', 3, 'DisplayName', 'Swerve')
        else
            if abs(interval(i,2)-interval(i,3)) < 2
                plot([interval(i,2), interval(i,3)], [interval(i,1), interval(i,1)], 'om','DisplayName', 'Point')
            else
                plot([interval(i,2), interval(i,3)], [interval(i,1), interval(i,1)], '-b', 'LineWidth', 3, 'DisplayName', 'Longitudinal')
            end
        end    
    end
    
    h = zeros(3, 1);
    h(1) = plot(NaN,NaN, '-r', 'LineWidth', 3);
    h(2) = plot(NaN,NaN,'om');
    h(3) = plot(NaN,NaN,'-b', 'LineWidth', 3);
    lgd = legend(h, 'Swerve','Point','Longitudinal');
    title(lgd, 'Collection Path Type');
    title('Data Collection Intervals');
    ylabel('Data Set Index [ ]')
    xlabel('Collection Location [ft]')
    grid(gca, 'minor');
    grid on;
    hold off;
    
    fprintf('\n');
    fprintf('%d .csv files were successfully cataloged. \n', length(fileList));
    toc
end