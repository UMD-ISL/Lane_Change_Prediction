function eventList = eventSearch(DataList, targetColumn, ...
                                    eventPattern, datasetInd)
                                
     eventStartIdx = strfind(DataList(:,targetColumn)', ...
                            eventPattern');
    % add comments here
    eventList = cell(length(eventStartIdx), 3);
    for j = 1:length(eventStartIdx)
        eventList(j, :) = {strcat('video_', num2str(datasetInd)), ...
                            eventStartIdx(j), ...
                        DataList(eventStartIdx(j):eventStartIdx(j)+19, :)}; 
    end
end