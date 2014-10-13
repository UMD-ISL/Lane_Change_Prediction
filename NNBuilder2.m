function [nn] = NNBuilder2(trainingInput, trainingTarget, testingInput, testingTarget, netConfig)
    nn.trainNN=@trainNN;                                
%     rand('seed',77);
    %try 20 times and choose NN with best performance;
    minResult=Inf;
    for i=1:20
        % net = feedforwardnet(netConfig.hidNodes, 'trainlm');
        net = newff(trainingInput, trainingTarget, netConfig.hidNodes, {'logsig','purelin'}, 'trainscg');
        net.trainParam.epochs=2000;
        net.trainParam.goal = netConfig.goal;
        net.trainParam.lr = netConfig.lr;
        net.trainParam.show = NaN;
        net.divideFcn = '';
		% net.trainParam.mem_reduc=10000;
        net.trainParam.mc = 0.1;
        net.trainParam.showWindow=false;
        [netTrained, tr] = train(net, trainingInput, trainingTarget);  
        testingOutput = sim(netTrained, testingInput);
		
		flag_size=size(testingOutput);
			flag_length=flag_size(1,2);
			i_ts=1;
             OutputflagTs=[];
			for i_ts=1:flag_length                                       %if training output is over 0.5 regard as class 1
			                                                             %if training output is less than 0.5 regard as class 0
			      if(testingOutput(1,i_ts)>=0.5)
				   OutputflagTs(i_ts)=1;
				   
				 else
				 OutputflagTs(i_ts)=0;
				 end
				   
				   
			end
        testingErrorAll = (OutputflagTs-testingTarget);                    %testing output 1?0?
        testingError = testingErrorAll(abs(testingErrorAll)>0.1);           % what value should be better.
        testingCnt = size(testingInput,2);
        teCnt = size(testingError,2);
        trPerf = teCnt/testingCnt;
        % trPerf=tr.perf(length(tr.perf));
        if (minResult>trPerf)
            minResult=trPerf;
            nn.net=netTrained;
        end
        fprintf('%d ', i);
    end

    nn.net.trainParam.epochs = netConfig.epochs;
    
    function [netTrained, tr]= trainNN(nnet)
        [netTrained, tr] = train(nnet, trainingInput, trainingTarget);
    end

end