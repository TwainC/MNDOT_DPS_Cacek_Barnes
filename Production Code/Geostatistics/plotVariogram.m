%------------------------------------------------------------------------------
%   function plotVariogram(h, g, n, model, varargin)
%
%   Plot the empirical semi-variogram and its fitted model.
%
% Arguments
%   h : double vector
%       Average separation distance of the pairs in the bin.
%
%   g : double vector
%       Average empirical semi-variogram value of the pairs in the bin.
%
%   n : double vector or []
%       Pair count in the bin. If N is not empty, the number of pairs are
%       written below each point.
%
%   model : variogramModel
%
%   varargin : parameter/value pairs
%       Parameter/value pairs to specify additional properties. The
%       order of the pairs does not matter.
%
%       The currently implemented properties are:
%
%       -- 'color', color
%           The color of the symbols and line. The default is 'blue'.
%
%       -- 'display', ['on'|'off']
%           Display the model strings to a textbox on the plot. The default 
%           is 'on'.
%
%       -- 'variance', double
%           Display the variance as a horizontal line.
%
% Returns
%   None
%
% Author
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version
%   19 October 2020
%------------------------------------------------------------------------------
function plotVariogram(h, g, n, model, varargin)
    % Validate
    assert(isvector(h) & isvector(g) & all(size(h)==size(g)));
    assert(isempty(n) | (isvector(n) & all(size(n)==size(h))));
    assert(isa(model, 'VariogramModel'));
 
    % Set the defaults.
    plot_color = 'blue';
    display_model = 'on';
    variance = [];
    hunits = '[]';
    
    % Check for user-set options.
    for indx = 1:2:length(varargin)
        switch varargin{indx}
            case 'color'
                plot_color = varargin{indx+1};
                
            case 'display'
                display_model = varargin{indx+1};
                
            case 'variance'
                variance = varargin{indx+1};
                
            case 'hunits'
                hunits = varargin{indx+1};
                                
            otherwise
                error('Unknown option ''%s''', varargin{indx});
        end
    end
    
    hold_state = ishold;
    
    % Compute the theoretical model values.
    hhat = linspace(0, max(h), 500);
    ghat = computeVariogram(model, hhat);
    
    % Plot the experimental and model semi-variogram.
    plot(h, g, 'o', hhat, ghat, '-', ...
        'MarkerEdgeColor', plot_color, 'Color', plot_color);
    
    V = axis;
    axis([0, V(2), 0, V(4)]);
    
    xlabel(sprintf('Separation Distance [%s]', hunits));
    ylabel('Semi-variogram [ ]');

    % Plot the variance if requested.
    if ~isempty(variance)
        hold on
        plot([0, max(hhat)], [variance, variance], '-', ...
            'Color', plot_color);
        if ~hold_state
            hold off;
        end
    end
        
    % Write the numbers of pairs if N is not empty.
    if ~isempty(n)
        for i = 1:length(n)
            x = h(i);
            y = g(i);
            s = sprintf('%d', n(i));
            
            text(x, y, s, ...
                'FontName', 'FixedWidth', ...
                'Color', plot_color, ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'top')
        end
    end
    
    % Write out the theoretical model.
    if strcmp(display_model, 'on')
        V = axis;
        xlim([0, V(2)]);
        ylim([0, V(4)]);

        x = 0.40*V(2);
        y = 0.10*V(4);

        text_array = str(model, hunits);
        display_text = join(text_array, newline);

        text(x, y, display_text, ...
            'FontName', 'FixedWidth', ...
            'HorizontalAlignment', 'left', ...
            'VerticalAlignment', 'bottom', ...
            'EdgeColor', 'k', ...
            'BackgroundColor', 'w');
    end
end
