function [ netTrained, accuracy_train ] = train_1NN( training_input, training_ground, testing_input, testing_ground, netConfig )

    speed_nn = NNBuilder2(training_input, training_ground, testing_input, testing_ground, netConfig);
    [netTrained, tr] = speed_nn.trainNN(speed_nn.net);
            
    save(strcat(TrainedNN_Output, '/trainedNN',num2str(k),'.mat'), 'netTrained');
    trainingOutput = sim(netTrained, training_input);
			
    flag_size      = size(trainingOutput);
    flag_length    = flag_size(1, 2);
    OutputflagTr   = [];
    % if training output is over 0.5 regard as class 1, otherwise regard as class 0
    for i_tr = 1:flag_length                                                                                       
        if(trainingOutput(1,i_tr) >= 0.5)
            OutputflagTr(i_tr) = 1;
        else
            OutputflagTr(i_tr) = 0;
        end
    end

    trainingErrorAll  = (OutputflagTr - training_ground);
    trainingError     = trainingErrorAll(abs(trainingErrorAll) > 0.1);            % error which is class 1 predict as class 0
    accuracy_train = 1 - size(trainingError,2) / size(trainingErrorAll, 2)

end

