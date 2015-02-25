function dataSynchronization()
    
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [homePath, dataRootPath, outputPath] = loadGlobalPathSetting(configFile);
    addpath(genpath(homePath)); % only for debug
    
    folderFiles = dir(strcat(outputPath, '/dataPreparationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'prepedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    prepedData = prepedDataFilesName(DataFileIndex);
    
end