%------------------------------------------------------------------------------
% <CLASS> Combo < VariogramModel
%   Combo variogram model.
%
% Constructor:
%   [obj] = Combo()
%
% Notes:
% - The Combo variogram model is a container that holds other variogram models
%   as components.
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   19 October 2020
%------------------------------------------------------------------------------
classdef Combo < VariogramModel
    properties
        modelArray = [];
    end
    
    methods(Access=public)
        function [obj] = Combo()
            obj.modelArray = VariogramModel.empty;
        end
        
        function [gamma] = computeVariogram(obj, h)
            if isempty(h)
                gamma = [];
            else
                gamma = zeros(size(h));
                for model = obj.modelArray
                    gamma = gamma + computeVariogram(model, h);
                end
            end
        end
        
        function [s] = str(obj, hunits)
            s = string.empty;
            for model = obj.modelArray
                s = [s; str(model, hunits)];
            end
        end
        
        function addComponent(obj, model)
            assert(isa(model, 'VariogramModel'));
            obj.modelArray(end+1) = model;
        end
    end
    
    methods (Access=protected)
        function [P] = push(obj, P)
            for model = obj.modelArray
                P = push(model, P);
            end
        end
        
        function [P] = pop(obj, P)
            for model = flip(obj.modelArray)
                P = pop(model, P);
            end
        end
    end
end