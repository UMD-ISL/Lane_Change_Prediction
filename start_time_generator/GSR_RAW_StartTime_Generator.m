function GSR_RAW_start_Time = GSR_RAW_StartTime_Generator(GSR_RAW_filepath)
    % read GSRRaw.csv file # 6
    [Data, Header, ~]   =  xlsread(GSR_RAW_filepath);
    [~, index]  = ismember('Time', Header);
    % convert double format to string format
    Data(1,index) = addtodate(Data(1,index), 4, 'hour');
    GSR_RAW_start_Time  = datestr(Data(1,index), 'HH:MM:SS.FFF');
end

