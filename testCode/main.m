function main()
    
    clc, clear all; close all;
    
    addpath(genpath('../utility/'));
    rng(1234,'twister');
    
    try
        delete('outfile.txt');
    catch ME
    end
    
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
%     NNarchitecArray     = NNarchitecArray(1:3, :);   % small dataset
    
    numValFolder = 10;
    
    LCindices = crossvalind('Kfold', size(trainValLCevents, 1), numValFolder);
    NLCindices = crossvalind('Kfold', size(trainValNLCevents, 1), numValFolder);
    
    %% start k-folder cross-validation
    
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
        fprintf('****************************************************\n\n');
        
        NNresultLogArray(NNlogInd).net = net;
        NNresultLogArray(NNlogInd).tr  = tr;
        NNresultLogArray(NNlogInd).statis = logStatis;
        
        close all;
        
        flgSaveOutput = ~mod(i, logBufferSize) || ...
                            size(NNarchitecArray, 1) == i;
        if flgSaveOutput
            diary off;
            save(strcat('./logFolder/TrainingResult_', ...
                    num2str(outputFileInd), '.mat'), 'NNresultLogArray');
            
            if i ~= size(NNarchitecArray, 1)
                outputFileInd = outputFileInd + 1;
                diary(strcat('./logFolder/diary_', num2str(outputFileInd), ...
                    '.txt'));
            end
        end
    end
    allTimes = toc(startTimeTemp);
end
