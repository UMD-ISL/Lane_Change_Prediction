function [procSigDataset, meanSigVariance, stdSigVariance, ...
            maxSigData, minSigData] = cleanOneSig(procSigDataset)   
    %% =============== process GSR signal ====================
    allSigdataBefore = [];
    allSigDiffdata = [];
    for i = 1:size(procSigDataset, 1)
        allSigdataBefore = [allSigdataBefore; ...
            procSigDataset(i).data(:, 2:end)];
        allSigDiffdata = [allSigDiffdata; ...
                    diff(procSigDataset(i).data(:, 2:end))];
    end
    figure;
    subplot(3, 1, 1);
    plot(allSigdataBefore(:, 1));
    subplot(3, 1, 2);
    plot(allSigDiffdata(:, 1));
    
    meanSigData = nanmean(allSigdataBefore);
    stdSigData = nanmean(allSigdataBefore);
    
    meanSigVariance = nanmean(allSigDiffdata);
    stdSigVariance = nanstd(allSigDiffdata);
    
    maxSigData = meanSigData + stdSigData + 3*stdSigVariance;
    minSigData = meanSigData - stdSigData - 3*stdSigVariance;

    for i = 1:size(procSigDataset, 1)
        SigData = procSigDataset(i).data;
        for j = 2:size(SigData, 2)
            outlierInd = (SigData(:, j) > maxSigData(j-1) | ...
                    SigData(:, j) < minSigData(j-1));
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
    subplot(3, 1, 3);
    plot(allSigdataAfter(:, 1));
    
end