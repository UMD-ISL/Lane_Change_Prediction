function sigStartTime = getSigStartTime(sigParamsVector, sigData)
    [~, timeIndex] = ismember({'Timestamp'; 'DateTime'}, sigParamsVector);
    timeColumn = timeIndex(0 ~= timeIndex);
    sigStartTimeString = sigData{1, timeColumn};
    
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';
    sigStartTime = cell2mat(regexp(sigStartTimeString, timeformat, 'match'));
end