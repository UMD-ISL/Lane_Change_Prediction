function GSR_RAW_start_Time = GSR_RAW_StartTime_Generator(GSR_RAW_filepath)
    % read GSR_Raw.csv file # 6
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';

    fid = fopen(GSR_RAW_filepath);
    
    GSR_RAW_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            GSR_RAW_start_Time = datestr(reg_time{1, 1}, 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end