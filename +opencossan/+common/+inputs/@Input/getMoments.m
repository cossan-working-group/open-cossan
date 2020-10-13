function [mean, std] = getMoments(obj, varargin)
    %getMoments  Retrieve mean and standard deviation for the random inputs contained in the
    %Input object.
    % See also http://cossan.cfd.liv.ac.uk/wiki/index.php/getMoments@Input
    
    %{
    This file is part of OpenCossan <https://cossan.co.uk>.
    Copyright (C) 2006-2018 COSSAN WORKING GROUP

    OpenCossan is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License or,
    (at your option) any later version.

    OpenCossan is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with OpenCossan. If not, see <http://www.gnu.org/licenses/>.
    %}
    
    mean = table();
    
    if nargout > 1
        std = table();
    end
    
    % RandomVariables
    if obj.NumberOfRandomVariables > 0
        mean(1, obj.RandomVariableNames) = {obj.RandomVariables.Mean};
        if nargout > 1
            std(1, obj.RandomVariableNames) = {obj.RandomVariables.Std};
        end
    end
    
    % RandomVariableSets
    for set = obj.RandomVariableSets
        mean(1, set.Names) = {set.Members.Mean};
        if nargout > 1
            std(1, set.Names) = {set.Members.Std};
        end
    end
end