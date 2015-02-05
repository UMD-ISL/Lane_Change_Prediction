function eliminateNanData(temp_file)

    % load the data generated in Phase I
    load(temp_file);   % load temp data

    % Pre-process each signal: ECG signal
    % Ecg_Data(:, 4:5) = [];
    [R,~] = find(isnan(Ecg_Data));          % find the NAN value position
    Ecg_Data(R,:) = [];

    % Pre-process GSR signal
    [R,~] = find(isnan(Gsr_Data));          % find the NAN value position
    Gsr_Data(R,:) = [];

    % Pre-process RSP signal
    [R,~] = find(isnan(Rsp_Data));          % find the NAN value position
    Rsp_Data(R,:) = [];

    % Pre-process ECG_Raw signal
    [R,~] = find(isnan(ECG_RAW_Data));      % find the NAN value position
    ECG_RAW_Data(R,:)=[];

    % Pre-process GSR_RAW signal
    [R,~] = find(isnan(GSR_RAW_Data));      % find the NAN value position
    GSR_RAW_Data(R,:)=[];

    % Pre-process Belt signal
    [R,~] = find(isnan(BELT_RAW_Data));     % find the NAN value position
    BELT_RAW_Data(R,:)=[];

    save(temp_file, ...   % save temp data
        'Rsp_Data', 'Gsr_Data', 'Ecg_Data', 'Text_Index', ...
        'GSR_RAW_Data', 'ECG_RAW_Data', 'BELT_RAW_Data', ...
        'target_Data', 'm');
    
end