function [tempSigParams, tempSigData] = strcell2number(sigParamsVector, ...
                                            sigData, recordDate)
    [~, timeIndex] = ismember({'Timestamp'; 'DateTime'}, sigParamsVector);
    timeColumn = timeIndex(0 ~= timeIndex);
    
    [sigDataParams, ~] = ismember(sigParamsVector, {'Timestamp', 'DateTime', 'Duration'});
    tempSigParams = {'Timestamp', sigParamsVector{~sigDataParams}};

    if size(sigData{1, timeColumn}, 2) < 20
        tempSigData = [datenum(strcat(recordDate, {' '}, ...
                            sigData(:, timeColumn))) ...
                            cellfun(@str2num, sigData(:, ~sigDataParams))];
    else
        tempSigData = [datenum(sigData(:, timeColumn)) ...
                            cellfun(@str2num, sigData(:, ~sigDataParams))];
    end
    
    if ismember({'GSR (raw)'}, sigParamsVector);
        for i = 1:size(tempSigData, 1)
            tempSigData(i, 1) = addtodate(tempSigData(i, 1), 4, 'hour');
        end
    end
end