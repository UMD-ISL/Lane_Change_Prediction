function [ false_negative, false_positive, accuracy_test ] = test( netTrained, testing_input, testing_ground )

    true_false_ratio        = 69 / 81;
    true_positive           = 0;
    true_negative           = 0;
    false_positive          = 0;
    false_negative          = 0;

    testingOutput     = sim(netTrained, testing_input);
    flag_size         = size(testingOutput);
    flag_length       = flag_size(1,2);
    i_ts              = 1; 
    OutputflagTs      = [];
    for i_ts          = 1:flag_length                     % if training output is over 0.5 regard as class 1
			                                                      % if training output is less than 0.5 regard as class 0
        if(testingOutput(1,i_ts) >= 0.5)
            OutputflagTs(i_ts) = 1;
        else
            OutputflagTs(i_ts) = 0;
		end
	end

    testingErrorAll   = (OutputflagTs - testing_ground);
    testingError      = testingErrorAll(abs(testingErrorAll) > 0.1);
    
    false_negative = length(find(testingErrorAll == -1));
    false_positive = length(find(testingErrorAll ==  1));

    

    
    accuracy_test  = 1 - size(testingError,2) / size(testingErrorAll, 2)
   
    


end

