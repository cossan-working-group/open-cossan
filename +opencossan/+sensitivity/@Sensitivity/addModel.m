function Xobj=addModel(Xobj,Xmodel)
%ADDMODEL This is a function used to add the Model to the Sensitivity Object
%
%
% $Copyright~1993-2012,~COSSAN~Working~Group,~University~of~Liverpool,~UK$
% $Author: Edoardo-Patelli$

% =====================================================================
% This file is part of openCOSSAN.  The open general purpose matlab
% toolbox for numerical analysis, risk and uncertainty quantification.
%
% openCOSSAN is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License.
%
% openCOSSAN is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with openCOSSAN.  If not, see <http://www.gnu.org/licenses/>.
% =====================================================================

switch class(Xmodel)
    case 'opencossan.common.Model'
        Xobj.Xinput=Xmodel.Input;    
    case {'PolyharmonicSplines','NeuralNetwork','ResponseSurface'}
        if ~isempty(Xmodel.XFullmodel)
            Xobj.Xinput=Xmodel.XFullmodel.Xinput;
        else
            Xobj.Xinput=Xmodel.XcalibrationInput;
        end        
    case 'opencossan.reliability.ProbabilisticModel'       
        Xobj.Input = Xmodel.Input;
        if isempty(Xobj.OutputNames)
            if Xobj.LperformanceFunction
                Xobj.OutputNames = {Xmodel.XperformanceFunction.Soutputname};
            else
                Xobj.OutputNames = Xmodel.OutputNames;
            end
        end        
        
    case 'Function'
        %% Implement control of the perturbation
        error('openCOSSAN:sensitivity',...
            'Gradient estimation of a Function not implemented yet');
    otherwise        
        error('openCOSSAN:sensitivity',...
            'Sensitivity analysis estimation for input of type %s not allowed',class(Xmodel));
end

Xobj.Target = Xmodel;

% Check input and output names
if isempty(Xobj.InputNames)
    % Add only RandomVariables and Design Variables 
   Xobj.InputNames = [Xobj.Input.RandomInputNames Xobj.Input.DesignVariableNames];
end   
if isempty(Xobj.OutputNames)
   Xobj.OutputNames = Xobj.Target.OutputNames;    
end   

%% Perform some checks
Xobj = Xobj.validateSettings();
        
end


