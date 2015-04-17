function parPreprocessData()
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    dataPreprocessOutput = createOutputFolder(outputPath, 'dataPreprocessOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataPreparationOutput'));
    folderFilesName = {folderFiles.name};
    
    % use regular expression to select the target files
    expression = 'prepedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    prepedDataFilesName = folderFilesName(DataFileIndex);
    numPrepedDataFiles = size(prepedDataFilesName, 2);
        
    %% ============== Convert cell matrix to double matrix ================
    tic;
    for i = 1 : numPrepedDataFiles
        fprintf('load prepred data file collection: %s\n', ...
                    prepedDataFilesName{1, i});
        PrepedDataFilePath = strcat(outputPath, '/dataPreparationOutput/', ...
            prepedDataFilesName{1, i});
        
        bar = load(PrepedDataFilePath);
        
        [~, name, ~] = fileparts(PrepedDataFilePath);
        expression = '_';
        splitStr = regexp(name, expression,'split');
        savefile = strcat(dataPreprocessOutput, '/', ...
                        strrep(name, splitStr{1}, 'preprocData'), '.mat');
        
        % self-designed function: convertDataFormat.m
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