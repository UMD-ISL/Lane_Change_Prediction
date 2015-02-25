function labelingData = getLabelingdata(targetParams, labelingParams, fid)
    [~, targetIndex]  = ismember(targetParams, labelingParams);
    dataFormat = repmat('%s', 1, size(labelingParams, 2));
    
    temp = textscan(fid, dataFormat, 'delimiter', ',');
    labelingAllData = cell(size(temp{1, 1}, 1), size(temp, 2));
    for i=1:size(labelingParams, 2)
        labelingAllData(:, i) = temp{1, i};
    end
    
    labelingData = labelingAllData(:, targetIndex);
end
