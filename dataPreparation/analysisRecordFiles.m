function [structGSR, structECG, structRSP, ...
       structGSRraw, structECGraw, structRSPraw ] = analysisRecordFiles(...
                                        recordDataPath, signalVector)    
    %%
    structGSR = extractSiginfo(signalVector(1), recordDataPath);
    structECG = extractSiginfo(signalVector(2), recordDataPath);
    structRSP = extractSiginfo(signalVector(3), recordDataPath);

    %%
    structGSRraw = extractSiginfo(signalVector(4), recordDataPath);
    structECGraw = extractSiginfo(signalVector(5), recordDataPath);
    structRSPraw = extractSiginfo(signalVector(6), recordDataPath);
    
    
end