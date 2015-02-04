function BELT_RAW_start_Time = BELT_RAW_StartTime_Generator(BELT_RAW_filepath)
    % read Belt.csv file # 7
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';

    fid = fopen(BELT_RAW_filepath);
    
    BELT_RAW_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            BELT_RAW_start_Time = datestr(reg_time{1, 1}, 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end