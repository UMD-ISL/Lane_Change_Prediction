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
        temp = zeros(size(sigData(:, 1)));
        for i = 1:size(sigData, 1)
            temp(i) = addtodate(datenum(sigData(i, timeColumn)), 4, 'hour');
        end
        tempSigData = [temp cellfun(@str2num, sigData(:, ~sigDataParams))];
    end
end