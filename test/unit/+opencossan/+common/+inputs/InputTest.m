classdef InputTest < matlab.unittest.TestCase
    %INPUTTEST Unit tests for the class Input
    % See also opencossan.common.inputs.Input
    
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
    
    properties
        x = opencossan.common.inputs.Parameter('Value', 10);
        y = opencossan.common.inputs.Parameter('Value', -10);
        
        f1 = opencossan.common.inputs.Function('Expression', '<&x&>.^2');
        f2 = opencossan.common.inputs.Function('Expression', '<&x&> - <&y&>');
        
        r = opencossan.common.inputs.random.ExponentialRandomVariable('lambda', 1);
        a = opencossan.common.inputs.random.ExponentialRandomVariable('lambda', 2);
        b = opencossan.common.inputs.random.NormalRandomVariable('mean', 0, 'std', 1);
        
        c = opencossan.optimization.ContinuousDesignVariable('Value', 5, 'LowerBound', 0);
        d = opencossan.optimization.ContinuousDesignVariable('Value', 3, 'UpperBound', 10);
        
        sp = opencossan.common.inputs.stochasticprocess.KarhunenLoeve();
        
        set;
    end
    
    methods (TestMethodSetup)
        function setupRandomVariableSet(testCase)
            testCase.set = opencossan.common.inputs.random.RandomVariableSet(...
                'Members', [testCase.a, testCase.b], 'Names', ["a", "b"], ...
                'correlation', [1 0.8; 0.8 1]);
        end
    end
    
    methods (Test)
        
        %% Constructor
        function constructorEmpty(testCase)
            input = opencossan.common.inputs.Input();
            testCase.verifyClass(input, 'opencossan.common.inputs.Input');
            testCase.verifyEqual(input.NumberOfInputs, 0);
        end
        
        %% Parameters
        function testParameters(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.x, testCase.y}, 'Names', ["x", "y"]);
            testCase.verifyEqual(input.Parameters, [testCase.x, testCase.y]);
            testCase.verifyEqual(input.ParameterNames, ["x", "y"]);
            testCase.verifyEqual(input.NumberOfParameters, 2);
        end
        
        %% Functions
        function testFunctions(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.x, testCase.y, testCase.f1, testCase.f2}, 'Names', ["x", "y", "f1", "f2"]);
            testCase.verifyEqual(input.Functions, [testCase.f1, testCase.f2]);
            testCase.verifyEqual(input.FunctionNames, ["f1", "f2"]);
            testCase.verifyEqual(input.NumberOfFunctions, 2);
        end
        
        %% RandomVariables
        function testRandomVariables(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.a, testCase.b}, 'Names', ["a", "b"]);
            testCase.verifyEqual(input.RandomVariables, [testCase.a, testCase.b]);
            testCase.verifyEqual(input.RandomVariableNames, ["a", "b"]);
            testCase.verifyEqual(input.NumberOfRandomVariables, 2);
        end
        
        %% DesignVariables
        function testDesignVariables(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.c, testCase.d}, 'Names', ["c", "d"]);
            testCase.verifyEqual(input.DesignVariables, [testCase.c, testCase.d]);
            testCase.verifyEqual(input.DesignVariableNames, ["c", "d"]);
            testCase.verifyEqual(input.NumberOfDesignVariables, 2);
        end
        
        %% RandomVariableSets
        function testRandomVariableSets(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.set}, 'Names', "set");
            testCase.verifyEqual(input.RandomVariableSets, testCase.set);
            testCase.verifyEqual(input.RandomVariableSetNames, "set");
            testCase.verifyEqual(input.NumberOfRandomVariableSets, 1);
        end
        
        %% StochasticProcesses
        function testStochasticProcesses(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.sp}, 'Names', "sp");
            testCase.verifyEqual(input.StochasticProcesses, testCase.sp);
            testCase.verifyEqual(input.StochasticProcessNames, "sp");
            testCase.verifyEqual(input.NumberOfStochasticProcesses, 1);
        end
        
        %% getDefaultValues
        function shouldReturnDefaultValues(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.f1, testCase.f2, testCase.set, testCase.r, testCase.x, testCase.y, ...
                testCase.c, testCase.d}, 'Names', ["f1" "f2" "set" "r" "x" "y" "c" "d"]);
            defaults = input.getDefaultValues();
            
            testCase.assertEqual(defaults.x, 10);
            testCase.assertEqual(defaults.y, -10);
            testCase.assertEqual(defaults.f1, 100);
            testCase.assertEqual(defaults.f2, 20);
            testCase.assertEqual(defaults.a, .5);
            testCase.assertEqual(defaults.b, 0);
            testCase.assertEqual(defaults.c, 5);
            testCase.assertEqual(defaults.d, 3);
        end
        
        %% getMoments
        function shouldReturnMeanAndStd(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            
            [mean, std] = input.getMoments();
            testCase.assertEqual(mean{:,:}, [1 .5 0]);
            testCase.assertEqual(std{:,:}, [1 .5 1]);
        end
        
        %% getStatistics
        function shouldReturnMedian(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            
            median = input.getStatistics();
            testCase.assertEqual(median{:,:}, [0.69315, 0.34657, 0], 'RelTol', 1e-4);
        end
        
        function shouldThrowErrorForSkewnessAndCurtosis(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            
            function skewnessAndCurtosis()
                [~, ~, ~] = input.getStatistics();
            end
            
            testCase.assertError(@() skewnessAndCurtosis(), 'OpenCossan:Input:getStatistics');
        end
        
        %% add
        function shouldAddMemberToInput(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.set}, 'Names', "set");
            input = input.add('member', testCase.r, 'name', 'r');
            
            testCase.assertEqual(input.Members, {testCase.set, testCase.r});
            testCase.assertEqual(input.Names, ["set", "r"]);
        end
        
        function shouldThrowErrorForDuplicateInput(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            testCase.assertError(@() input.add('member', testCase.r, 'name', 'r'), ...
                'OpenCossan:Input:add');
        end
        
         %% remove
        function shouldRemoveMemberFromInput(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            input = input.remove('name', 'r');
            
            testCase.assertEqual(input.Members, {testCase.set});
            testCase.assertEqual(input.Names, "set");
        end
        
        function shouldThrowErrorForMissingInput(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.set}, 'Names', "set");
            testCase.assertError(@() input.remove('name', 'r'), ...
                'OpenCossan:Input:remove');
        end
        
        %% map2physical
        function shouldMapSamplesToPhysicalSpace(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            
            s = rng(); rng(8128); % Set random seed
            
            stdNorm = array2table(randn(1e5, 3));
            stdNorm.Properties.VariableNames = ["r" "a" "b"];
            
            physical = input.map2physical(stdNorm);
            testCase.assertEqual(mean(physical.r), 1, 'RelTol', 1e-2);
            testCase.assertEqual(mean(physical.a), .5, 'RelTol', 1e-2);
            testCase.assertEqual(mean(physical.b), 0, 'AbsTol', 1e-2);
            
            testCase.assertEqual(corr(physical.a, physical.b), 0.8, 'RelTol', 1e-2);
            
            rng(s); % Restore default random number generator
        end
        
        %% map2stdNorm
        function shouldMapSamplesToStdNorm(testCase)
            input = opencossan.common.inputs.Input('Members', ...
                {testCase.r, testCase.set}, 'Names', ["r", "set"]);
            
            s = rng(); rng(8128); % Set random seed
            
            physical = input.sample('samples', 1e5);
            testCase.verifyEqual(corr(physical.a, physical.b), 0.8, 'RelTol', 1e-2);
            
            stdNorm = input.map2stdnorm(physical);
            testCase.assertEqual(mean(stdNorm.r), 0, 'AbsTol', 1e-2);
            testCase.assertEqual(mean(stdNorm.a), 0, 'AbsTol', 1e-2);
            testCase.assertEqual(mean(stdNorm.b), 0, 'AbsTol', 1e-2);
            
            testCase.assertEqual(std(stdNorm.r), 1, 'RelTol', 1e-2);
            testCase.assertEqual(std(stdNorm.a), 1, 'RelTol', 1e-2);
            testCase.assertEqual(std(stdNorm.b), 1, 'RelTol', 1e-2);
            
            testCase.assertEqual(corr(stdNorm.a, stdNorm.b), 0, 'AbsTol', 1e-2);
            rng(s); % Restore default random number generator
        end
    end
end
