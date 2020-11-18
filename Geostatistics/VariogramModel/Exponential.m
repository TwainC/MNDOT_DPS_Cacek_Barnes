%------------------------------------------------------------------------------
% <CLASS> Exponential < VariogramModel
%   Exponential variogram model.
%
% Constructor:
%   [obj] = Exponential(C, A)
%       C : Parameter. Sill of the variogram.
%       A : Parameter. Length scale of the variogram.
%
% Notes:
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   18 November 2020
%------------------------------------------------------------------------------
classdef Exponential < VariogramModel
    properties
        C = Parameter.empty;
        A = Parameter.empty;
    end
    
    methods(Access=public)
        function [obj] = Exponential(C, A)
            if nargin > 0
                obj.C = Parameter(C);
                obj.A = Parameter(A);
            end
        end
        
        function [gamma] = computeVariogram(obj, h)
            if isempty(h)
                gamma = [];
            else
                gamma = value(obj.C)*(1 - exp(-h/value(obj.A)));
            end
        end
        
        function [lambda] = correlationLength(obj)
            lambda = inf;
        end
        
        function [s] = str(obj, hunits)
            s = string(sprintf('%-12s C=%6.4f [], A=%5.2f [%s]', ...
            'Exponential', value(obj.C), value(obj.A), hunits));
        end
    end
    
    methods (Access=protected)
        function [P] = push(obj, P)
            P = push(obj.C, P);
            P = push(obj.A, P);
        end
        
        function [P] = pop(obj, P)
            P = pop(obj.A, P);
            P = pop(obj.C, P);
        end
    end
end