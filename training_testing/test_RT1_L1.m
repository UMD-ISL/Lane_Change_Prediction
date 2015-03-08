function [ testResult_Layer1, num_fn, num_fp, ratio_test1 ] = test_RT_L1()
    
    load(strcat(home, '/DataSet/video6.mat'));
    OutputflagTs = zeros(20, 31795);                                        %number needs to be verified
    testResult_Layer1 = zeros(1, 31795);                                    %number needs to be verified
    
    for i = 1 : 20
        disp(sprintf('NN: (%d)', i));
        load(strcat(TrainedNN_Output, '/trainedNN',num2str(i),'.mat'), 'netTrained');
        testingOutput(i, :) = sim(netTrained, test_video6);
        flag_size=size(testingOutput);
        flag_length=flag_size(1,2);
    
        for i_ts = 1 : flag_length                                          %if training output is over 0.5 regard as class 1
                                                                            %if training output is less than 0.5 regard as class 0
            if(testingOutput(i, i_ts) >= 0.5)
                OutputflagTs(i, i_ts) = 1;   
            else
                OutputflagTs(i, i_ts) = 0;
            end

        end
	
        testResult_Layer1 = testResult_Layer1 + OutputflagTs(i, :);
    
    end
    
    for i = 1 : 31795
        if testResult_Layer1(1, i) >= 6                                     %number needs to be verified
            testResult_Layer1(1, i) = 1;
        else
            testResult_Layer1(1, i) = 0;
        end
    
    end

    testingErrorAll =(testResult_Layer1(1, 5000 : 8000) - ground_video6(1, 5000 : 8000));   %number needs to be verified
    testingError = testingErrorAll(abs(testingErrorAll) > 0.1);
    ratio_test1 = 1 - size(testingError,2) / size(testingErrorAll,2);
    fn = testingErrorAll(testingErrorAll == -1);
    num_fn = size(fn, 2);
    fp = testingErrorAll(testingErrorAll ==  1);
    num_fp = size(fp, 2);



end

