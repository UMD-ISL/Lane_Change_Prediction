%% Initialization and Configuration
clear all; clc;     % Clear environment, and start counting running time
[Data_Path, Output_Path] = loadGlobalPathSetting();
synchronization_1_Output = createOutputFolder(Output_Path, 'synchronization_1_Output');

%%
num_folder = getFolderNumber(Data_Path);

for videoIndex = 1:num_folder
    %%
    inputData = readPhysiSignalDataFiles(Data_Path, Output_Path, videoIndex);
    
    %%
    inputData = checkDataTimestampError(inputData);
    
    %%
    inputData = readLabelResultFile(inputData, Data_Path, videoIndex);
    
    %%
    inputData = createHeaderInfo(inputData);
    
    %%
    inputData = eliminateNanData(inputData);
    
    %%
%     timeShiftingProcess(inputData, Output_Path, videoIndex);
    
    %%
    synBefDenoisedData = inputData;
    save(strcat(synchronization_1_Output, '/Video_', num2str(videoIndex), ...
        '_Before_Denoised_Data.mat'), 'synBefDenoisedData');
end         % end of program




