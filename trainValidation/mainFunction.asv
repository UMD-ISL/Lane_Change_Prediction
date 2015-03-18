function mainFunction()
    clear all; clc;     % Clear environment, and start counting running time
    
    configFile = '../preamble/configuration.ini';
    [~, ~, outputPath] = loadGlobalPathSetting(configFile);
    
    TrainingOutput = createOutputFolder(outputPath, ...
                                            'TrainingOutput');

    bar = load(strcat(outputPath, '/TrainingsetOutput/LCeventList.mat'));
    LCeventList = bar.LCeventList;
    
    bar = load(strcat(outputPath, '/TrainingsetOutput/NLCeventList.mat'));
    NLCeventList = bar.NLCeventList;
    
    %% ===================== configuration paramaeters =================
    posSampleRatio = 1/3; negSampleRatio = 2/3;
    trainingSampleRatio = 7/10; testingSampleRatio = 3/10;
    numCVfolder = 10;
    
    numPosTestingEvents = floor(size(LCeventList, 1) * testingSampleRatio);
    numPosValidateEvents = ceil(size(LCeventList, 1) * trainingSampleRatio ...
                            * 1/numCVfolder); 
    
    %% =====================
end