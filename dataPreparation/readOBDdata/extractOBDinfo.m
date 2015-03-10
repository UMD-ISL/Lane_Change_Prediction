function OBD = extractOBDinfo(OBD_filepath)
    fid = fopen(OBD_filepath);
    OBD.dataRate = 100;
    OBD.startDate = getOBDstartDate(fid);
    OBD.startTime = getOBDstartTime(fid);
    OBD.initLocation = getOBDinitLocation(fid);
    headerString = fgetl(fid);
    OBD.params = getSigParamsHeader(headerString);
    OBD.targetParams = {'time [s]', 'speed [mph]', 'GPS long [degs]', ...
        'GPS lat [degs]'};
    OBD.data = getOBDdata(OBD.targetParams, OBD.params, fid);
    fclose(fid);
   
    numSeconds = floor(str2num(OBD.data{end, 1}));
    numMilliseconds = round(mod(str2num(OBD.data{end, 1}) * 100, 100));
    
    
    OBD.endTime = addtodate(datenum([OBD.startDate, ' ', OBD.startTime], ...
        'mm/dd/yyyy HH:MM:SS.FFF'), numSeconds, 'second');
    OBD.endTime = addtodate(OBD.endTime, numMilliseconds, 'millisecond');
    OBD.endTime = datestr(OBD.endTime, 'HH:MM:SS.FFF');
end