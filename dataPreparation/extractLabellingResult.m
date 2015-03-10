function target = extractLabellingResult(recordDataPath, vidOBDoffset, ...
                                       OBDstartDate)
    labelingFile = cell2mat(strcat(cellstr(recordDataPath), '/target', '.csv'));
    fid = fopen(labelingFile);
    headerString = fgetl(fid);
    labeling.params = getSigParamsHeader(headerString);
    target.Params = {'TimeStart', 'LaneChange'};
    target.data = getLabelingdata(target.Params, labeling.params, fid);
    fclose(fid);
end