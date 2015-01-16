function ECG_start_Time = ECG_StartTime_Generator(ECG_filepath)
    % read ECG.csv file  # 2
    [Data, Header, ~] = xlsread(ECG_filepath);
    % find the column number of Timestamp
    [~, index]  = ismember('Timestamp', Header);
    ECG_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
end