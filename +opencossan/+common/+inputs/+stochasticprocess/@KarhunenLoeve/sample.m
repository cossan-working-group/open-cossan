function dataseries = sample(obj, varargin)
    %SAMPLE Generates samples for the specified random process
    %  SAMPLE(SP1,varargin)
    %
    % See Also: http://cossan.cfd.liv.ac.uk/wiki/index.php/Sample@StochasticProcess
    %
    % Copyright 1983-2011 COSSAN Working Group, University of Innsbruck, Austria
    % Author: Barbara Goller
    % Revised by: Edoado Patelli 2014
    % Other contributors: Marco de Angelis, Fabrizio Scozzese
    %
    % Institute for Risk and Uncertainty, University of Liverpool, UK
    % email address: openengine@cossan.co.uk
    % Website: http://www.cossan.co.uk
    
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
    
    import opencossan.common.Dataseries
    
    % Process inputs via inputParser
    p = inputParser;
    p.FunctionName = 'opencossan.common.inputs.stochasticprocess.KarhunenLoeve.sample';
    
    % Use default values
    p.addParameter('Name',inputname(1));
    p.addParameter('Samples',0);
    
    % Parse inputs
    p.parse(varargin{:});
    % Assign input to objects properties
    validateattributes(p.Results.Samples,{'numeric'},{'>',0})
    
    Name = p.Results.Name;
    nsamples = p.Results.Samples;
    
    switch lower(obj.Distribution)
        case {'normal'}
            assert(~isempty(obj.EigenVectors) || ~isempty(obj.EigenValues), ...
                'OpenCossan:KarhunenLoeve:sample:NoTermsComputed',...
                'No KL-terms computed.\nRun the method computeTerms of the KarhunenLoeve object');
            
            Ncoord = size(obj.EigenVectors,1);
            NKL_terms = size(obj.EigenVectors,2);
            MX = zeros(nsamples,Ncoord);
            MeigvecTimesSqrteigval = obj.EigenVectors.*...
                repmat(sqrt(obj.EigenValues)',Ncoord,1);
            for isim = 1:nsamples
                Vrand = randn(1,NKL_terms);
                MX(isim,:) = obj.Mean +...
                    sum(repmat(Vrand,Ncoord,1).*MeigvecTimesSqrteigval,2)';
            end
        otherwise
            error('OpenCossan:KarhunenLoeve:sample:notImplemented',...
                'Distribution %s not yet implemented', obj.Distribution);
    end
    
    dataseries = Dataseries('MData', MX, ...
        'Mcoord', obj.Coordinates, ...
        'SDescription', 'Samples from stochastic process', ...
        'CSindexname', obj.CoordinateNames, ...
        'CSindexUnit', obj.CoordinateUnits); % comma separated units
end
