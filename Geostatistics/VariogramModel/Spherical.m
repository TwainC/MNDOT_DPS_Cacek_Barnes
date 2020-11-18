%------------------------------------------------------------------------------
% <CLASS> Spherical < VariogramModel
%   Spherical variogram model.
%
% Constructor:
%   [obj] = Spherical(C, A)
%       C : Parameter. Sill of the variogram.
%       A : Parameter. Range of the variogram.
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   18 November 2020
%------------------------------------------------------------------------------
classdef Spherical < VariogramModel
    properties
        C = Parameter.empty;
        A = Parameter.empty;
    end
    
    methods(Access=public)
        function [obj] = Spherical(C, A)
            if nargin > 0
                obj.C = Parameter(C);
                obj.A = Parameter(A);
            end
        end
        
        function [gamma] = computeVariogram(obj, h)
            if isempty(h)
                gamma = [];
            else
                c = value(obj.C);
                a = value(obj.A);
                
                gamma = c*ones(size(h));
                I = (h < a);
                gamma(I) = c*(1.5*(h(I)/a) - 0.5*(h(I)/a).^3);
            end
        end
        
        function [lambda] = correlationLength(obj)
            lambda = value(obj.A);
        end
        
        function [s] = str(obj, hunits)
            s = string(sprintf('%-12s C=%6.4f [], A=%5.2f [%s]', ...
            'Spherical', value(obj.C), value(obj.A), hunits));
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