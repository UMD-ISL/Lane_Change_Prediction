function [diffRecord, secDiffRecord] = frameComparison(lateralWindowSize, ...
                    videoObj, cropFramePosition, cropFrameSize, numFrame)
                        
    recordR = zeros(1, numFrame);
    recordG = zeros(1, numFrame);
    recordB = zeros(1, numFrame);
    recordRGB = zeros(1, numFrame);
    
    windowSize = 2 * lateralWindowSize + 1;
    curFrameInd = lateralWindowSize + 1;
    
    sumFrameBuffer = 0;
    centralWinInd = (windowSize + 1) / 2;
    
    frameBuffer = cell(1, windowSize);
    frameBuffer{1} = zeros(size(getImage(videoObj, 1, cropFramePosition)));
    
    for bufferInd = 2:windowSize
        frameBuffer{bufferInd} = getImage(videoObj, bufferInd, ...
                                            cropFramePosition);
        sumFrameBuffer = sumFrameBuffer + frameBuffer{bufferInd};
    end
    
    while curFrameInd < numFrame - lateralWindowSize
        sumFrameBuffer = sumFrameBuffer - frameBuffer{1};
        frameBuffer(1:end-1) = frameBuffer(2:end);
        frameBuffer{end} = getImage(videoObj, curFrameInd + ...
                                    lateralWindowSize, cropFramePosition);
        sumFrameBuffer = sumFrameBuffer + frameBuffer{end};
        
        diffCurFrame = windowSize * frameBuffer{centralWinInd} - sumFrameBuffer;
        absDiffCurFrame = abs(diffCurFrame);

        recordR(1, curFrameInd) = sum(sum(absDiffCurFrame(:,:,1)))/cropFrameSize;
        recordG(1, curFrameInd) = sum(sum(absDiffCurFrame(:,:,2)))/cropFrameSize;
        recordB(1, curFrameInd) = sum(sum(absDiffCurFrame(:,:,3)))/cropFrameSize;

        recordRGB(1, curFrameInd) = sum(recordR(1, curFrameInd) + ...
                            recordG(1, curFrameInd) + recordB(1, curFrameInd));
                        
        curFrameInd = curFrameInd + 1;    
        if 0 == mod(curFrameInd,1000)
            fprintf('This is frame %d\n',curFrameInd);
        end
    end
    
    diffRecord.chR = recordR;
    secDiffRecord.chR = [0, abs(diff(recordR))];
    diffRecord.chG = recordG;
    secDiffRecord.chG = [0, abs(diff(recordG))];
    diffRecord.chB = recordB;
    secDiffRecord.chB = [0, diff(recordB)];
    diffRecord.chRGB = recordRGB;
    secDiffRecord.chRGB = [0, abs(diff(recordRGB))];
end
