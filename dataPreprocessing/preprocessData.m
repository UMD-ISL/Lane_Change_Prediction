function preprocessData()
    
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [homePath, dataRootPath, outputPath] = loadGlobalPathSetting(configFile);
        
    folderFiles = dir(strcat(outputPath, '/dataPreparationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'prepedData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    prepedDataFilesName = folderFilesName(DataFileIndex);
    numPrepedDataFiles = size(prepedDataFilesName, 2);

    %%
    for i = 1:numPrepedDataFiles
        fprintf('load prpred data file collection: %d\n', i);
        PrepedDataFilePath = strcat(outputPath, '/dataPreparationOutput/', ...
            prepedDataFilesName{1, i});
        
        load(PrepedDataFilePath);
        
        recordDate = prepedOBD.startDate;
        OBDstartTime = [prepedOBD.startDate, ' ', prepedOBD.startTime];
        
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
        %%
        % first ignore the time duration column
        
        % second translate all the physiological data into double (if need
        % trip start date, please look into OBD data.)
    end
end