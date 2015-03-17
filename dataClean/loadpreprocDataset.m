function [allGSRdata, allECGdata, allRSPdata, ...
           allGSRrawData, allECGrawData, ...
           allRSPrawData, allTarget] = loadpreprocDataset(outputPath, ...
                                       numProcDataFiles, procDataFilesName)
    %%
    allGSRdata      = [];
    allECGdata      = [];
    allRSPdata      = [];
    allGSRrawData   = [];
    allECGrawData   = [];
    allRSPrawData   = [];
    allTarget       = [];
    
    %%
    for i = 1:numProcDataFiles
        procDataFilePath = strcat(outputPath, '/dataPreprocessOutput/', ...
            procDataFilesName{1, i});
        bar = load(procDataFilePath);
        allGSRdata      = [allGSRdata; bar.preprocGSR];
        allECGdata      = [allECGdata; bar.preprocECG];
        allRSPdata      = [allRSPdata; bar.preprocRSP];
        allGSRrawData   = [allGSRrawData; bar.preprocGSRraw];
        allECGrawData   = [allECGrawData; bar.preprocECGraw];
        allRSPrawData   = [allRSPrawData; bar.preprocRSPraw];
        allTarget       = [allTarget; bar.preprocTarget];
    end
end