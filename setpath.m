%==============================================================================
% SCRIPT: Intialize the path for project work.
%
% Written by:
%   Twain Cacek
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   11 November 2020
%==============================================================================
projectFolders = {'.', 'variogram model', 'Production Code','m2tex'};

for i = 1:length( projectFolders )
    W = what( projectFolders{i} );
    if( ~isempty(W) )
        addpath(W.path);
    end
end