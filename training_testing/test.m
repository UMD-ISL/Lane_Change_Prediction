function [ true_positive, false_negative, false_positive, true_negative, accuracy_test ] = test( netTrained, testing_input, testing_ground )

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
    

    

    
    accuracy_test  = 1 - size(testingError,2) / size(testingErrorAll, 2)
   
    %% plot confusion matrix
    Total_length    = size(OutputflagTs,2);
    one_third       = OutputflagTs(1, 1 : Total_length * true_false_ratio);
    two_third       = OutputflagTs(1, (Total_length * true_false_ratio + 1) : end);
    true_positive   = true_positive + size(find(1 == one_third), 2);
    false_negative  = true_negative + size(find(0 == one_third), 2);
    false_positive  = false_positive + size(find(1 == two_third), 2);
    true_negative   = false_negative + size(find(0 == two_third), 2);



end

