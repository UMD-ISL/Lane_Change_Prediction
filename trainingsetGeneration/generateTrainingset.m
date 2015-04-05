function generateTrainingset()
    
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    TrainingsetOutput = createOutputFolder(outputPath, ...
                                            'TrainingsetOutput');
    
    folderFiles = dir(strcat(outputPath, '/featureGenerationOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'featureVector_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName, ...
                                            expression)));
    featureVecFilesName = folderFilesName(DataFileIndex);
    numFeatureVecFiles = size(featureVecFilesName, 2);
    
    lenEventWindow = 20;
    targetColumn = 2;
    LCeventList = [];
    LCeventPattern = repmat(1, lenEventWindow, 1);
    
    NLCeventList = [];
    NLCeventPattern = repmat(2, lenEventWindow, 1);
    
    for i = 1:numFeatureVecFiles
        featureVecFilePath = strcat(outputPath, '/featureGenerationOutput/', ...
            featureVecFilesName{1, i});
        
        bar = load(featureVecFilePath);
        scaledFeatureVec = bar.scaledFeatureVec;
        
        %% ================
        newLCeventList = eventSearch(scaledFeatureVec, targetColumn, ...
                                    LCeventPattern, i);

        newNLCeventList = eventSearch(scaledFeatureVec, targetColumn, ...
                                    NLCeventPattern, i);
        
        LCeventList = [LCeventList; newLCeventList];
        NLCeventList = [NLCeventList; newNLCeventList];
    end
    LCeventList = [num2cell(1:size(LCeventList, 1))', LCeventList];
    NLCeventList = [num2cell(1:size(NLCeventList, 1))', NLCeventList];
    
    save(strcat(TrainingsetOutput, '/LCeventList.mat'), 'LCeventList');
    save(strcat(TrainingsetOutput, '/NLCeventList.mat'), 'NLCeventList');
end