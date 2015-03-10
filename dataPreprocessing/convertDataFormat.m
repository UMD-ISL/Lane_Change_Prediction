function convertDataFormat(labdata, savefile)       
        preprocGSR = labdata.prepedGSR;
        preprocECG = labdata.prepedECG;
        preprocRSP = labdata.prepedRSP;
        preprocGSRraw = labdata.prepedGSRraw;
        preprocECGraw = labdata.prepedECGraw;
        preprocRSPraw = labdata.prepedRSPraw;
        preprocOBD = labdata.prepedOBD;
%         preprocTarget = labdata.prepedTarget;
        
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
        
        save(savefile, 'preprocGSR', 'preprocECG', 'preprocRSP', 'preprocGSRraw', ...
                'preprocECGraw', 'preprocRSPraw', 'preprocOBD');
end