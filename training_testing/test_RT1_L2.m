function [ testResult_Layer2, num_fn2, num_fp2, ratio_test2 ] = test_RT_L2(testResult_Layer1)
    
    testResult_Layer2 = testResult_Layer1;

    for i = 50 : 31795                                                      %number needs to be verified
        result_count = 0;
        for j = 0 : 4                                                       %number needs to be verified
            if testResult_Layer1(1, i - j) == 1;
                result_count = result_count + 1;
            end
        end

        if result_count >= 4                                                %number needs to be verified
            testResult_Layer2(1, i) = 1;
        else
            testResult_Layer2(1, i) = 0;
        end

    end

    testingErrorAll2 = (testResult_Layer2(1, 5000:8000) - ground_video6(1, 5000:8000)); %number needs to be verified
    testingError2 = testingErrorAll2(abs(testingErrorAll2) > 0.1);
    ratio_test2 = 1 - size(testingError2, 2) / size(testingErrorAll2, 2)
    fn2 = testingErrorAll2(testingErrorAll2 == -1);
    num_fn2 = size(fn2, 2);
    fp2 = testingErrorAll2(testingErrorAll2 ==  1);
    num_fp2 = size(fp2, 2);



end

