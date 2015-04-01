function parSynchronizeData()
    
    %%
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %% ================ read configuration file ===========================
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    dataSynchronizationOutput = createOutputFolder(outputPath, ...
                                    'dataSynchronizationOutput');
    
    %% ================ Find previous step's output data ==================
    folderFiles = dir(strcat(outputPath, '/dataCleanOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'cleanedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName, ...
                                                expression)));
    cleanedDataFilesName = folderFilesName(DataFileIndex);
    numCleanedDataFiles = size(cleanedDataFilesName, 2);
    
    %% ================= Load start time and end time table ===============
    bar = load(strcat(outputPath, ...
                    '/dataPreprocessOutput/numStartTimeTable.mat'));
    numStartTimeTable = bar.numStartTimeTable;
    
    bar = load(strcat(outputPath, ...
                    '/dataPreprocessOutput/numEndTimeTable.mat'));
    numEndTimeTable = bar.numEndTimeTable;
    
    %% ======== use spmd to paralleling process data ======================
    tic;    % start counting time
    spmd (numCleanedDataFiles)
        fprintf('load preprocess data file collection: %d\n', labindex);
        
        comStartTime = max(numStartTimeTable(labindex, :));
        fprintf(datestr(comStartTime, 'mm/dd/yyyy HH:MM:SS.FFF\n'));
        comEndTime = min(numEndTimeTable(labindex, :));
        fprintf(datestr(comEndTime, 'mm/dd/yyyy HH:MM:SS.FFF\n'));
        
        savefile = strcat(dataSynchronizationOutput, '/synchronizedData_', ...
                        num2str(labindex), '.mat');
        cleanedDataFilePath = strcat(outputPath, '/dataCleanOutput/', ...
            cleanedDataFilesName{1, labindex});
        barData = load(cleanedDataFilePath);
        
        %% ========== core function: interpolate data into 10 Hz ==========
        interpData(barData, comStartTime, comEndTime, savefile);
    end
    toc;    % end counting time
end