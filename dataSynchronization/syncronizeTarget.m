function syncTarget = syncronizeTarget(Target, timeStampVector, lenEventWindow)
    
    %% ============= synchronize the target data =============
    syncTarget = Target;
    syncTarget.data = [timeStampVector, zeros(size(timeStampVector))];
    
    LCrows = find(1 == Target.data(:, 2));
    for i = 1:length(LCrows)
        LCtimeStamp = Target.data(LCrows(i), 1); 
        [~, LCpos] = min(abs(timeStampVector - LCtimeStamp));
        syncTarget.data(LCpos - lenEventWindow : LCpos - 1, 2) = 1; % 1 means lane change
    end
    
    NLCrows = find(2 == Target.data(:, 2));
    for i = 1:length(NLCrows)
        LCtimeStamp = Target.data(NLCrows(i), 1); 
        [~, LCpos] = min(abs(timeStampVector - LCtimeStamp));
        syncTarget.data(LCpos - lenEventWindow : LCpos - 1, 2) = 2; % 1 means lane change
    end

end