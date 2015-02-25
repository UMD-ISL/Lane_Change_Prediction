function dataPreprocessing()
    
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [homePath, dataRootPath, outputPath] = loadGlobalPathSetting(configFile);
        
    folderFiles = dir(strcat(outputPath, '/dataPreparationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'prepedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    prepedDataFilesName = folderFilesName(DataFileIndex);
    numPrepedDataFiles = size(prepedDataFilesName, 2);
    
    for i = 1:numPrepedDataFiles
        fprintf('load prpred data file collection: %d\n', i);
        PrepedDataFilePath = strcat(outputPath, '/dataPreparationOutput/', ...
            prepedDataFilesName{1, i});
        
        prepedData = loadData(PrepedDataFilePath);
    end
    
end