function parPrepareData()
    %% Initialization and Configuration
    clear all; clc;
    
    configFile = '../preamble/configuration.ini';
    [homePath, dataRootPath, outputPath] = loadGlobalPathSetting(configFile);
    addpath(genpath(homePath)); % only for debug
    
    mkdir_if_not_exist(outputPath);

    dataPreparationOutput = createOutputFolder(outputPath, 'dataPreparationOutput');

    %% Get information of Dataset
    disp('Get information of Dataset');
    [numRecordData, nameRecordData] = getDatasetInfo(dataRootPath);
    fprintf('Total number of record file collections is: %d\n', numRecordData);
    
    signalVector = {'GSR', 'ECG', 'RSP', ...
                    'GSRraw', 'ECGraw', 'RSPraw', ...
                    'OBD'};
    numSignal = size(signalVector, 2);

    %% Malloc memory size to store start info
    disp('Malloc memory size to store start info');
    tableStartTime = cell(numRecordData, numSignal);

    %%
    recordDataPathList = strcat(dataRootPath, '/', nameRecordData);

    try
        parpool;
    catch ME
    end
    
    tic;
    parfor i = 1:size(recordDataPathList, 2)
        fprintf('start analysising record files: %d\n', i);
        recordDataPath = cell2mat(recordDataPathList(1, i));
        [prepedGSR, prepedECG, prepedRSP, prepedGSRraw, prepedECGraw, ...
            prepedRSPraw, prepedOBD, prepedTarget] = analysisRecordFiles(recordDataPath, ...
                                                            signalVector);
        tableStartTime(i, :) = {prepedGSR.startTime, prepedECG.startTime, ...
                                prepedRSP.startTime, prepedGSRraw.startTime, ...
                                prepedECGraw.startTime, prepedRSPraw.startTime, ...
                                prepedOBD.startTime};
                            
        fprintf('start saving record files: %d\n', i);
        
        savefile = strcat(dataPreparationOutput, '/prepedData_', cell2mat(nameRecordData(1, i)), '.mat');
        parsave(savefile, prepedGSR, prepedECG, prepedRSP, ...
                        prepedGSRraw, prepedECGraw, ...
                        prepedRSPraw, prepedOBD, prepedTarget);
        
        fprintf('Finished saving record files %d\n', i);
        fprintf('Finished analysising record files: %d\n', i);
    end
    toc;
    
    disp('save start time reference table');
    saveTablefile = strcat(dataPreparationOutput, '/startTimeTable.mat');
    save(saveTablefile, 'tableStartTime');
    disp('Program finished');
    
    delete(gcp);
end