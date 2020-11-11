%------------------------------------------------------------------------------
% <CLASS> Parameter
%   A bounded parameter class facilitating a free parameter stack.
%
% Constructor:
%   [obj] = Parameter(P)
%
% Notes:
%   A Parameter is defined by three numbers: a lower bound, a current value, and
%   an upper bound. A parameter is stored as a (1x3) matrix with internal order
%   [lower bound, current value, upper bound].
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   19 October 2020
%------------------------------------------------------------------------------
classdef Parameter < handle
    properties
        P = [];
    end
    
    methods
        function [obj] = Parameter(P)
            if nargin > 0
                assert(isvector(P));
                if length(P) == 1
                    assert(P >= 0)
                    obj.P = [P, P, P];
                elseif length(P) == 3
                    assert(0 <= P(1) & P(1) <= P(2) & P(2) <= P(3));
                    obj.P = [P(1), P(2), P(3)];
                else
                    error('Argument Error');
                end
            end
        end
        
        function [p] = value(obj)
            p = obj.P(2);
        end
        
        function [bool] = isfree(obj)
            bool = obj.P(1) < obj.P(3);
        end
        
        function [P] = push(obj, P)
            if isfree(obj)
                P = [obj.P; P];
            end
        end
        
        function [P] = pop(obj, P)
            assert(0 <= P(1,1) & P(1,1) <= P(1,2) & P(1,2) <= P(1,3));
            if isfree(obj)
                obj.P = P(1,:);
                P(1,:) = [];
            end
        end
    end
end