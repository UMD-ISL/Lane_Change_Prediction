function sigDataOut = downSamplingSigs(timeStampVector, sigDataIn)
    DeltaT = datenum('3 Sep 2014 17:00:00.100') - ...
                datenum('3 Sep 2014 17:00:00.000');
            
    sigDataOut = sigDataIn;
    sigDataOut.data = [timeStampVector, NaN(size(timeStampVector, 1), ...
                        size(sigDataIn.data, 2) -1)];
    
    %% ===== interpolation first before ===================
    for j = 2:size(sigDataOut.data, 2)
        sigDataIn.data(:, j) = inpaint_nans(sigDataIn.data(:, j));
    end
    
    %% ============== down sampling using average ===================
    tic;
    for i = 1:size(timeStampVector, 1)
        temp = bsxfun(@minus, sigDataIn.data(:, 1), ...
                            timeStampVector(i, 1));
        [location, ~] = find( temp <= 0 & temp > -DeltaT );
        if isempty(location)
            disp('error');
            disp(i);
            sigDataOut.data(i, 2:end) = sigDataIn.data(1, 2:end);       
        else
            sigDataOut.data(i, 2:end) = mean(sigDataIn.data(location, 2:end)); 
        end
            
    end
    toc;
end