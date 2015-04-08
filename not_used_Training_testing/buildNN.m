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
end