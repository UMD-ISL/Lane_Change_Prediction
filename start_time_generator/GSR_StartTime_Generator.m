function GSR_start_Time = GSR_StartTime_Generator(GSR_filepath)
    % read GSR.csv file  # 1
    [Data, Header, ~]   =  xlsread(GSR_filepath);
    % find the column number of Timestamp
    [~, index]  = ismember('Timestamp', Header);
    % convert double format to string format
    GSR_start_Time      = datestr(Data(1,index), 'HH:MM:SS.FFF');
    % 1: Signals.GSR
end