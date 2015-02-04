function OBD_start_Time = OBD_StartTime_Generator(OBD_filepath)
    % read OBD.csv file  # 4

    timeformat          = '[0-9]+:[0-9]+:[0-9]+ (PM|AM)';

    fid = fopen(OBD_filepath);
	
	OBD_start_Time = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_time = regexp(lineText, timeformat, 'match');
        if ~isempty(reg_time)
            OBD_start_Time = datestr(cell2mat(reg_time), 'HH:MM:SS.FFF');
            break;
        end
        lineText = fgetl(fid);
    end
    fclose(fid);
end