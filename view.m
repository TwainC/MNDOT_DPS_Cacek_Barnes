%------------------------------------------------------------------------------
% view(X, Z, h, g)
%
%   Plot the data and the empirical semi-variogram.
%
% Arguments
%   X   (N) vector of spatial locations.
%   Z   (N) vector of field values.
%   h   (nh x 1) matrix of average separation distances.
%   g   (nh x 1) matrix of average semi-variogram values.

% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   2 May 2015
%------------------------------------------------------------------------------
function view( X, Z, h, g, n )
    % Plot the data.
    figure(1);
    plot(X,Z,'.');
    xlabel('Location');
    ylabel('Value');
    
    % Plot the variogram.
    figure(2);
    plot(h,g,'o', 'MarkerFaceColor','b', 'MarkerEdgecolor','k');
    V = axis;
    ylim([0,V(4)]);
    xlabel('Separation Distance');
    ylabel('Semi-variogram');
    
    for i=1:length(h)
        text(h(i),g(i),sprintf( '%d', n(i)));
    end
    
end