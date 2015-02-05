function inputData = readPhysiSignalDataFiles(Data_Path, videoIndex)

    % Read GSR Data
    [inputData.Gsr_Data, inputData.Gsr_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/GSR.csv'));
    
    inputData.Gsr_Txt(:, [1, 2, 3, 4, 5])  = ...
        inputData.Gsr_Txt(:, [4, 1, 2, 3, 5]);
    inputData.Gsr_Data(:, [1, 2, 3, 4, 5]) = ...
        inputData.Gsr_Data(:, [4, 1, 2, 3, 5]);
    
    % Read ECG Data
    [inputData.Ecg_Data, inputData.Ecg_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/ECG.csv'));
    
    inputData.Ecg_Txt(:, [1, 2, 3, 4]) = inputData.Ecg_Txt(:, [3, 1, 2, 4]);
    inputData.Ecg_Data(:, [1, 2, 3, 4]) = inputData.Ecg_Data(:, [3, 1, 2, 4]);
    
    % Read RSP Data
    [inputData.Rsp_Data, inputData.Rsp_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/RSP.csv'));
    
    
    % Read GSR_RAW Data
    [inputData.GSR_RAW_Data, inputData.GSR_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/GSR_RAW.xlsx'));
    
    % Read ECG_RAW Data
    [inputData.ECG_RAW_Data, inputData.ECG_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/ECGraw.csv'));
    
    inputData.ECG_RAW_Txt(:, [1, 2, 3]) = inputData.ECG_RAW_Txt(:, [3, 1, 2]);
    inputData.ECG_RAW_Data(:, [1, 2, 3]) = inputData.ECG_RAW_Data(:, [3, 1, 2]);
    
    
    % Read Belt Data
    [inputData.BELT_RAW_Data, inputData.BELT_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/RSPraw.csv'));
    
    inputData.BELT_RAW_Txt(:, [1, 2])  = inputData.BELT_RAW_Txt(:, [2, 1]);
    inputData.BELT_RAW_Data(:, [1, 2]) = inputData.BELT_RAW_Data(:, [2, 1]);
    
end