function preprocessData()
    
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
        
    folderFiles = dir(strcat(outputPath, '/dataPreparationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'prepedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    prepedDataFilesName = folderFilesName(DataFileIndex);
    numPrepedDataFiles = size(prepedDataFilesName, 2);

    %% ========= start processing each physiological data ============
    for i = 1:numPrepedDataFiles
        fprintf('load prpred data file collection: %d\n', i);
        PrepedDataFilePath = strcat(outputPath, '/dataPreparationOutput/', ...
            prepedDataFilesName{1, i});
        
        load(PrepedDataFilePath);
        recordDate = prepedOBD.startDate;
        absoluteTime = datenum([recordDate, ' ', prepedOBD.startTime]);
        timeDelay = 0.000;
        vidStartTime = absoluteTime + timeDelay / 86400;
        
        preprocTarget.data = zeros(size(prepedTarget.data));
        for j = 1:size(prepedTarget.data, 1)
            preprocTarget.data(j, 1) = vidStartTime + ...
                        datenum([recordDate, ' ', prepedTarget.data{j, 1}]) - ...
                        datenum([recordDate, ' ', '00:00:00.000']);
        end
        preprocTarget.data(:, 2) = str2double(prepedTarget.data(:, 2));
        
        %%
        [prepedGSR.params, prepedGSR.data] = strcell2number(prepedGSR.params, ...
                                                prepedGSR.data, recordDate);
        
        [prepedECG.params, prepedECG.data] = strcell2number(prepedECG.params, ...
                                                prepedECG.data, recordDate);
        
        [emptyLocationX, emptyLocationY] = find(ismember(prepedRSP.data, '')==1);
        prepedRSP.data(emptyLocationX, emptyLocationY) = cellstr('NaN');
        
        [prepedRSP.params, prepedRSP.data] = strcell2number(prepedRSP.params, ...
                                                prepedRSP.data, recordDate);
                                            
        [prepedGSRraw.params, prepedGSRraw.data] = strcell2number(prepedGSRraw.params, ...
                                                prepedGSRraw.data, recordDate);
        
        [prepedECGraw.params, prepedECGraw.data] = strcell2number(prepedECGraw.params, ...
                                                prepedECGraw.data, recordDate);

        [prepedRSPraw.params, prepedRSPraw.data] = strcell2number(prepedRSPraw.params, ...
                                                prepedRSPraw.data, recordDate);
                                            

    end
    
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