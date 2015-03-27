function main()
    clc, clear all;
    close all;
    
    load('LCeventList.mat');
    load('NLCeventList.mat');
    
    numLCevents = size(LCeventList, 1);
    numNLCevents = size(NLCeventList, 1);
    
    numFeatures     = size(LCeventList{1, 4}, 2) - 2;
    numEventPoints  = size(LCeventList{1, 4}, 1);

    % Set up Division of Data for Training, Validation, Testing
    testRatio = 15/100;
 
    numTestLCevents = round(testRatio * numLCevents);
    testLCidx = randsample(size(LCeventList,1), numTestLCevents, false); % without replacement
    testLCevents = LCeventList(testLCidx, :);
    
    numTestNLCevents = round(testRatio * numNLCevents);
    testNLCidx = randsample(size(NLCeventList,1), numTestNLCevents, false); % without replacement
    testNLCevents = NLCeventList(testNLCidx, :);
    
    testEventList = [testLCevents; testNLCevents];
    
    trainValLCidx = setdiff(1:size(LCeventList,1), testLCidx)';
    trainValLCevents = LCeventList(trainValLCidx, :);
    
    trainValNLCidx = setdiff(1:size(NLCeventList,1), testLCidx)';
    trainValNLCevents = NLCeventList(trainValNLCidx, :);
    
    [testInputs, testTargets] = genDataTarget(testEventList);


    %%
    net = buildNN();
    LCindices = crossvalind('Kfold', size(trainValLCevents, 1), 10);
    NLCindices = crossvalind('Kfold', size(trainValNLCevents, 1), 10);
    
    %% start k-folder cross-validation
    for k = 1:10
        valLCevents = trainValLCevents(k ~= LCindices, :);
        valNLCevents = trainValNLCevents(k  ~= NLCindices, :);
        valEventList = [valLCevents; valNLCevents];
        [trainInputs, trainTargets] = genDataTarget(valEventList);
        
        valLCevents = trainValLCevents(k == LCindices, :);
        valNLCevents = trainValNLCevents(k == NLCindices, :);
        valEventList = [valLCevents; valNLCevents];
        [valInputs, valTargets] = genDataTarget(valEventList);
        
        % Train the Network
        init(net);
        [net,tr] = train(net,trainInputs,trainTargets);
        trainOutputs = net(trainInputs);
        % Test the Network
        valOutputs = net(valInputs);
        errors = gsubtract(valTargets, valOutputs);
        performance = perform(net, valTargets, valOutputs)
%         figure, plotperform(tr)
%         figure, plottrainstate(tr);
        figure;
        plotconfusion(trainTargets, trainOutputs, 'training', ...
            valTargets, valOutputs, 'validation');
    end
    
    % View the Network
%     view(net)

    % Plots
    % Uncomment these lines to enable various plots.

%     figure, ploterrhist(errors)
end
