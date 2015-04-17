function [  ] = realtimeTrainTest(  )
%REALTIMETESTING Summary of this function goes here
%   Detailed explanation goes here
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    
    vidSegsStartEndTime = { '00:09:00.000' '00:10:00.000';
                            '00:38:35.000' '00:39:35.000';
                            '00:49:23.000' '00:50:23.000';
                            '01:03:29.000' '01:04:29.000';
                            '01:04:02.000' '01:05:02.000';
                            '01:04:53.000' '01:05:53.000';
                        };
                    
    vidSegsData = cell(size(vidSegsStartEndTime, 1), 1);
    
    cat = load(strcat(outputPath, '/eventTrainTestOutput/testingResult.mat'));
    statis = cat.statis;
    net = statis.net;
    
    for i = 1:size(vidSegsStartEndTime, 1)
        clc;
        vidSegsData{i, 1} = geneRealtimeData(1, vidSegsStartEndTime{i, 1}, ...
                            vidSegsStartEndTime{i, 2});         
        realTestInputs = vidSegsData{i, 1}(:, 3:end)';
        realTestTargets = [vidSegsData{i, 1}(:, 2)';
                            ~vidSegsData{i, 1}(:, 2)'];
        realTestTargets = mod(realTestTargets, 2);
        
        realTestOutputs = net(realTestInputs); % confusion matrix
        [c, cm, ind, per] = confusion(realTestTargets, realTestOutputs);

        numTPpoints = cm(1, 1);  numFNpoints = cm(1, 2);
        numFPpoints = cm(2, 1);  numTNpoints = cm(2, 2);

        statis.accuracy = (numTPpoints + numTNpoints)/(numTPpoints + ...
                                 numFPpoints + numFNpoints + numTNpoints)

        statis.precision   = numTPpoints / (numTPpoints + numFPpoints)
        statis.sensitivity = numTPpoints / (numTPpoints + numFNpoints)
        statis.specificity = numTNpoints / (numFPpoints + numTNpoints)

        statis.recall      = statis.sensitivity;
        statis.Fscore      =  2 * numTPpoints / (2 * numTPpoints + ...
                                    numFPpoints + numFNpoints);

        statis.c             = c;
        statis.cm            = cm;
        statis.ind           = ind;
        statis.per           = per;
        
        figure;
        plotconfusion(realTestTargets, realTestOutputs, 'testing');
        figure;
        plot(realTestOutputs(1, :), '*-');
        hold on;
        plot(realTestTargets(1, :), 'r');
        xlabel('data point index');
        ylabel('output / target');
        legend('Output of Neural network before setting threshold.', ...
            'Target value', 'location', 'northoutside');
        hold off;
    end
end

