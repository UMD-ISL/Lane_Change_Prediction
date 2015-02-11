function inputData = readPhysiSignalDataFiles(Data_Path, Output_Path, videoIndex)
    
    %%
    foo = load(strcat(Output_Path, '/', 'Start_time_reference.mat'));
    Start_time_reference = foo.Start_time_reference;
    GSR_RAW_start_Time   = Start_time_reference{5, videoIndex};
    
    %% Read GSR Data
    % [GSR | SCL | SCR | Timestamp | Duration]
    [inputData.Gsr_Data, inputData.Gsr_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/GSR.csv'));
    
    %% Read ECG Data
    % [HR | RR | Timestamp | Duration]
    [inputData.Ecg_Data, inputData.Ecg_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/ECG.csv'));  
    
    %% Read RSP Data
    % [Exp Vol | Insp Vol | qDEEL | Resp Rate | Resp Rate Inst | Te | Ti ... 
    %  Ti/Te |Ti/Tt | Tpef/Te | Tt | Vent | Vt/Ti | Work of Breathing | ...
    %  Timestamp | Duration]
    [inputData.Rsp_Data, inputData.Rsp_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/RSP.csv'));
    inputData.Rsp_Txt = inputData.Rsp_Txt(1,:);
    
    %% Read GSR_RAW Data
    % [DateTime | GSR (raw) | GSR (microSiemens)]
    [inputData.GSR_RAW_Data, inputData.GSR_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/GSR_RAW.csv'));
    inputData.GSR_RAW_Data = GsrRAWtimeCorection(inputData.GSR_RAW_Data, ...
                                                 inputData.GSR_RAW_Txt, ...  
                                                    GSR_RAW_start_Time);
                                                
    %% Read ECG_RAW Data
    % [SEM_ecg1 | SEM_ecg2 | Timestamp | Duration]
    [inputData.ECG_RAW_Data, inputData.ECG_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/ECGraw.csv'));

    %% Read Belt Data
    % [SEM_belt | Timestamp | Duration]
    [inputData.BELT_RAW_Data, inputData.BELT_RAW_Txt] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/RSPraw.csv'));
    
end