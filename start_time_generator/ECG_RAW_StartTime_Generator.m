function ECG_RAW_start_Time = ECG_RAW_StartTime_Generator(ECG_RAW_filepath)
    % read ECGRaw.csv file # 5
    [Data, Header, ~]   = xlsread(ECG_RAW_filepath);
    % find the column number of Timestamp
    [~, index] = ismember('Timestamp', Header);
    % convert double format to string format
    ECG_RAW_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
end

