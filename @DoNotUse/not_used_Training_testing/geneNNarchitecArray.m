function NNarchitecArray = geneNNarchitecArray()

    configParams.hiddenLayerSize    = [3 5 10 15 20];
    
    % Minimum performance gradient
    configParams.min_grad           = 1e-5;
    % Maximum number of epochs to train
    configParams.epochs             = [100 300 500 800 1000 2000 3000];
    % Performance goal
    configParams.goal               = 0;
    % Learning rate
    configParams.lr                 = [0.01, 0.05, 0.1 0.2 0.5 1 2 5 10];
    % Regularization
    configParams.regularization     = [0 0.1 0.5 1 5 10];
    % Momentum constant
    configParams.mc                 = [0 0.1 0.2 0.5 1 2];
    
    
    NNarchitecArray = combvec(configParams.hiddenLayerSize, ...
                                configParams.min_grad, ...
                                configParams.epochs, ...
                                configParams.goal, ...
                                configParams.lr, ...
                                configParams.regularization, ...
                                configParams.mc)';
                 
end