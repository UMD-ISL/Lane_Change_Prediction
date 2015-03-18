function calFeatureVec(lenFeatureWindow, featureVecParams, ...
                                    selectedSigsData, savefile)
    
    numFeatureFunc = length(featureVecParams);
    numSelectedSigs = size(selectedSigsData(:, 3:end), 2);
    
    featureVec = zeros(size(selectedSigsData ,1) - lenFeatureWindow, ...
                        numSelectedSigs * numFeatureFunc);
    
    for i = 21:size(selectedSigsData, 1)
        winSigData = selectedSigsData(i - lenFeatureWindow:i-1, 3:end);
        onePointFeatureVec = zeros(numFeatureFunc, numSelectedSigs);
        
        onePointFeatureVec(1, :) = winSigData(end, :);
        onePointFeatureVec(2, :) = max(winSigData);
        onePointFeatureVec(3, :) = min(winSigData);
        onePointFeatureVec(4, :) = winSigData(end, :) - winSigData(end-1, :);
        
        %% new features
        onePointFeatureVec(5, :) = std(winSigData);
        onePointFeatureVec(6, :) = mean(winSigData);
        onePointFeatureVec(7, :) = median(winSigData);
        onePointFeatureVec(8, :) = sum(abs(winSigData).^2);
        onePointFeatureVec(9, :) = skewness(winSigData);
        onePointFeatureVec(10, :) = kurtosis(winSigData);
        
        featureVec(i - 20, :) = reshape(onePointFeatureVec, 1, ...
                                    numSelectedSigs * numFeatureFunc);
    end
    
    scaledFeatureVec = scaleFeature(featureVec);
    
    scaledFeatureVec = [selectedSigsData(lenFeatureWindow + 1:end, 1:2), ...
                    scaledFeatureVec];
                
    save(savefile, 'scaledFeatureVec');
end