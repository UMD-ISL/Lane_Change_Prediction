function parPreprocessData()
    
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    dataPreprocessOutput = createOutputFolder(outputPath, 'dataPreprocessOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataPreparationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'prepedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    prepedDataFilesName = folderFilesName(DataFileIndex);
    numPrepedDataFiles = size(prepedDataFilesName, 2);
        
    %% =============== part 1 =====================
    tic;
    spmd (numPrepedDataFiles)
        fprintf('load prpred data file collection: %d\n', labindex);
        PrepedDataFilePath = strcat(outputPath, '/dataPreparationOutput/', ...
            prepedDataFilesName{1, labindex});
        
        bar = load(PrepedDataFilePath);
        savefile = strcat(dataPreprocessOutput, '/preprocData_', ...
                    num2str(labindex), '.mat');
                
        convertDataFormat(bar, savefile);
    end
    toc;
    
    %% =============== Part 2 =====================
    bar = load(strcat(outputPath, '/dataPreparationOutput/startTimeTable.mat'));
    startTimeTable = bar.startTimeTable;
    numStartTimeTable = zeros(size(startTimeTable));
    for i = 1:size(startTimeTable, 1)
        numStartTimeTable(i, :) = datenum(startTimeTable(i, :));
    end
    savefile = strcat(dataPreprocessOutput, '/numStartTimeTable.mat');
    save(savefile, 'numStartTimeTable');

    bar = load(strcat(outputPath, '/dataPreparationOutput/endTimeTable.mat'));
    endTimeTable = bar.endTimeTable;
    numEndTimeTable = zeros(size(endTimeTable));
    for i = 1:size(startTimeTable, 1)
        numEndTimeTable(i, :) = datenum(endTimeTable(i, :));
    end
    savefile = strcat(dataPreprocessOutput, '/numEndTimeTable.mat');
    save(savefile, 'numEndTimeTable');
end