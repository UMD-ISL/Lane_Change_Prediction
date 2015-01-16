function BELT_RAW_start_Time = BELT_RAW_StartTime_Generator(BELT_RAW_filepath)
    % read Belt.csv file # 7
    [Data, Header, ~]   = xlsread(BELT_RAW_filepath);
    % find the column number of Timestamp
    [~, index] = ismember('Timestamp', Header);
    % convert double format to string format
    BELT_RAW_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
end