function OBD_start_Date = getOBDstartDate(fid)
    dateformat = '[0-9]+/[0-9]+/[0-9]+';
    OBD_start_Date = [];
    lineText = fgetl(fid);
    
    while ~isequal(lineText, -1)
        reg_date = regexp(lineText, dateformat, 'match');
        if ~isempty(reg_date)
            OBD_start_Date = cell2mat(reg_date);
            break;
        end
        lineText = fgetl(fid);
    end
end