function [net, tr, logStatis] = crossValidFunction(NNconfigParamVec, ...
                                        trainValLCevents, LCindices, ...
                                        trainValNLCevents, ...
                                        NLCindices, numValFolder)
    
    totalTPpoints = 0; totalFNpoints = 0;
    totalFPpoints = 0; totalTNpoints = 0;
    
    logStatis = cell(1, numValFolder);
    
    rng('default');
    
    for k = 1:numValFolder
        
            oneNNstartTime = tic;
            
            valLCevents = trainValLCevents(k ~= LCindices, :);
            valNLCevents = trainValNLCevents(k  ~= NLCindices, :);
            valEventList = [valLCevents; valNLCevents];
            [trainInputs, trainTargets] = genDataTarget(valEventList);

            valLCevents = trainValLCevents(k == LCindices, :);
            valNLCevents = trainValNLCevents(k == NLCindices, :);
            valEventList = [valLCevents; valNLCevents];
            [valInputs, valTargets] = genDataTarget(valEventList);
            
            net = geneOneNN(NNconfigParamVec);
            net = configure(net,valInputs, valTargets);
            cell2mat(net.IW)
            
            initlay(net);
            cell2mat(net.IW)
            
            [net,tr] = train(net,trainInputs,trainTargets);
            cell2mat(net.IW)
           
            
            trainOutputs = net(trainInputs); % confusion matrix
            
            % Validate the Network
            valOutputs = net(valInputs);
%             errors = gsubtract(valTargets, valOutputs);
%             performance = perform(net, valTargets, valOutputs);
            
            [c, cm, ind, per] = confusion(valTargets, valOutputs);
            
            numTPpoints = cm(1, 1);  numFNpoints = cm(1, 2);
            numFPpoints = cm(2, 1);  numTNpoints = cm(2, 2);
            
            totalTPpoints = totalTPpoints + numTPpoints;
            totalFNpoints = totalFNpoints + numFNpoints;
            totalFPpoints = totalFPpoints + numFPpoints;
            totalTNpoints = totalTNpoints + numTNpoints;
            
            % the average accuracy is returned 
            stats.accuracy = (numTPpoints + numTNpoints)/(numTPpoints + ...
                                 numFPpoints + numFNpoints + numTNpoints);
            stats.precision   = numTPpoints / (numTPpoints + numFPpoints);
            stats.sensitivity = numTPpoints / (numTPpoints + numFNpoints);
            stats.specificity = numTNpoints / (numFPpoints + numTNpoints);
            stats.recall      = stats.sensitivity;
            stats.Fscore      =  2 * numTPpoints / (2 * numTPpoints + ...
                                            numFPpoints + numFNpoints);
            
            stats.c             = c;
            stats.cm            = cm;
            stats.ind           = ind;
            stats.per           = per;
            stats.net           = net;
            stats.tr            = tr;            

    %         figure, plotperform(tr)
    %         figure, plottrainstate(tr);
            figure;
            plotconfusion(trainTargets, trainOutputs, 'training', ...
                valTargets, valOutputs, 'validation');
            
            logStatis{k} = stats;
            
            oneNNduration = toc(oneNNstartTime);
    end
    
    totalStats.c = [totalTPpoints, totalFNpoints; totalFPpoints, totalTNpoints];
    totalStats.accuracy = (totalTPpoints + totalTNpoints)/(totalTPpoints + ...
                                 totalFPpoints + totalFNpoints + totalTNpoints);
    totalStats.precision   = totalTPpoints / (totalTPpoints + totalFPpoints);
    totalStats.sensitivity = totalTPpoints / (totalTPpoints + totalFNpoints);
    totalStats.specificity = totalTNpoints / (totalFPpoints + totalTNpoints);
    totalStats.recall      = totalStats.sensitivity;
    totalStats.Fscore      =  2 * totalTPpoints / (2 * totalTPpoints + ...
                                            totalFPpoints + totalFNpoints);
    
    logStatis = {totalStats, logStatis{:}};    
    %%
    % View the Network
    %     view(net)

    % Plots
    % Uncomment these lines to enable various plots.

%     figure, ploterrhist(errors)
end