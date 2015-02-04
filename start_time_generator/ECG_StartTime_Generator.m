function ECG_start_Time = ECG_StartTime_Generator(ECG_filepath)
    % read ECG.csv file  # 2
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';

    fid = fopen(ECG_filepath);
    
    ECG_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            ECG_start_Time = datestr(reg_time{1, 1}, 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end