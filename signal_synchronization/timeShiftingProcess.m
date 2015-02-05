function timeShiftingProcess(temp_file, Output_Path)

    load(temp_file);   % load temp data
    load(strcat(Output_Path, '/', 'Start_time_reference.mat'));

    GSR_start_Time      = Start_time_reference{1, m};
    ECG_start_Time      = Start_time_reference{2, m};
    RSP_start_Time      = Start_time_reference{3, m};
    OBD_start_Time      = Start_time_reference{4, m};
    ECG_RAW_start_Time  = Start_time_reference{5, m};
    GSR_RAW_start_Time  = Start_time_reference{6, m};
    BELT_RAW_start_Time = Start_time_reference{7, m};
    
    Rsp_Data(:,1)       = Rsp_Data(1:end,1) - Rsp_Data(1,1);
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
    
    save(temp_file, ...   % save temp data
        'Rsp_Data', 'Gsr_Data', 'Ecg_Data', 'Text_Index', ...
        'GSR_RAW_Data', 'ECG_RAW_Data', 'BELT_RAW_Data', ...
        'target_Data', 'm');
end