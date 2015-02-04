function ECG_RAW_start_Time = ECG_RAW_StartTime_Generator(ECG_RAW_filepath)
    % read ECGRaw.csv file # 5
    timeformat          = '[0-9]+:[0-9]+:[0-9]+.[0-9]+';

    fid = fopen(ECG_RAW_filepath);
    
    ECG_RAW_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            ECG_RAW_start_Time = datestr(reg_time{1, 1}, 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end

