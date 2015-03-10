function parSynchronizeData()
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    dataSynchronizationOutput = createOutputFolder(outputPath, 'dataSynchronizationOutput');
    
    folderFiles = dir(strcat(outputPath, '/dataPreprocessOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'preprocData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    preprocDataFilesName = folderFilesName(DataFileIndex);
    numPreprocDataFiles = size(preprocDataFilesName, 2);
    
    bar = load(strcat(outputPath, '/dataPreprocessOutput/numStartTimeTable.mat'));
    numStartTimeTable = bar.numStartTimeTable;
    
    bar = load(strcat(outputPath, '/dataPreprocessOutput/numEndTimeTable.mat'));
    numEndTimeTable = bar.numEndTimeTable;
    
    tic;
    spmd (numPreprocDataFiles)
        fprintf('load prprocess data file collection: %d\n', labindex);
        
        comStartTime = max(numStartTimeTable(labindex, :));
%         fprintf(datestr(comStartTime, 'mm/dd/yyyy HH:MM:SS.FFF\n'));
        comEndTime = min(numEndTimeTable(labindex, :));
%         fprintf(datestr(comEndTime, 'mm/dd/yyyy HH:MM:SS.FFF\n'));
        
        savefile = strcat(dataSynchronizationOutput, '/synchronizedData_', ...
                        num2str(labindex), '.mat');
        PreprocDataFilePath = strcat(outputPath, '/dataPreprocessOutput/', ...
            preprocDataFilesName{1, labindex});
        barData = load(PreprocDataFilePath);
        
        interpData(barData, comStartTime, comEndTime, savefile);
    end
    toc;
    
end