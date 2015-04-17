%% signal_preprocessing.m

%% Description
%  File type:       Procedure
%
%  Summary:
%  This is the first file need to be excute for the whole project.
%  This script converts all .xlsx data into .mat format for further
%  processing

%%
%  Examples: 
%Provide sample usage code here

%%
%  Algorithm:
%df
%dsf

%%
%  See also:
% * ITEM1
% * ITEM2

%%
%  Author:       Yuan Ma
%  Date:         Oct.18.2014
%  Revision:     0.1
%  Partner:      Worked with Tianyu Wang, Yulong Li
%  Copyright:    Intelligent System Laboratory
%               University of Michigan Dearborn

clear all; clc; close all;
% ini = IniConfig();
% ini.ReadFile('configuration.ini');
% 
% home = ini.GetValues('Path Setting', 'HOME_PATH');
% Data_Path = ini.GetValues('Path Setting', 'DATA_PATH');
load('LCeventList.mat');
load('NLCeventList.mat');

numLCevent = size(LCeventList, 1);
numNLCevent = size(NLCeventList, 1);
numEventPoints = size(LCeventList{1, 4}, 1);

%% Experiment setting
netConfig.hidNodes  = 15;
netConfig.lr        = 0.05;
netConfig.goal      = 1e-10;
netConfig.outNodes  = 2;
netConfig.epochs    = 1000;

testRatio              = 0.1;
numFeatures            = size(LCeventList{1, 4}, 2) - 2;

numLCtest = round(numLCevent * testRatio);
numLCtrain = numLCevent - numLCtest;

numNLCtest = round(numNLCevent * testRatio);
numNLCtrain = numNLCevent - numNLCtest;

%% shuffle the dataset
LCpool = LCeventList(randperm(size(LCeventList,1)),:);   
NLCpool = NLCeventList(randperm(size(NLCeventList,1)),:);

%% Test Input and Target
testInput  = zeros(numFeatures, (numLCtest + numNLCtest) * numEventPoints);
testTarget = zeros(1, (numLCtest + numNLCtest) * numEventPoints);

for i = 1 : numLCtest
    testInput(:, (i - 1) * numEventPoints + 1 : i * numEventPoints) ...
                                            = LCpool{i, 4}(:, 3:end)';
end 

for i = 1 : numNLCtest
    testInput(:, (numLCtest+i-1) * numEventPoints + 1 : ...
            (numLCtest + i) *numEventPoints) = NLCpool{i, 4}(:, 3 : end)';
end

testTarget(1, 1 : numLCtest * numEventPoints) = 1;

%% Training Input and Target
trainValidInput  = zeros(numFeatures, (numLCtrain + numNLCtrain) * numEventPoints);
trainValidtarget = zeros(1, (numLCtrain + numNLCtrain) * numEventPoints);

for i = 1 : numLCtrain
    trainValidInput(:, (i - 1) * numEventPoints + 1 : i * numEventPoints) = ...
                                    LCpool{i + numLCtest, 4}(:, 3 : end)';
end

for i = 1 : numNLCtrain
    trainValidInput(:, (numLCtrain + i - 1) * numEventPoints + 1 : ...
        (numLCtrain + i) * numEventPoints) = NLCpool{i + numNLCtest, 4}(:, 3 : end)';
    
end

trainValidtarget(1, 1 : numLCtrain * numEventPoints) = 1;

%% K-fold Validation
indices = crossvalind('Kfold', trainValidtarget, 10);
accuracy_val_final = 0;

fprintf('Start 10 folder cross validation...\n');

for k = 1 : 10
    fprintf(sprintf('Fold: (%d)\n', k));
    indices_val   = find(indices == k);
    num_indices_val = length(indices_val);
    indices_train = find(indices ~= k);
    num_indices_train = length(indices_train);
    
    val_input  = zeros(numFeatures, num_indices_val);
    val_target = zeros(1, num_indices_val);
    train_input  = zeros(numFeatures, num_indices_train);
    train_target = zeros(1, num_indices_train);
    
    for i = 1 : num_indices_val
        
        val_input(:, i)  = trainValidInput(:, indices_val(i));
        val_target(:, i) = trainValidtarget(:, indices_val(i));
        
    end
    
    for i = 1 : num_indices_train
        
        train_input(:, i)  = trainValidInput(:, indices_train(i));
        train_target(:, i) = trainValidtarget(:, indices_train(i));
        
    end
    
    [netTrained, accuracy_train, accuracy_val] = LCPtrain(train_input, train_target, val_input, val_target, netConfig, k);
    
    %% I need to see all the result, we can not choose the best reuslt,
    % but everage the result for one model
    if accuracy_val > accuracy_val_final
        accuracy_val_final = accuracy_val;
        netTrained_final = netTrained;      
    end
    
end

%% Test
[ false_negative, false_positive, accuracy_test ] = test( netTrained_final, testInput, testTarget );

true_positive = numLCtest  * numEventPoints - false_negative;
true_negative = numNLCtest * numEventPoints - false_positive;

rate_true_positive  = true_positive  / (numLCtest  * numEventPoints);
rate_false_positive = false_positive / (numNLCtest * numEventPoints);

save(strcat(cd, '/result.mat'), 'accuracy_train', 'accuracy_test', 'true_positive', ...
    'false_negative', 'false_positive', 'true_negative');