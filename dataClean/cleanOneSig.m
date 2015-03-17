function [procSigDataset, meanSigdata, ...
                                    stdSigdata] = cleanOneSig(procSigDataset)   
    %% =============== process GSR signal ====================
    allSigdataBefore = [];
    for i = 1:size(procSigDataset, 1)
        allSigdataBefore = [allSigdataBefore; ...
            procSigDataset(i).data(:, 2:end)];
    end
    figure
    plot(allSigdataBefore(:, 1));
    
    meanSigdata = nanmean(allSigdataBefore);
    stdSigdata = nanstd(allSigdataBefore);
    
    maxSigdata = meanSigdata + 3*stdSigdata;
    minSigdata = meanSigdata - 3*stdSigdata;

    for i = 1:size(procSigDataset, 1)
        SigData = procSigDataset(i).data;
        for j = 2:size(SigData, 2)
            outlierInd = SigData(:, j) > maxSigdata(j-1) | ...
                SigData(:, j) < minSigdata(j-1);
            SigData(outlierInd, j) = NaN;
        end
        procSigDataset(i).data = SigData;
    end
    
    %% ======================== test code =================================
    allSigdataAfter = [];
    for i = 1:size(procSigDataset, 1)
        allSigdataAfter = [allSigdataAfter; ...
                procSigDataset(i).data(:, 2:end)];
    end
    figure;
    plot(allSigdataAfter(:, 1));
    
end