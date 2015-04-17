function testfunction()
    clear all; clc; close all;
    % ini = IniConfig();
    % ini.ReadFile('configuration.ini');
    % 
    % home = ini.GetValues('Path Setting', 'HOME_PATH');
    % Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');
    load('LCeventList.mat');
    load('NLCeventList.mat');

    numLCevent      = size(LCeventList, 1);
    numNLCevent     = size(NLCeventList, 1);
    numEventPoints  = size(LCeventList{1, 4}, 1);
    numFeatures     = size(LCeventList{1, 4}, 2) - 2;
    
    %% experiment configuration
    netConfig = configNN();
    testRatio              = 0.1;
    numTestLC               = round(numLCevent * testRatio);
    numTestNLC              = round(numNLCevent * testRatio);
    numTrainValidLC         = numLCevent - numTestLC;
    numTrainValidNLC        = numNLCevent - numTestNLC;

    %% shuffle the dataset
    LCeventList = shuffleDataset(LCeventList);
    NLCeventList = shuffleDataset(NLCeventList);

    %% Generate Test Dataset
    testEventList = [LCeventList(1:numTestLC, :); ...
                NLCeventList(1:numTestNLC, :)];
    numTestEvent = numTestLC + numTestNLC;
    testInput  = zeros(numTestEvent * numEventPoints, numFeatures);
    testTarget = zeros(numTestEvent * numEventPoints, 1);

    for i = 1 : numTestEvent
    testInput((i - 1) * numEventPoints + 1 : i * numEventPoints, :) ...
                                        = testEventList{i, 4}(:, 3:end);
    end

    testTarget(1 : numTestLC * numEventPoints, 1) = 1;
    testTarget(1 + numTestLC * numEventPoints : end, 1) = 0;

    %% generate validation dataset
    trainValidEventList = [LCeventList(numTestLC + 1:end, :); ...
                NLCeventList(numTestNLC + 1:end, :)];
    numTrainValidEvent = numTrainValidLC + numTrainValidNLC;
    trainValidInput  = zeros(numTrainValidEvent * numEventPoints, numFeatures);
    trainValidTarget = zeros(numTrainValidEvent * numEventPoints, 1);
    
    for i = 1 : numTestEvent
    trainValidInput((i - 1) * numEventPoints + 1 : i * numEventPoints, :) ...
                                    = trainValidEventList{i, 4}(:, 3:end);
    end

    trainValidTarget(1 : numTrainValidLC * numEventPoints, 1) = 1;
    trainValidTarget(1 + numTrainValidLC * numEventPoints : end, 1) = 0;
    

    net = feedforwardnet(10);
    numNN = 10;
    nets = cell(1,numNN);
    for i=1:numNN
        disp(['Training ' num2str(i) '/' num2str(numNN)])
        net = init(net);
        nets{i} = train(net,trainValidInput', trainValidTarget');
    end
    
    perfs = zeros(1,numNN);
    testOutputTotal = 0;
    for i=1:numNN
        neti = nets{i};
        testOutput = neti(testInput');
        perfs(i) = mse(neti,testTarget',testOutput);
        testOutputTotal = testOutputTotal + testOutput;
    end
    perfs
    y2AverageOutput = testOutputTotal / numNN;
    perfAveragedOutputs = mse(nets{1}, testTarget', y2AverageOutput);
    
%     %% K-fold Validation        
%     indices = crossvalind('Kfold', trainValidTarget, 10);
%     finalValidAccuracy = 0;
% 
%     fprintf('Start 10 folder cross validation...\n');
% 
%     tic;
%     for k = 1 : 10
%         fprintf(sprintf('Fold: (%d)\n', k));
%         validIndices    = find(indices == k);
%         validInput      = trainValidInput(validIndices, :);
%         validTarget     = trainValidTarget(validIndices, :);
% 
%         trainIndices    = find(indices ~= k);
%         trainInput      = trainValidInput(trainIndices, :);
%         trainTarget     = trainValidTarget(trainIndices, :);
% 
%         [netTrained, trainAccuracy, validAccuracy] = LCPtrain(trainInput', ...
%                     trainTarget', validInput', validTarget', netConfig, k);
% 
%         %% I need to see all the result, we can not choose the best reuslt,
%         % but everage the result for one model
%         fprintf('training accuracy %f \n', trainAccuracy);
%         if validAccuracy > finalValidAccuracy
%             finalValidAccuracy = validAccuracy;
%             bestNN = netTrained; 
%         end
%     end
%     toc;
% 
%     %% Test
%     [false_negative, false_positive, testAccuracy] = ...
%             test(bestNN, testInput, testTarget);
% 
%     true_positive = numTestLC  * numEventPoints - false_negative;
%     true_negative = numTestNLC * numEventPoints - false_positive;
% 
%     rate_true_positive  = true_positive  / (numTestLC  * numEventPoints);
%     rate_false_positive = false_positive / (numTestNLC * numEventPoints);
% 
%     fprintf('testing accuracy %f \n', testAccuracy);
%     save(strcat(cd, '/result.mat'), 'accuracy_train', 'accuracy_test', 'true_positive', ...
%     'false_negative', 'false_positive', 'true_negative');
end