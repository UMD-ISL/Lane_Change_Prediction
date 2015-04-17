function eventTrainTest()
    
    clear all; clc;   % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    eventTrainTestOutput = createOutputFolder(outputPath, ...
                                            'eventTrainTestOutput');
    
    load(strcat(outputPath, '/TrainingsetOutput/LCeventList.mat'));
    load(strcat(outputPath, '/TrainingsetOutput/NLCeventList.mat'));
    
    %%
    rand('twister', 5489);  % restore to system default value
    
    numLCevents = size(LCeventList, 1);
    numNLCevents = size(NLCeventList, 1);
    
    numFeatures     = size(LCeventList{1, 4}, 2) - 2;
    numEventPoints  = size(LCeventList{1, 4}, 1);

    % Set up Division of Data for Training, Validation, Testing
    testRatio = 15/100;
    rand('twister', sum(100*clock));
    numTestLCevents = round(testRatio * numLCevents);
    testLCidx = randsample(size(LCeventList,1), numTestLCevents, false);
    testLCevents = LCeventList(testLCidx, :);
    
    numTestNLCevents = round(testRatio * numNLCevents);
    testNLCidx = randsample(size(NLCeventList,1), numTestNLCevents, false);
    testNLCevents = NLCeventList(testNLCidx, :);
    
    testEventList = [testLCevents; testNLCevents];
    
    trainValLCidx = setdiff(1:size(LCeventList,1), testLCidx)';
    trainValLCevents = LCeventList(trainValLCidx, :);
    
    trainValNLCidx = setdiff(1:size(NLCeventList,1), testLCidx)';
    trainValNLCevents = NLCeventList(trainValNLCidx, :);
    
    [testInputs, testTargets] = genDataTarget(testEventList);
    
    fgSelectModel = 0;
    
    if fgSelectModel
        %% Start model selection
        rmdir(strcat(eventTrainTestOutput, '/LogFolder'));                                    
        eventTrainTestLogFolder = createOutputFolder(eventTrainTestOutput, ...
                                    '/LogFolder');  
                                
        % Generate Neural network architecture array
        NNarchitecArray     = geneNNarchitecArray();
        
        %% start k-folder cross-validation
        LCindices = crossvalind('Kfold', size(trainValLCevents, 1), ...
                                numValFolder);
        NLCindices = crossvalind('Kfold', size(trainValNLCevents, 1), ...
                                numValFolder);
        numValFolder = 10;
        
        diary off;
        logBufferSize = 50;
        outputFileInd = 1;
        diary(strcat('./logFolder/diary_', num2str(outputFileInd), ...
                    '.txt'));        
        NNresultLogArray(size(logBufferSize, 1), 1) = struct();

        startTimeTemp = tic;
        for i = 1:size(NNarchitecArray, 1)

            NNlogInd = mod(i, logBufferSize);
            if 0 == NNlogInd
                NNlogInd = logBufferSize;
            end

            fprintf('Neural network Architecture index -- %d\n', i);
            NNconfigParamVec = NNarchitecArray(i, :);
            [net, tr, logStatis] = crossValidFunction(NNconfigParamVec, ...
                                trainValLCevents, LCindices, ...
                                trainValNLCevents, NLCindices, ...
                                numValFolder);

            disp(logStatis{1});
            fprintf('***********************************************\n\n');

            NNresultLogArray(NNlogInd).net = net;
            NNresultLogArray(NNlogInd).tr  = tr;
            NNresultLogArray(NNlogInd).statis = logStatis;

            close all;

            flgSaveOutput = ~mod(i, logBufferSize) || ...
                                size(NNarchitecArray, 1) == i;
            if flgSaveOutput
                diary off;
                save(strcat(eventTrainTestLogFolder, '/TrainingResult_',...
                    num2str(outputFileInd), '.mat'), 'NNresultLogArray');

                if i ~= size(NNarchitecArray, 1)
                    outputFileInd = outputFileInd + 1;
                    diary(strcat(eventTrainTestLogFolder, '/diary_', ...
                            num2str(outputFileInd), '.txt'));
                end
            end
        end
        allTimes = toc(startTimeTemp);
    end
    
    net = geneOneNN(geneBestNN());
    net = configure(net, testInputs, testTargets);
    trainValEventList = [trainValLCevents; trainValNLCevents];
    [trainValInputs, trainValTargets] = genDataTarget(trainValEventList);
    
    [net, tr] = train(net, trainValInputs, trainValTargets);
    
    trainValOutputs = net(trainValInputs);
        
    testOutputs = net(testInputs); % confusion matrix
    [c, cm, ind, per] = confusion(testTargets, testOutputs);
    
    numTPpoints = cm(1, 1);  numFNpoints = cm(1, 2);
    numFPpoints = cm(2, 1);  numTNpoints = cm(2, 2);
            
    statis.accuracy = (numTPpoints + numTNpoints)/(numTPpoints + ...
                                 numFPpoints + numFNpoints + numTNpoints);
                             
    statis.precision   = numTPpoints / (numTPpoints + numFPpoints);
    statis.sensitivity = numTPpoints / (numTPpoints + numFNpoints);
    statis.specificity = numTNpoints / (numFPpoints + numTNpoints);
    
    statis.recall      = statis.sensitivity;
    statis.Fscore      =  2 * numTPpoints / (2 * numTPpoints + ...
                                    numFPpoints + numFNpoints);

    statis.c             = c;       statis.cm            = cm;
    statis.ind           = ind;     statis.per           = per;
    statis.net           = net;     statis.tr            = tr; 
    
    plotconfusion(trainValTargets, trainValOutputs, 'training', ...
                testTargets, testOutputs, 'testing');
    
    save(strcat(eventTrainTestOutput, '/testingResult.mat'), 'statis');
end
