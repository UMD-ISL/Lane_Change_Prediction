function selectSignals()
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    signalSelectionOutput = createOutputFolder(outputPath, ...
                                            'signalSelectionOutput');
    
    %% =====
    folderFiles = dir(strcat(outputPath, '/dataSynchronizationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'synchronizedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    syncDataFilesName = folderFilesName(DataFileIndex);
    numSyncDataFiles = size(syncDataFilesName, 2);
    
    %% ==
    slectedSignals = {'GSR', 'HR', 'Te', 'Ti', 'Exp Vol', 'Insp Vol', ...
                        'qDEL', 'SEM_ecg1', 'SEM_belt'};
    
    %% ==
    for i = 1:numSyncDataFiles
        syncDataFilePath = strcat(outputPath, '/dataSynchronizationOutput/', ...
            syncDataFilesName{1, i});
        barData = load(syncDataFilePath);
        
        signalsVector = {barData.syncTarget.params, ... 
                            barData.syncGSR.params(2:end), ...
                            barData.syncECG.params(2:end), ...
                            barData.syncRSP.params(2:end), ...
                            barData.syncGSRraw.params(2:end), ...
                            barData.syncECGraw.params(2:end), ...
                            barData.syncRSPraw.params(2:end)
                            };
        
    end
    
end