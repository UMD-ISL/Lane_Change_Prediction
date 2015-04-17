function net = buildNN(NNarchitecture)
    % Create a Pattern Recognition Network
    hiddenLayerSize = NNarchitecture.configParams.hiddenLayerSize;
    net = patternnet(hiddenLayerSize);
    
    %%
    net.divideFcn = '';     % turn off validation
    net.trainParam.show             = 25;
    net.trainParam.showWindow       = false;
    net.trainParam.showCommandLine  = true;
    
    %%
    net.trainParam.min_grad     = NNarchitecture.configParams.min_grad;
    net.trainParam.epochs       = NNarchitecture.configParams.epochs;
    net.trainParam.goal         = NNarchitecture.configParams.goal;
	net.performParam.regularization = NNarchitecture.configParams.regularization;
    net.trainParam.mc           = NNarchitecture.configParams.mc;
    
    %%
    net.initFcn = 'initlay';
    net.layers{1}.initFcn = 'initnw';
    net.layers{2}.initFcn = 'initnw';
    net.inputWeights{1,1}.initFcn = 'rands';
    net.layerWeights{1,1}.initFcn = 'rands';
    net.biases{1,1}.initFcn = 'rands';
end