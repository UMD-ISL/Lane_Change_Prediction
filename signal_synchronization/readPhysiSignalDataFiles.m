sfunction inputData = readPhysiSignalDataFiles(Data_Path, videoIndex)

    % Read GSR Data
    % [GSR | SCL | SCR | Timestamp | Duration]
    [inputData.Gsr_Data, inputData.Gsr_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/GSR.csv'));
    
    % Read ECG Data
    % [HR | RR | Timestamp | Duration]
    [inputData.Ecg_Data, inputData.Ecg_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/ECG.csv'));  
    
    % Read RSP Data
    % [Exp Vol | Insp Vol | qDEEL | Resp Rate | Resp Rate Inst | Te | Ti ... 
    %  Ti/Te |Ti/Tt | Tpef/Te | Tt | Vent | Vt/Ti | Work of Breathing | ...
    %  Timestamp | Duration]
    [inputData.Rsp_Data, inputData.Rsp_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/RSP.csv'));
    
    % Read GSR_RAW Data
    % [DateTime | GSR (raw) | GSR (microSiemens)]
    [inputData.GSR_RAW_Data, inputData.GSR_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/GSR_RAW.csv'));
    
    % Read ECG_RAW Data
    % [SEM_ecg1 | SEM_ecg2 | Timestamp | Duration]
    [inputData.ECG_RAW_Data, inputData.ECG_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/ECGraw.csv'));

    % Read Belt Data
    % [SEM_belt | Timestamp | Duration]
    [inputData.BELT_RAW_Data, inputData.BELT_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/RSPraw.csv'));
    
end