function inputData = eliminateNanData(inputData)

    % Pre-process each signal: ECG signal
    % Ecg_Data(:, 4:5) = [];
    [R,~] = find(isnan(inputData.Ecg_Data));          % find the NAN value position
    inputData.Ecg_Data(R,:) = [];

    % Pre-process GSR signal
    [R,~] = find(isnan(inputData.Gsr_Data));          % find the NAN value position
    inputData.Gsr_Data(R,:) = [];

    % Pre-process RSP signal
    [R,~] = find(isnan(inputData.Rsp_Data));          % find the NAN value position
    inputData.Rsp_Data(R,:) = [];

    % Pre-process ECG_Raw signal
    [R,~] = find(isnan(inputData.ECG_RAW_Data));      % find the NAN value position
    inputData.ECG_RAW_Data(R,:)=[];

    % Pre-process GSR_RAW signal
    [R,~] = find(isnan(inputData.GSR_RAW_Data));      % find the NAN value position
    inputData.GSR_RAW_Data(R,:)=[];

    % Pre-process Belt signal
    [R,~] = find(isnan(inputData.BELT_RAW_Data));     % find the NAN value position
    inputData.BELT_RAW_Data(R,:)=[];
    
end