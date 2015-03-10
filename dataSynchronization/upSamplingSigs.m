function sigDataOut = upSamplingSigs(timeStampVector, sigDataIn)
    sigDataOut = sigDataIn;
    sigDataOut.data = [timeStampVector, NaN(size(timeStampVector, 1), ...
                        size(sigDataIn.data, 2) -1)];
    
    for i = 1:size(sigDataIn.data, 1)
        [~, idx] = min(abs(bsxfun(@minus, timeStampVector, ...
                        sigDataIn.data(i, 1))));
        sigDataOut.data(idx, 2:end) = sigDataIn.data(i, 2:end);        
    end
    
    for j = 2:size(sigDataOut.data, 2)
        sigDataOut.data(:, j) = inpaint_nans(sigDataOut.data(:, j));
    end
end