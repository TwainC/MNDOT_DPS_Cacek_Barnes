%------------------------------------------------------------------------------
% <CLASS> Nugget < VariogramModel
%   Nugget effect variogram model.
%
% Constructor:
%   [obj] = Nugget(C)
%       C : Parameter. Sill of the variogram.
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   19 October 2020
%------------------------------------------------------------------------------
classdef Nugget < VariogramModel
    properties
        C = Parameter.empty;
    end
    
    methods(Access=public)
        function [obj] = Nugget(C)
            if nargin > 0
                obj.C = Parameter(C);
            end
        end
        
        function [gamma] = computeVariogram(obj, h)
            if isempty(h)
                gamma = [];
            else
                gamma = value(obj.C)*ones(size(h));
            end
        end
        
        function [s] = str(obj, ~)
            s = string(sprintf('%-12s C=%6.4f []', ...
            'Nugget', value(obj.C)));
        end
    end
    
    methods (Access=protected)        
        function [P] = push(obj, P)
            P = push(obj.C, P);
        end
        
        function [P] = pop(obj, P)
            P = pop(obj.C, P);
        end
    end
end