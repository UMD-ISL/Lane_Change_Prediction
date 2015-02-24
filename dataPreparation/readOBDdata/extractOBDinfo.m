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
end