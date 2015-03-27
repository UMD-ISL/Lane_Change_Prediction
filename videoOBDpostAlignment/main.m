function main(preprocOBD)
    close all; clc;
    [fileName,pathName] = uigetfile('*.mp4','choose a video');
    videoObj = VideoReader([pathName,fileName]);
    numFrame = get(videoObj, 'NumberOfFrames');
    startFrameInd = 1;
    startFrame = read(videoObj, startFrameInd);

    imshow(startFrame);
    cropFramePosition = getrect;
    close(figure(1));
    corpedImg = imcrop(startFrame, cropFramePosition);
    [rows, columns, ~] = size(corpedImg);
    cropFrameSize = rows * columns;

    lateralWindowSize = 3;
    [diffRecord, secDiffRecord] = frameComparison(lateralWindowSize, ...
                                        videoObj, cropFramePosition, ...
                                        cropFrameSize, numFrame);
                    
    finalCurve.diffR = smooth(diffRecord.chR);
    finalCurve.diffG = smooth(diffRecord.chG);
    finalCurve.diffB = smooth(diffRecord.chB);
    finalCurve.diffRGB = smooth(diffRecord.chRGB);
    
    finalCurve.secDiffR = smooth(secDiffRecord.chR);
    finalCurve.secDiffG = smooth(secDiffRecord.chG);
    finalCurve.secDiffB = smooth(secDiffRecord.chB);
    finalCurve.secDiffRGB = smooth(secDiffRecord.chRGB);
    
    save('record(average3x3+7+R.G.B+RGB).mat','finalCurve');
    
    %%
    figure;
    subplot(3, 1, 1);
    plot(0:1/30:120, finalCurve.diffRGB);
    title('fisrt order difference of video frame');
    xlabel('seconds');
    
    subplot(3, 1, 2);
    plot(0:1/30:120, finalCurve.secDiffRGB);
    title('second order difference of video frame');
    xlabel('seconds');
    
    subplot(3, 1, 3);
    OBDdata = cellfun(@str2num, preprocOBD.data(:, 2));
    startInd = 165200;
    plot(0:0.01:120, OBDdata(startInd:12000+startInd));
    title('OBD speed data');
    xlabel('seconds');
    ylabel('speed (mph)');
end
