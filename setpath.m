%==============================================================================
% SCRIPT: Intialize the path for project work.
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%   <barne003@tc.umn.edu>
%
% Version:
%   16 October 2020
%==============================================================================
projectFolders = {'.', 'variogram model'};

for i = 1:length( projectFolders )
    W = what( projectFolders{i} );
    if( ~isempty(W) )
        addpath(W.path);
    end
end