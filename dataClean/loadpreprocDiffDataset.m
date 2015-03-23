function [allDiffGSRdata, allDiffECGdata, allDiffRSPdata, ...
           allDiffGSRrawData, allDiffECGrawData, ...
           allDiffRSPrawData, allTarget] = loadpreprocDiffDataset(outputPath, ...
                                       numProcDataFiles, procDataFilesName)
    %%
    allDiffGSRdata      = [];
    allDiffECGdata      = [];
    allDiffRSPdata      = [];
    allDiffGSRrawData   = [];
    allDiffECGrawData   = [];
    allDiffRSPrawData   = [];
    allTarget       = [];
    
    %%
    for i = 1:numProcDataFiles
        procDataFilePath = strcat(outputPath, '/dataPreprocessOutput/', ...
            procDataFilesName{1, i});
        bar = load(procDataFilePath);
        allDiffGSRdata      = [allDiffGSRdata; diff(bar.preprocGSR.data(:, 2:end))];
        allDiffECGdata      = [allDiffECGdata; diff(bar.preprocECG.data(:, 2:end))];
        allDiffRSPdata      = [allDiffRSPdata; diff(bar.preprocRSP.data(:, 2:end))];
        allDiffGSRrawData   = [allDiffGSRrawData; diff(bar.preprocGSRraw.data(:, 2:end))];
        allDiffECGrawData   = [allDiffECGrawData; diff(bar.preprocECGraw.data(:, 2:end))];
        allDiffRSPrawData   = [allDiffRSPrawData; diff(bar.preprocRSPraw.data(:, 2:end))];
        allTarget       = [allTarget; bar.preprocTarget];
    end
end