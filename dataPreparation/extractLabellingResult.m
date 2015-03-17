function target = extractLabellingResult(recordDataPath)
    labelingFile = cell2mat(strcat(cellstr(recordDataPath), '/target', '.csv'));
    fid = fopen(labelingFile);
    headerString = fgetl(fid);
    labeling.params = getSigParamsHeader(headerString);
    target.params = {'TimeStart', 'LaneChange'};
    target.data = getLabelingdata(target.params, labeling.params, fid);
    fclose(fid);
end