function NNarchitecArray = geneBestNN()

    configParams.hiddenLayerSize    = [3];
    
    % Minimum performance gradient
    configParams.min_grad           = 1e-5;
    % Maximum number of epochs to train
    configParams.epochs             = 300;
    % Performance goal
    configParams.goal               = 0;
    % Learning rate
    configParams.lr                 = 0.01;
    % Regularization
    configParams.regularization     = 0.8;
    % Momentum constant
    configParams.mc                 = 0;
    
    
    NNarchitecArray = combvec(configParams.hiddenLayerSize, ...
                                configParams.min_grad, ...
                                configParams.epochs, ...
                                configParams.goal, ...
                                configParams.lr, ...
                                configParams.regularization, ...
                                configParams.mc)';
end