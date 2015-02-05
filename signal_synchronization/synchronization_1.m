%% Initialization and Configuration
clear all; clc;     % Clear environment, and start counting running time
[Data_Path, Output_Path] = loadGlobalPathSetting();
synchronization_1_Output = createOutputFolder(Output_Path, 'synchronization_1_Output');

%%
num_folder = getFolderNumber(Data_Path);

for videoIndex = 1:num_folder
    %% Processing each Signal data (Phase I)
   
    inputData = readPhysiSignalDataFiles(Data_Path, videoIndex);
    
    inputData = checkDataTimestampError(inputData);
    
    inputData = readLabelResultFile(inputData, Data_Path, videoIndex);

    inputData = createHeaderInfo(inputData);
    
    % Save the intermedia process result, NAME FORMAT is following below
    temp_file = strcat(synchronization_1_Output, '/Video_', num2str(videoIndex), '_temp_Data.mat');
    save(temp_file, ...   % save temp data
        'Rsp_Data', 'Gsr_Data', 'Ecg_Data', 'Text_Index', ...
        'GSR_RAW_Data', 'ECG_RAW_Data', 'BELT_RAW_Data', ...
        'target_Data', 'm');


    %% Processing each Signal data (Phase II)
    % eliminate the nan value in the data
    eliminateNanData(temp_file, Output_Path, synchronization_1_Output);
    
    timeShiftingProcess(temp_file, Output_Path);
    
    % save ouput file, NAME FORMAT: 'Video_#_Before_denoised_data.mat'
    % Too Lazy !!! you should find what data you want store, what is
    % redundant!!!
    load(temp_file);    % update processed data
    save(strcat(synchronization_1_Output, '/Video_', num2str(videoIndex), '_Before_Denoised_Data.mat'));
    delete(temp_file); % delete temp data
    
end         % end of program




