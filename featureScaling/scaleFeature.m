function scaleFeature()
    clear all; clc;     % Clear environment, and start counting running time
    close all;
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    dataNormlizationOutput = createOutputFolder(outputPath, 'dataNormlizationOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataSynchronizationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'synchronizedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    syncDataFilesName = folderFilesName(DataFileIndex);
    numSyncDataFiles = size(syncDataFilesName, 2);
    
    rows = 0;
    for i = 1:numSyncDataFiles
        syncDataFilePath = strcat(outputPath, '/dataSynchronizationOutput/', ...
            syncDataFilesName{1, i});
        bar = load(syncDataFilePath);
        rows = row + size(bar.syncTarget.data, 1);
        syncDataset(i) = bar;
    end
    
    templateDataset = syncDataset(1);
    SigParams = [templateDataset.syncGSR.params(1, 2:end), ...
                    templateDataset.syncECG.params(1, 2:end), ...
                    templateDataset.syncRSP.params(1, 2:end), ...
                    templateDataset.syncRSP.params(1, 2:end), ...
                    templateDataset.syncRSP.params(1, 2:end), ...
                    templateDataset.syncRSP.params(1, 2:end)];
end