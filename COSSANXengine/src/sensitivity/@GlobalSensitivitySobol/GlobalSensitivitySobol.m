classdef GlobalSensitivitySobol < Sensitivity
    %GLOBALSENSITIVITYSOBOL Global Sensitivity based on Sobol' indices
    
    % This is a class for global sensitivity analysis based of Sobol'
    % indices
    %
    % See also:
    % https://cossan.co.uk/wiki/index.php/@GlobalSensitivitySobol
    %
    % Author: Edoardo Patelli
    % Institute for Risk and Uncertainty, University of Liverpool, UK
    % email address: openengine@cossan.co.uk
    % Website: https://www.cossan.co.uk
    
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
    
    properties (SetAccess=public,GetAccess=public)
        Nbootstrap=100;
        Xsimulator
        Smethod='saltelli2010'
     end
    
    properties (Constant,Hidden)
        CmethodNames={'saltelli2008','sobol1993','saltelli2010','jansen1999','givendata'}
    end
    
    methods
        function Xobj=GlobalSensitivitySobol(varargin)
            %GlobalSensitivitySobol
            % This is the constructor for the GlobalSensitivitySobol object.
            %
            % See also: https://cossan.co.uk/wiki/index.php/@GlobalSensitivitySobol
            %
            % Author: Edoardo Patelli
            % Institute for Risk and Uncertainty, University of Liverpool, UK
            % email address: openengine@cossan.co.uk
            % Website: https://www.cossan.co.uk
            
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
            
            %% Check inputs
            OpenCossan.validateCossanInputs(varargin{:})
            
            %% Process inputs
            for k=1:2:nargin
                switch lower(varargin{k})
                    case {'sdescription'}
                        Xobj.Sdescription=varargin{k+1};
                    case {'coutputnames' 'csoutputnames' }
                        Xobj.Coutputnames=varargin{k+1};
                    case {'cinputnames' 'csinputnames' }
                        Xobj.Cinputnames=varargin{k+1};
                    case {'lperformancefunction'}
                        Xobj.LperformanceFunction=varargin{k+1};
                    case {'xtarget','xmodel'}
                        Xmodel=varargin{k+1};
                    case {'cxtarget','cxmodel'}
                        Xmodel=varargin{k+1}{1};
                    case {'nbootstrap'}
                        Xobj.Nbootstrap=varargin{k+1};
                    case {'xsimulation','xsimulator'}
                        if isa(varargin{k+1},'MonteCarlo') || ...
                                isa(varargin{k+1},'SobolSampling') || ...
                                isa(varargin{k+1},'HaltonSampling') || ...
                                isa(varargin{k+1},'LatinHypercubeSampling')
                            Xobj.Xsimulator=varargin{k+1};
                        else
                            error('OpenCossan:GlobalSensitivitySobol',...
                                'Object of class %s  can not be used',class(varargin{k+1}));
                        end
                    case {'cxsimulation','cxsimulator'}
                        if isa(varargin{k+1}{1},'MonteCarlo') || ...
                                isa(varargin{k+1}{1},'SobolSampling') || ...
                                isa(varargin{k+1}{1},'HaltonSampling') || ...
                                isa(varargin{k+1}{1},'LatinHypercubeSampling')
                            Xobj.Xsimulator=varargin{k+1}{1};
                        else
                            error('OpenCossan:GlobalSensitivitySobol',...
                                ['Object of class ' class(varargin{k+1}{1}) ' can not be used']);
                        end
                        
                    case {'sevaluatedobjectname'}
                        Xobj.Sevaluatedobjectname=varargin{k+1};
                    case {'smethod'}
                        assert(ismember(lower(varargin{k+1}),Xobj.CmethodNames), ...
                            'OpenCossan:GlobalSensitivitySobol:methodNotValid',...
                            'The method %s is not a valid name. Available methods are %s',...
                            varargin{k+1},sprintf('"%s" ',Xobj.CmethodNames{:}))
                        Xobj.Smethod=varargin{k+1};
                    otherwise
                        error('openCOSSAN:GlobalSensitivitySobol',...
                            'The PropertyName %s is not allowed',varargin{k});
                end
            end
            
            assert(~isempty(Xobj.Xsimulator),...
                'OpenCossan:GlobalSensitivitySobol',...
                'It is not possible to define a GlobalSensitivitySobol object without a Simulator')
            
            if exist('Xmodel','var')
                Xobj=Xobj.addModel(Xmodel);
            end
            
        end % end of constructor
    end
    
end

