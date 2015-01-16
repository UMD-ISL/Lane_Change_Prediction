function OBD_start_Time = OBD_StartTime_Generator(OBD_filepath)
    % read OBD.csv file  # 4
    [Data, Header, ~]   =  xlsread(OBD_filepath);
    timeformat          = '[0-9]+:[0-9]+:[0-9]+ (PM|AM)';
    reg_time            = regexp(Header{3,1}, timeformat, 'match');
    OBD_start_Time      = datestr(cell2mat(reg_time), 'HH:MM:SS.FFF');
end