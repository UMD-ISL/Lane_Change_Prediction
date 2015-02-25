function inputData = checkDataTimestampError(inputData)

    % PROCESS GSR DATA
    if (inputData.Gsr_Data(1, 1) > 0.5) && (inputData.Gsr_Data(end,1) < 0.5)
        Reverse = find(inputData.Gsr_Data(:,1) < 0.5);
        inputData.Gsr_Data(Reverse,1) = inputData.Gsr_Data(Reverse,1) + 1;
    end

    % PROCESS ECG DATA
    if (inputData.Ecg_Data(1,1) > 0.5) && (inputData.Ecg_Data(end,1) < 0.5)
        Reverse = find(inputData.Ecg_Data(:,1) < 0.5);
        inputData.Ecg_Data(Reverse,1) = inputData.Ecg_Data(Reverse,1) + 1;
    end
    
    % PROCESS RSP DATA
    if (inputData.Rsp_Data(1,1) > 0.5) && (inputData.Rsp_Data(end,1) < 0.5)
        Reverse = find(inputData.Rsp_Data(:, 1) < 0.5);
        inputData.Rsp_Data(Reverse,1) = inputData.Rsp_Data(Reverse,1) + 1;
    end
    
    % PROCESS GSR_RAW DATA
    if (inputData.GSR_RAW_Data(1,1) > 0.5) && (inputData.GSR_RAW_Data(end,1) < 0.5)
        Reverse = find(inputData.GSR_RAW_Data(:,1) < 0.5);
        inputData.GSR_RAW_Data(Reverse,1) = inputData.GSR_RAW_Data(Reverse,1) + 1;
    end
    
    % PROCESS ECG_RAW DATA
    if (inputData.ECG_RAW_Data(1, 1) > 0.5) && (inputData.ECG_RAW_Data(end, 1) < 0.5)
        Reverse = find(inputData.ECG_RAW_Data(:, 1) < 0.5);
        inputData.ECG_RAW_Data(Reverse, 1) = inputData.ECG_RAW_Data(Reverse, 1) + 1;
    end
    
    % PROCESS BELT DATA
    if (inputData.BELT_RAW_Data(1, 1) > 0.5) && (inputData.BELT_RAW_Data(end, 1) < 0.5)
        Reverse = find(inputData.BELT_RAW_Data(:, 1) < 0.5);
        inputData.BELT_RAW_Data(Reverse, 1) = inputData.BELT_RAW_Data(Reverse, 1) + 1;
    end
end