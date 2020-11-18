%------------------------------------------------------------------------------
% <CLASS> VariogramModel < handle & matlab.mixin.Heterogeneous
%   The abstract base class for ALL variogram models.
%
% Methods:
%   methods(Abstract, Access=public):
%       [gamma] = computeVariogram(obj, h);
%       [lambda] = correlationLength(obj);
%       [s] = str(obj, hunits, gunits);
%
%   methods(Access=public):
%       [wse, exitflag] = fit(obj, h, g, n);
%
%   methods(Abstract, Access=protected):
%       [P] = push(obj, P);
%       [P] = pop(obj, P);
%
%   methods (Access=private)
%       [wse] = objective(obj, P, h, g, n, p)
%
% Notes:
% - All variogram models facilitate a free-parameter stack to allow fitting of
%   dynamically defined model combinations.
%
% Written by:
%   Dr. Randal J. Barnes
%   Department of Civil, Environmental, and Geo- Engineering
%   University of Minnesota
%
% Version:
%   18 November 2020
%==============================================================================
classdef (Abstract) VariogramModel < handle & matlab.mixin.Heterogeneous
    methods (Abstract, Access=public)
        [gamma] = computeVariogram(obj, h);
        [s] = str(obj, hunits);
    end
    
    methods (Abstract, Access=protected)
        [P] = push(obj, P);
        [P] = pop(obj, P);
    end
    
    methods (Access=public)
        function [rmse, exitflag] = fit(obj, h, g, n)
            P = push(obj, []);
            
            if ~isempty(P)
                fun = @(p) objective(obj, P, h, g, n, p);
                options = optimset('display', 'none');
                [p, rmse, exitflag] = fmincon(fun, P(:,2), [], [], [], [], P(:,1), P(:,3), [], options);

                % Set the model's free parameters to the fitted values.
                P(:,2) = p;
                P = pop(obj, P);
                assert(isempty(P));
            end
        end
    end
    
    methods (Access=private)
        function [rmse] = objective(obj, P, h, g, n, p)
            % Set the model's free parameters to the values given by fmincon.
            Q = P;
            Q(:,2) = p;
            Q = pop(obj, Q);
            assert(isempty(Q));

            % Compute the weighted squared error.
            ghat = computeVariogram(obj, h);
            rmse = sqrt(sum(n.*(g-ghat).^2)/sum(n));
        end        
    end
end