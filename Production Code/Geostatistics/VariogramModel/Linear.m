%------------------------------------------------------------------------------
% <CLASS> Linear < VariogramModel
%   Linear variogram model.
%
% Constructor:
%   [obj] = Linear(S)
%       S : Parameter. Slope of the variogram.
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   18 November 2020
%------------------------------------------------------------------------------
classdef Linear < VariogramModel
    properties
        S = Parameter.empty;
    end
    
    methods(Access=public)
        function [obj] = Linear(S)
            if nargin > 0
                obj.S = Parameter(S);
            end
        end
        
        function [gamma] = computeVariogram(obj, h)
            if isempty(h)
                gamma = [];
            else
                gamma = value(obj.S)*h;
            end
        end
        
        function [lambda] = correlationLength(obj)
            lambda = inf;
        end
        
        function [s] = str(obj, hunits)
            s = string(sprintf('%-12s S=%6.4f [1/%s]', ...
            'Linear', value(obj.S), hunits));
        end
    end
    
    methods (Access=protected)        
        function [P] = push(obj, P)
            P = push(obj.S, P);
        end
        
        function [P] = pop(obj, P)
            P = pop(obj.S, P);
        end
    end
end