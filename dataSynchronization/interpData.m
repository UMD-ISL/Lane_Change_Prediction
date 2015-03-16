function interpData(barData, comStartTime, comEndTime, savefile)
    DeltaT = datenum('3 Sep 2014 17:00:00.100') - ...
                datenum('3 Sep 2014 17:00:00.000');
    sampFreq = 10;
    timeStampVector = (comStartTime:DeltaT:comEndTime)';
    lenEventWindow = 2 * sampFreq;  % 2 seconds * smapling frequency
    
    %% ============= synchronize the target data =============
    Target = barData.preprocTarget;
    syncTarget = syncronizeTarget(Target, timeStampVector, lenEventWindow);
    
    %% ========= upsampling data to 10 Hz =================
    GSR = barData.preprocGSR;
    GSR.data = GSR.data(GSR.data(:,1) >= comStartTime ...
                    & GSR.data(:, 1) <= comEndTime, :);
    syncGSR = upSamplingSigs(timeStampVector, GSR);
    
    ECG = barData.preprocECG;
    ECG.data = ECG.data(ECG.data(:,1) >= comStartTime ...
                    & ECG.data(:, 1) <= comEndTime, :);
    syncECG = upSamplingSigs(timeStampVector, ECG);

    RSP = barData.preprocRSP;
    RSP.data = RSP.data(RSP.data(:,1) >= comStartTime ...
                    & RSP.data(:, 1) <= comEndTime, :);
    syncRSP = upSamplingSigs(timeStampVector, RSP);

    GSRraw = barData.preprocGSRraw;
    GSRraw.data = GSRraw.data(GSRraw.data(:,1) >= comStartTime ...
                    & GSRraw.data(:, 1) <= comEndTime, :);
    syncGSRraw = upSamplingSigs(timeStampVector, GSRraw);
    
    %% ========= downsampling data to 10 Hz =================
    ECGraw = barData.preprocECGraw;
    ECGraw.data = ECGraw.data(ECGraw.data(:,1) >= comStartTime ...
                    & ECGraw.data(:, 1) <= comEndTime, :);
    syncECGraw = downSamplingSigs(timeStampVector, ECGraw);
    
    RSPraw = barData.preprocRSPraw;
    RSPraw.data = RSPraw.data(RSPraw.data(:,1) >= comStartTime ...
                    & RSPraw.data(:, 1) <= comEndTime, :);
    syncRSPraw = downSamplingSigs(timeStampVector, RSPraw);
    
    %% ========= save output file ==============================
    save(savefile, 'syncGSR', 'syncECG', 'syncRSP', 'syncGSRraw', ...
                'syncECGraw', 'syncRSPraw', 'syncTarget');
end