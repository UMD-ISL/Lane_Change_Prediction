function signal = extractSiginfo(sigName, recordDataPath)
    sigFile = cell2mat(strcat(recordDataPath, '/', sigName, '.csv'));
    sigString =  cell2mat(sigName);
    switch sigString
        case 'OBD'
            signal = extractOBDinfo(sigFile);
        otherwise
            fid = fopen(sigFile);
            headerString = fgetl(fid);
            signal.params = getSigParamsHeader(headerString);
            signal.data = extractSigCSVdata(fid, signal.params);
            fclose(fid);
            signal.startTime = getSigStartTime(signal.params, signal.data);
    end
    
    if strcmp(sigString, 'GSRraw')
        signal.startTime = datenum(signal.startTime, 'HH:MM:SS.FFF');
        signal.startTime = addtodate(signal.startTime, 4, 'hour');
        signal.startTime = datestr(signal.startTime, 'HH:MM:SS.FFF');
    end
end