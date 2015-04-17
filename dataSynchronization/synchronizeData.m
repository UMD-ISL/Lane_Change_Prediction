function synchronizeData()
    %% preamble
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    dataSynchronizationOutput = createOutputFolder(outputPath, ...
                                            'dataSynchronizationOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataCleanOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'cleanedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    cleanedDataFilesName = folderFilesName(DataFileIndex);
    numCleanedDataFiles = size(cleanedDataFilesName, 2);
    
    bar = load(strcat(outputPath, '/dataPreprocessOutput/numStartTimeTable.mat'));
    numStartTimeTable = bar.numStartTimeTable;
    
    bar = load(strcat(outputPath, '/dataPreprocessOutput/numEndTimeTable.mat'));
    numEndTimeTable = bar.numEndTimeTable;
    
    tic;
    for i = 1:numCleanedDataFiles
        
        cleanedDataFilePath = strcat(outputPath, '/dataCleanOutput/', ...
            cleanedDataFilesName{1, i});
        
        [~, name, ~] = fileparts(cleanedDataFilePath);
        expression = '_';
        splitStr = regexp(name, expression,'split');
        savefile = strcat(dataSynchronizationOutput, '/', ...
                        strrep(name, splitStr{1}, 'synchronizedData'), '.mat');
        
        fprintf('load cleaned data file collection: %s\n', name);
                
        comStartTime = max(numStartTimeTable(i, :));
        fprintf(datestr(comStartTime, 'mm/dd/yyyy HH:MM:SS.FFF\n'));
        comEndTime = min(numEndTimeTable(i, :));
        fprintf(datestr(comEndTime, 'mm/dd/yyyy HH:MM:SS.FFF\n'));

        barData = load(cleanedDataFilePath);
        
        %% ========== core function: interpolate data into 10 Hz ==========
        interpData(barData, comStartTime, comEndTime, savefile);
    end
    toc;
end