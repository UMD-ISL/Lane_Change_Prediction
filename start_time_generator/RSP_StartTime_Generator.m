function RSP_start_Time = RSP_StartTime_Generator(RSP_filepath)
    % read RSP.csv file  # 3
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';

    fid = fopen(RSP_filepath);
    
    RSP_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            RSP_start_Time = datestr(reg_time{1, 1}, 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end

