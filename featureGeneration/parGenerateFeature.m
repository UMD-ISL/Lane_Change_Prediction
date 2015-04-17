function parGenerateFeature()
    
    clear all; clc;     % Clear environment, and start counting running time
    addpath(genpath('../utility/'));
    
    %%
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    featureGenerationOutput = createOutputFolder(outputPath, ...
                                            'featureGenerationOutput');
    
    folderFiles = dir(strcat(outputPath, '/signalSelectionOutput'));
    folderFilesName = {folderFiles.name};
    
    expression = 'selectedSignalData_*';
    DataFileIndex = ~cellfun(@isempty, (regexpi(folderFilesName,expression)));
    selectedSigFilesName = folderFilesName(DataFileIndex);
    numselectedSigDataFiles = size(selectedSigFilesName, 2);
    
    lenFeatureWindow = 20;
    featureVecParams = {'Instant Value', 'Maximum', 'Minimum', ...
                        'Difference', 'Standard Deviation', 'Mean', ...
                        'Median', 'Energy', 'Skewness', 'Kurtosis'};
                    
    
    parfor i = 1 : numselectedSigDataFiles
        selectedSigFilePath = strcat(outputPath, '/signalSelectionOutput/', ...
            selectedSigFilesName{1, i});
        
        [~, name, ~] = fileparts(selectedSigFilePath);
        expression = '_';
        splitStr = regexp(name, expression,'split');
        savefile = strcat(featureGenerationOutput, '/', ...
                        strrep(name, splitStr{1}, 'featureVector'), '.mat');
        
        bar = load(selectedSigFilePath);
        calFeatureVec(lenFeatureWindow, featureVecParams, ...
                                    bar.selectedSigsData, savefile);
    end
end