function examineData()
    clear all; clc;     % Clear environment, and start counting running time
    close all;
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    dataExaminationOutput = createOutputFolder(outputPath, 'dataExaminationOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataSynchronizationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'synchronizedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    syncDataFilesName = folderFilesName(DataFileIndex);
    numSyncDataFiles = size(syncDataFilesName, 2);
    
    for i = 1:numSyncDataFiles
        % plot GSR singal
        syncDataFilePath = strcat(outputPath, '/dataSynchronizationOutput/', ...
            syncDataFilesName{1, i});
        barData = load(syncDataFilePath);
        
        syncTarget = barData.syncTarget;
        targetData = syncTarget.data(:, 2);
        
        % GSR signal
        syncGSR = barData.syncGSR;
        syncGSRparams = syncGSR.params;
        % plot each column of GSR signal
        plotSaveSigFig(syncGSRparams, syncGSR, targetData, i, ...
                dataExaminationOutput);
        
        % ECG signal
        syncECG = barData.syncGSR;
        syncECGparams = syncECG.params;
        % plot each column of GSR signal
        plotSaveSigFig(syncECGparams, syncECG, targetData, i, ...
            dataExaminationOutput);
        
        % RSP signal
        syncRSP = barData.syncRSP;
        syncRSPparams = syncRSP.params;
        % plot each column of GSR signal
        plotSaveSigFig(syncRSPparams, syncRSP, targetData, i, ...
            dataExaminationOutput);
        
        % GSRraw signal
        syncGSRraw = barData.syncGSRraw;
        syncGSRrawParams = syncGSRraw.params;
        % plot each column of GSR signal
        plotSaveSigFig(syncGSRrawParams, syncGSRraw, targetData, i, ...
            dataExaminationOutput);
        
        % ECG signal
        syncECGraw = barData.syncECGraw;
        syncECGrawParams = syncECGraw.params;
        % plot each column of GSR signal
        plotSaveSigFig(syncECGrawParams, syncECGraw, targetData, i, ...
            dataExaminationOutput);
        
        % RSP signal
        syncRSPraw = barData.syncRSPraw;
        syncRSPrawParams = syncRSPraw.params;
        % plot each column of GSR signal
        plotSaveSigFig(syncRSPrawParams, syncRSPraw, targetData, i, ...
            dataExaminationOutput);    
    end
end