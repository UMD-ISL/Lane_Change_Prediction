function inputData = readLabelResultFile(inputData, Data_Path, videoIndex)
    % Read labelled result (target)
    [inputData.target_Data, inputData.target_Txt, ~] = xlsread(strcat( ...
        Data_Path, '/', num2str(videoIndex), '/target.xls'));      
    inputData.target_Idx = inputData.target_Data;
end