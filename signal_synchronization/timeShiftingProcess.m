function timeShiftingProcess(inputData, Output_Path, videoIndex)

    foo = load(strcat(Output_Path, '/', 'Start_time_reference.mat'));
    Start_time_reference = foo.Start_time_reference;

    inputData.GSR_start_Time        = Start_time_reference{1, videoIndex};
    inputData.ECG_start_Time        = Start_time_reference{2, videoIndex};
    inputData.RSP_start_Time        = Start_time_reference{3, videoIndex};
    inputData.ECG_RAW_start_Time    = Start_time_reference{4, videoIndex};
    inputData.GSR_RAW_start_Time    = Start_time_reference{5, videoIndex};
    inputData.BELT_RAW_start_Time   = Start_time_reference{6, videoIndex};
    
    inputData.Rsp_Data(:,1) = inputData.Rsp_Data(1:end,1) - inputData.Rsp_Data(1,1);
    % delete date information, only reserve hour, minute, second
    % information
    Rsp_Data(:,1)       = Rsp_Data(:,1) + datenum(RSP_start_Time) ...
                            - floor(datenum(RSP_start_Time));
    Gsr_Data(:,1)       = Gsr_Data(1:end,1) - Gsr_Data(1,1);
    Gsr_Data(:,1)       = Gsr_Data(:,1) + datenum(GSR_start_Time) ...
                            - floor(datenum(GSR_start_Time));

    Ecg_Data(:, 1)       = Ecg_Data(1:end, 1) - Ecg_Data(1, 1);
    Ecg_Data(:, 1)       = Ecg_Data(:, 1) + datenum(ECG_start_Time) ...
                            - floor(datenum(ECG_start_Time));

    ECG_RAW_Data(:, 3)   = ECG_RAW_Data(1:end, 1) - ECG_RAW_Data(1, 1);
    ECG_RAW_Data(:, 3)   = ECG_RAW_Data(:, 1) + datenum(ECG_RAW_start_Time) ...
                            - floor(datenum(ECG_RAW_start_Time));

    GSR_RAW_Data(:, 1)   = GSR_RAW_Data(1:end, 1) - GSR_RAW_Data(1, 1);
    GSR_RAW_Data(:, 1)   = GSR_RAW_Data(:, 1) + datenum(GSR_RAW_start_Time) ...
                            - floor(datenum(GSR_RAW_start_Time));

    BELT_RAW_Data(:, 2)  = BELT_RAW_Data(1:end, 1) - BELT_RAW_Data(1, 1);
    BELT_RAW_Data(:, 2)  = BELT_RAW_Data(:, 1) + datenum(BELT_RAW_start_Time) ...
                            - floor(datenum(BELT_RAW_start_Time));
end