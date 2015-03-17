function cleanData()
    clear -except procDatasetStruct; clc;     % Clear environment, and start counting running time
    close all;
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    dataCleanOutput = createOutputFolder(outputPath, 'dataCleanOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataPreprocessOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'preprocData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    procDataFilesName = folderFilesName(DataFileIndex);
    numProcDataFiles = size(procDataFilesName, 2);
    
    [ allGSRdata, allECGdata, allRSPdata, ...
           allGSRrawData, allECGrawData, ...
           allRSPrawData, allTarget] = loadpreprocDataset(outputPath, ...
                                      numProcDataFiles, procDataFilesName);

    %% ================ Deal with GSR signal =======================
    [cleanedGSRdata, statis.GSR.valMean, statis.GSR.valStd] = ...
                                                cleanOneSig(allGSRdata);
    
    %% ================ Deal with ECG signal =======================
    [cleanedECGdata, statis.ECG.valMean, statis.ECG.valStd] = ...
                                                cleanOneSig(allECGdata);
    
    %% ================ Deal with RSP signal =======================
    [cleanedRSPdata, statis.RSP.valMean, statis.RSP.valStd] = ...
                                                cleanOneSig(allRSPdata);
    
    %% ================ Deal with GSR signal =======================
    [cleanedGSRrawData, statis.GSRraw.valMean, statis.GSRraw.valStd] = ...
                                                cleanOneSig(allGSRrawData);
    
    %% ================ Deal with ECG signal =======================
    [cleanedECGrawData, statis.ECGraw.valMean, statis.ECGraw.valStd] = ...
                                                cleanOneSig(allECGrawData);
    
    %% ================ Deal with RSP signal =======================
    [cleanedRSPrawData, statis.RSPraw.valMean, statis.RSPraw.valStd] = ...
                                                cleanOneSig(allRSPrawData);
    
    savefile = strcat(dataCleanOutput, '/signalStatistics.mat');
    save(savefile, 'statis');
    
    for i = 1:numProcDataFiles
        savefile = strcat(dataCleanOutput, '/cleanedData_', num2str(i), '.mat');
        cleanedGSR      = cleanedGSRdata(i);
        cleanedECG      = cleanedECGdata(i);
        cleanedRSP      = cleanedRSPdata(i);
        cleanedGSRraw   = cleanedGSRrawData(i);
        cleanedECGraw   = cleanedECGrawData(i);
        cleanedRSPraw   = cleanedRSPrawData(i);
        cleanedTarget   = allTarget(i);
        save(savefile, 'cleanedGSR', 'cleanedECG', 'cleanedRSP', ...
                    'cleanedGSRraw', 'cleanedECGraw', 'cleanedRSPraw', ...
                    'cleanedTarget');
    end
end