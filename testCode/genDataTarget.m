function [datasetInput, datasetTarget] = genDataTarget(eventList)
    
    eventList = shuffleDataset(eventList);
    numFeatures     = size(eventList{1, 4}, 2) - 2;
    numEventPoints  = size(eventList{1, 4}, 1);
    
    numEvents = size(eventList, 1);
    datasetInput = zeros(numFeatures, numEvents * numEventPoints);
    datasetTarget = zeros(2, numEvents * numEventPoints);
    
    for i = 1 : numEvents
        datasetInput(:, (i - 1) * numEventPoints + 1 : i * numEventPoints) ...
                        = eventList{i, 4}(:, 3:end)';
        datasetTarget(:, (i - 1) * numEventPoints + 1 : i * numEventPoints) ...
                        = [mod(eventList{i, 4}(:, 2)', 2); ...
                            ~mod(eventList{i, 4}(:, 2)', 2)];
    end
    
end