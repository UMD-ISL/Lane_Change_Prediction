function GSR_start_Time = GSR_StartTime_Generator(GSR_filepath)
    % read GSR.csv file  # 1
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';

    fid = fopen(GSR_filepath);
    
    GSR_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            GSR_start_Time = datestr(reg_time{1, 1}, 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end