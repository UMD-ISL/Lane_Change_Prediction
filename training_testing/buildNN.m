function net = buildNN()
    % Create a Pattern Recognition Network
    hiddenLayerSize = 10;
    net = patternnet(hiddenLayerSize);

    net.trainParam.epochs = 300;
    net.trainParam.goal = 1e-5;
    net.trainParam.showWindow = true;
    net.divideFcn = '';     % turn off validation
	net.performParam.regularization = 0.1;
end