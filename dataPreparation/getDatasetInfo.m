function [numRecordData, nameRecordData] = getDatasetInfo(dataPath)
    dirInfo = dir(dataPath);
    numRecordData   = size(dirInfo, 1) - 2;
    nameRecordData = cell(1, numRecordData);
    for i = 1:numRecordData
        nameRecordData(1, i) = cellstr(dirInfo(i+2).name);
    end
end