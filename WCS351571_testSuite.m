classdef WCS351571_testSuite < matlab.unittest.TestCase
    properties
        sys = 'WCS351571'; % Name of model under test
    end
    
    methods(TestMethodSetup)
        function open_model(testCase)
            load_system(testCase.sys);
        end
    end
    
    methods (TestMethodTeardown)
        function close_model(testCase)
            close_system(testCase.sys);
        end
    end
    
    methods (Static)
        function set_inputs(s1, s2, s3, s4)
            % write input data to file
            matrix = [1; s1; s2; s3; s4];
            save('input.mat','-v7.3','matrix');
        end
        
        function [s1, s2, s3, s4, s5] = get_outputs()
            % read output data from file
            % only value in first second taken
            load 'output.mat' outputs
            s1 = outputs(2,1);
            s2 = outputs(3,1);
            s3 = outputs(4,1);
            s4 = outputs(5,1);
            s5 = outputs(6,1);
            
        end
    end
    methods (Test)
        
        function test_case_1 (testCase) % 0 pedal position
            % write input data
            APS1 = 1.1;
            VCC1 = 5;
            APS2 = 0.55;
            VCC2 = 5;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 0, 'Output pedal position must be 0%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,0, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
            
        end
        
        function test_case_2 (testCase) % 100 pedal position
            % write input data
            APS1 = 4.2;
            VCC1 = 5;
            APS2 = 2.1;
            VCC2 = 5;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 100, 'Output pedal position must be 100%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,0, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
            
        end
        
        function test_case_3 (testCase) % 63 pedal position
            % write input data
            APS1 = 3.05;
            VCC1 = 5;
            APS2 = 1.5;
            VCC2 = 5;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 63, 'Output pedal position must be 63%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,0, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
            
        end
        
        function test_case_4 (testCase) % Vcc1 > 5.3 V, so must return 0 THROTTLE and error
            % write input data
            APS1 = 3.05;
            VCC1 = 6;
            APS2 = 1.5;
            VCC2 = 6;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 0, 'Output pedal position must be 0%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,1, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,0, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
            
        end
        
        function test_case_5 (testCase) % Vcc1~=Vcc2 , so must return 0 THROTTLE and error
            % write input data
            APS1 = 3.05;
            VCC1 = 5;
            APS2 = 1.5;
            VCC2 = 5.2;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 0, 'Output pedal position must be 0%');
            testCase.verifyEqual(inputVoltageMismatch,1, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,0, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
            
        end
        
        function test_case_6 (testCase) % Vcc1 < 4.5 V , so must return 0 THROTTLE and error
            % write input data
            APS1 = 3.05;
            VCC1 = 4.3;
            APS2 = 1.5;
            VCC2 = 4.3;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 0, 'Output pedal position must be 0%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,1, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
            
        end
        
        function test_case_7 (testCase) % APS1 = APS2, so must return 0 THROTTLE and error
            % write input data
            APS1 = 3.05;
            VCC1 = 5;
            APS2 = 3.05;
            VCC2 = 5;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 0, 'Output pedal position must be 0%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,0, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,1, 'Pedal/Throttle stuck error occured');
        end
        
        function test_case_8 (testCase) % all inputs are zero
            % write input data
            APS1 = 0;
            VCC1 = 0;
            APS2 = 0;
            VCC2 = 0;
            testCase.set_inputs(APS1,VCC1,APS2,VCC2);
            
            % execute testing
            sim(testCase.sys);
            
            % read output data
            [THROTTLE,...
                inputVoltageMismatch,...
                involtageTooHigh,...
                involtageTooLow, throttlePedalStuck] = testCase.get_outputs();
            
            % verify output data
            testCase.verifyEqual(THROTTLE, 0, 'Output pedal position must be 0%');
            testCase.verifyEqual(inputVoltageMismatch,0, 'Vcc1 must be equal to Vcc2');
            testCase.verifyEqual(involtageTooHigh,0, 'Supply voltage must not exceed 5.3 V');
            testCase.verifyEqual(involtageTooLow,1, 'Supply voltage should not be lower than 4.5 V');
            testCase.verifyEqual(throttlePedalStuck,0, 'Pedal/Throttle stuck error occured');
        end
        
    end
end
