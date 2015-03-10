function convertDataFormat(bardata, savefile)       
        preprocGSR = bardata.prepedGSR;
        preprocECG = bardata.prepedECG;
        preprocRSP = bardata.prepedRSP;
        preprocGSRraw = bardata.prepedGSRraw;
        preprocECGraw = bardata.prepedECGraw;
        preprocRSPraw = bardata.prepedRSPraw;
        preprocOBD = bardata.prepedOBD;
        preprocTarget = bardata.prepedTarget;
        
        recordDate = preprocOBD.startDate;
%         OBDstartTime = [preprocOBD.startDate, ' ', preprocOBD.startTime];
        
        %%
        [preprocGSR.params, preprocGSR.data] = strcell2number(preprocGSR.params, ...
                                                preprocGSR.data, recordDate);
        
        [preprocECG.params, preprocECG.data] = strcell2number(preprocECG.params, ...
                                                preprocECG.data, recordDate);
        
        [emptyLocationX, emptyLocationY] = find(ismember(preprocRSP.data, '')==1);
        preprocRSP.data(emptyLocationX, emptyLocationY) = cellstr('NaN');
        
        [preprocRSP.params, preprocRSP.data] = strcell2number(preprocRSP.params, ...
                                                preprocRSP.data, recordDate);
                                            
        [preprocGSRraw.params, preprocGSRraw.data] = strcell2number(preprocGSRraw.params, ...
                                                preprocGSRraw.data, recordDate);
        
        [preprocECGraw.params, preprocECGraw.data] = strcell2number(preprocECGraw.params, ...
                                                preprocECGraw.data, recordDate);

        [preprocRSPraw.params, preprocRSPraw.data] = strcell2number(preprocRSPraw.params, ...
                                                preprocRSPraw.data, recordDate);
        
        absoluteTime = datenum([recordDate, ' ', preprocOBD.startTime]);
        timeDelay = 2.078;
        vidStartTime = absoluteTime + timeDelay / 86400;
        
        preprocTarget.data = zeros(size(preprocTarget.data));
        for j = 1:size(preprocTarget.data, 1)
            preprocTarget.data(j, 1) = vidStartTime + ...
                        datenum([preprocOBD.startDate, ' ', ...
                        bardata.prepedTarget.data{j, 1}]) - ...
                        datenum([preprocOBD.startDate, ' ', '00:00:00.000']);
        end
        preprocTarget.data(:, 2) = str2double(bardata.prepedTarget.data(:, 2));
        
        save(savefile, 'preprocGSR', 'preprocECG', 'preprocRSP', 'preprocGSRraw', ...
                'preprocECGraw', 'preprocRSPraw', 'preprocOBD', 'preprocTarget');
end