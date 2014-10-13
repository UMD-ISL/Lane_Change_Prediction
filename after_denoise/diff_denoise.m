for j = 1 : 5
    cd ..
    temp = strcat('Before_denoise/Before_denoise', num2str(j),'.mat');
    load(temp);


    diff_EcgHR = diff(EcgData(:, 2));
    diff_EcgRR = diff(EcgData(:, 3));
    diff_EcgRaw = diff(ECG_RAWData(:, 2));
    EcgDataHR_New = EcgData(:, 1:2);
    EcgDataRR_New = EcgData(:, [1, 3]);
    ECG_RAWData_New = ECG_RAWData;
    
    % HR
    i = 1;
    while i < numel(diff_EcgHR)
        if    diff_EcgHR(i) > 30 ...
            | diff_EcgHR(i) < -30 ...
            | EcgDataHR_New(i + 1, 2) > 120 ...
            | EcgDataHR_New(i + 1, 2) < 50
            
            EcgDataHR_New(i + 1, :) = [NaN];
            if sign(diff_EcgHR(i)) ~= sign(diff_EcgHR(i + 1))
                if sign(diff_EcgHR(i + 1)) == -1 & EcgDataHR_New(i + 2, 2) < 50
                elseif sign(diff_EcgHR(i + 1)) == 1 & EcgDataHR_New(i + 2, 2) > 120
                else
                    i = i + 1;
                end
            end
            
        end
        i = i + 1;
    end
    
    % RR
    i = 1;
    while i < numel(diff_EcgRR)
        if    diff_EcgRR(i) > 0.3 ...
            | diff_EcgRR(i) < -0.3 ...
            | EcgDataRR_New(i + 1, 2) > 1 ...
            | EcgDataRR_New(i + 1, 2) < 0.5
            
            EcgDataRR_New(i + 1, :) = [NaN];
            if sign(diff_EcgRR(i)) ~= sign(diff_EcgRR(i + 1))
                if sign(diff_EcgRR(i + 1)) == -1 & EcgDataRR_New(i + 2, 2) < 50
                elseif sign(diff_EcgRR(i + 1)) == 1 & EcgDataRR_New(i + 2, 2) > 120
                else
                    i = i + 1;
                end
            end
            
        end
        i = i + 1;
    end
    
    % ECG_RAW
%     i = 1;
%     while i < numel(diff_EcgRaw)
%         if    diff_EcgRaw(i) > 50 ...
%             | diff_EcgRaw(i) < -150 ...
%             | ECG_RAWData_New(i + 1, 2) > 12000 ...
%             | ECG_RAWData_New(i + 1, 2) < -50
%             
%             ECG_RAWData_New(i + 1, :) = [NaN];
%             if sign(diff_EcgRaw(i)) ~= sign(diff_EcgRaw(i + 1))
%                 i = i + 1;
%             end
%             
%         end
%         i = i + 1;
%     end
    
    save(strcat('N:\tianyu\code\final code\experiment5_25\after_denoise\afterDenoise_', num2str(j), '.mat'),'EcgDataHR_New', 'diff_EcgHR', 'EcgDataRR_New', 'diff_EcgRR');
end