% Tutorial for the Neumann Object
% This tutorial shows how to create and use a Neumann object
%
% Copyright 1990-2011 Cossan Working Group
% $Revision: 1 $  $Date: 2011/02/22 $
clear
close all
clc;
%% Create the input

% define the RVs
RV1 = opencossan.common.inputs.random.NormalRandomVariable('mean',7e7,'std',7e6);    
RV2 = opencossan.common.inputs.random.NormalRandomVariable('mean',7e7,'std',7e6);   
RV3 = opencossan.common.inputs.random.NormalRandomVariable('mean',7e7,'std',7e6);         

Xrvs = opencossan.common.inputs.random.RandomVariableSet('names',{'RV1','RV2','RV3'},'members',[RV1;RV2;RV3;]); 
Xinp = opencossan.common.inputs.Input('description','Xinput object');       
Xinp = add(Xinp,'member',Xrvs,'name','Xrvs');

%% Construct the Injector

Sdirectory = fullfile(opencossan.OpenCossan.getRoot,'examples','Tutorials','TurbineBlade','FEinputFiles');
Xinj       = opencossan.workers.ascii.Injector('Sscanfilepath',Sdirectory,...
                      'Sscanfilename','Nastran.cossan','Sfile','Nastran.inp');

%% Define Connector

Xcon = Connector('Spredefinedtype','nastran_x86_64',...
                     'SmaininputPath',Sdirectory,...
                     'Smaininputfile','Nastran.inp');
Xcon = add(Xcon,Xinj);

%% Define Model

Xeval  = Evaluator('Xconnector',Xcon);
Xmodel = Model('Xevaluator',Xeval,'Xinput',Xinp);

%% using Regular implementation (NASTRAN)
                   
Xsfem = Neumann('Xmodel',Xmodel,'CyoungsmodulusRVs',{'RV1','RV2','RV3'},...
                'Nsimulations',30,'Norder',5);  

% Fix the seed in order to generate same samples => to validate results
OpenCossan.resetRandomNumberGenerator(1);  

Xout  = Xsfem.performAnalysis;

Xout  = getResponse(Xout,'Sresponse','specific','MresponseDOFs',[150 3]);
display(Xout);

%% Validate the results

referenceMean = 0.9043;
referenceCoV  = 0.0942;

assert(abs(Xout.Vresponsemean-referenceMean)<1e-1,'CossanX:Tutorials:TutorialNeumann', ...
      'Reference mean value does not match.')

assert(abs(Xout.Vresponsecov-referenceCoV)<1e-1,'CossanX:Tutorials:TutorialNeumann', ...
      'Reference CoV value does not match.')
  
  
  