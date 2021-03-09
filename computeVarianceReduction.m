%    Sill   |      oooooooooooooo
%           |    o
%           |  o
%    Nugget |o
%           |
%           -----------------------------------
%                  |
function Lambda = computeVarianceReduction(XY, Nugget, Sill, Range)
    sum = 0;
    for i = 1:length(XY)
        for j = 1:length(XY)
            dx = XY(i,1) - XY(j,1);
            dy = XY(i,2) - XY(j,2);
            d = sqrt(dx*dx + dy*dy);
            
            if d>Range
                sum = sum + Sill;
            else
                sum = sum + Nugget + (Sill-Nugget)*(d/Range);
            end
            
        end
    end
    
    Lambda = (sum/length(XY)^2)/Sill;
end
