function prepedData = loadData(PrepedDataFilePath)
    load(PrepedDataFilePath);
    prepedData.GSR = prepedGSR;
    prepedData.ECG = prepedECG;
    prepedData.RSP = prepedRSP;
    prepedData.GSRraw = prepedGSRraw;
    prepedData.ECGraw = prepedECGraw;
    prepedData.RSPraw = prepedRSPraw;
    prepedData.OBD = prepedOBD;
end