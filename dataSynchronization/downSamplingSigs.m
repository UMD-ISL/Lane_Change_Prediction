function sigDataOut = downSamplingSigs(timeStampVector, sigDataIn)
    DeltaT = datenum('3 Sep 2014 17:00:00.100') - ...
                datenum('3 Sep 2014 17:00:00.000');
            
    sigDataOut = sigDataIn;
    sigDataOut.data = [timeStampVector, NaN(size(timeStampVector, 1), ...
                        size(sigDataIn.data, 2) -1)];
    tic;
    for i = 1:size(timeStampVector, 1)
        temp = bsxfun(@minus, sigDataIn.data(:, 1), ...
                            timeStampVector(i, 1));
        [location, ~] = find( temp <= 0 & temp > -DeltaT );
        sigDataOut.data(i, 2:end) = mean(sigDataIn.data(location, 2:end));     
    end
    toc;
end