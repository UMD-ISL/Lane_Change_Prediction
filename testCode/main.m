function main()
    
    clc, clear all; close all;
    
    addpath(genpath('../utility/'));
    rng(1234,'twister');
    
    try
        delete('outfile.txt');
    catch ME
    end
    
    diary('outfile.txt');
    %%
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
    NNarchitecArray     = geneNNarchitecArray();
    NNresultLogArray(size(NNarchitecArray, 1), 1) = struct();
    
    numValFolder = 10;
    
    LCindices = crossvalind('Kfold', size(trainValLCevents, 1), numValFolder);
    NLCindices = crossvalind('Kfold', size(trainValNLCevents, 1), numValFolder);
    
    %% start k-folder cross-validation
    startTimeTemp = tic;
    for i = 1: 2 % size(NNarchitecArray, 1)
        NNconfigParamVec = NNarchitecArray(i, :);
        [net, tr, logStatis] = crossValidFunction(NNconfigParamVec, ...
                            trainValLCevents, LCindices, ...
                            trainValNLCevents, NLCindices, ...
                            numValFolder);
        
        % disp(logStatis{1});
        NNresultLogArray(i).net = net;
        NNresultLogArray(i).tr  = tr;
        NNresultLogArray(i).statis = logStatis;
        
        close all;
    end
    allTimes = toc(startTimeTemp);
    
    save('TrainingResult.mat', 'NNresultLogArray');
    
    diary off;
end
