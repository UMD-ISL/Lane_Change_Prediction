function realtimeData = geneRealtimeData(videoInd, segmentStartTime, ...
                                segmentEndTime)
                            
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    folderFiles = dir(strcat(outputPath, '/featureGenerationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'featureVector_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    featureVecFilesName = folderFilesName(DataFileIndex);
    
    featureVecFilePath = strcat(outputPath, '/featureGenerationOutput/', ...
            featureVecFilesName{1, videoInd});
    foo = load(featureVecFilePath);
    scaledFeatureVec = foo.scaledFeatureVec;
        
    bar = load(strcat(outputPath,'/dataPreprocessOutput/numStartTimeTable.mat'));
    numStartTimeTable = bar.numStartTimeTable;
    
    startTimestamp = (datenum([date ' ' segmentStartTime]) - datenum(date)) ...
            + numStartTimeTable(videoInd, end);
    datestr(startTimestamp, 'mm.dd.yyyy HH:MM:SS.FFF');
    
    endTimestamp = (datenum([date ' ' segmentEndTime]) - datenum(date)) ...
            + numStartTimeTable(videoInd, end);
    datestr(endTimestamp, 'mm.dd.yyyy HH:MM:SS.FFF');
    
    realtimeData = scaledFeatureVec(scaledFeatureVec(:, 1) >= startTimestamp & ...
                scaledFeatureVec(:, 1) <= endTimestamp, :);
end